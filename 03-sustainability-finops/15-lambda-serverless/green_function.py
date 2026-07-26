import json
import logging
import os
from datetime import datetime, timezone
from hashlib import sha256
from typing import Any

import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

DYNAMODB_TABLE = os.getenv("DYNAMODB_TABLE", "")
SES_FROM_EMAIL = os.getenv("SES_FROM_EMAIL", "")
ENABLE_SES = os.getenv("ENABLE_SES", "false").lower() == "true"
ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")

dynamodb = boto3.resource("dynamodb")
ses_client = boto3.client("ses")
table = dynamodb.Table(DYNAMODB_TABLE) if DYNAMODB_TABLE else None


def _extract_detail(event: dict[str, Any]) -> dict[str, Any]:
	if isinstance(event.get("detail"), dict):
		return event["detail"]

	if any(key in event for key in ("event_id", "studente_email", "corso_nome")):
		return event

	raise ValueError("Payload non valido: manca il campo detail")


def _build_event_id(detail: dict[str, Any]) -> str:
	for key in ("event_id", "id", "request_id"):
		value = detail.get(key)
		if isinstance(value, str) and value.strip():
			return value.strip()

	payload_fingerprint = sha256(
		json.dumps(detail, sort_keys=True, default=str).encode("utf-8")
	).hexdigest()
	return f"generated-{payload_fingerprint[:24]}"


def _mark_event_processed(event_id: str) -> bool:
	if table is None:
		logger.warning("DYNAMODB_TABLE non configurata: idempotenza disabilitata")
		return True

	try:
		table.put_item(
			Item={
				"event_id": event_id,
				"processed_at": datetime.now(timezone.utc).isoformat(),
				"environment": ENVIRONMENT,
			},
			ConditionExpression="attribute_not_exists(event_id)",
		)
		return True
	except ClientError as exc:
		code = exc.response.get("Error", {}).get("Code")
		if code == "ConditionalCheckFailedException":
			logger.info("Evento duplicato ignorato: %s", event_id)
			return False
		raise


def _send_email(detail: dict[str, Any], event_id: str) -> dict[str, str]:
	if not ENABLE_SES:
		return {"status": "skipped", "reason": "ENABLE_SES=false"}

	recipient = detail.get("studente_email")
	if not recipient:
		return {"status": "skipped", "reason": "studente_email assente"}

	if not SES_FROM_EMAIL:
		return {"status": "skipped", "reason": "SES_FROM_EMAIL non valorizzata"}

	subject = f"[{ENVIRONMENT}] Conferma iscrizione corso"
	body = (
		f"Ciao {detail.get('studente_nome', 'Studente')},\n\n"
		f"la tua iscrizione al corso '{detail.get('corso_nome', 'N/D')}' e' stata registrata.\n"
		f"Event ID: {event_id}\n"
		f"Data iscrizione: {detail.get('data_iscrizione', 'N/D')}\n\n"
		"Messaggio generato automaticamente."
	)

	try:
		response = ses_client.send_email(
			Source=SES_FROM_EMAIL,
			Destination={"ToAddresses": [recipient]},
			Message={
				"Subject": {"Data": subject},
				"Body": {"Text": {"Data": body}},
			},
		)
		return {"status": "sent", "message_id": response["MessageId"]}
	except ClientError as exc:
		logger.warning("Invio email fallito: %s", exc)
		return {"status": "error", "reason": str(exc)}


def lambda_handler(event: dict[str, Any], context: Any) -> dict[str, Any]:
	del context
	logger.info("Evento ricevuto: %s", json.dumps(event))

	try:
		detail = _extract_detail(event)
		event_id = _build_event_id(detail)

		if not _mark_event_processed(event_id):
			return {
				"statusCode": 200,
				"body": json.dumps(
					{
						"status": "duplicate",
						"event_id": event_id,
						"message": "Evento gia' processato",
					}
				),
			}

		email_result = _send_email(detail, event_id)
		return {
			"statusCode": 200,
			"body": json.dumps(
				{
					"status": "processed",
					"event_id": event_id,
					"studente_email": detail.get("studente_email"),
					"email_result": email_result,
				}
			),
		}
	except Exception as exc:  # pragma: no cover - runtime safety
		logger.exception("Errore durante il processing")
		return {
			"statusCode": 500,
			"body": json.dumps(
				{
					"status": "error",
					"message": str(exc),
				}
			),
		}
