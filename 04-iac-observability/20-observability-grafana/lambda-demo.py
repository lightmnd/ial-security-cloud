"""
Lambda demo – Lezione 20: Osservabilità con Grafana
Genera metriche CloudWatch reali (Invocations, Duration, Errors)
utili per i pannelli del dashboard Grafana/CloudWatch.
"""

import json
import logging
import os
import random
import time

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    """
    Entry point della Lambda demo.

    Ogni invocazione:
    - logga un messaggio strutturato (visibile in CloudWatch Logs)
    - simula una durata variabile per rendere il grafico Duration più interessante
    - restituisce un payload JSON con metadati utili

    CloudWatch registra automaticamente le metriche:
      - Invocations  → +1 ad ogni chiamata
      - Duration     → tempo effettivo di esecuzione in ms
      - Errors       → +1 solo se la funzione solleva un'eccezione
    """

    start = time.time()

    function_name = context.function_name
    request_id = context.aws_request_id
    region = os.environ.get("AWS_REGION", "unknown")

    logger.info(
        json.dumps(
            {
                "event": "invocation",
                "function": function_name,
                "request_id": request_id,
                "region": region,
                "input": event,
            }
        )
    )

    # Simula un carico di lavoro variabile (50-300 ms)
    simulated_work_ms = random.randint(50, 300)
    time.sleep(simulated_work_ms / 1000)

    elapsed_ms = round((time.time() - start) * 1000, 2)

    response = {
        "statusCode": 200,
        "function": function_name,
        "request_id": request_id,
        "region": region,
        "simulated_work_ms": simulated_work_ms,
        "elapsed_ms": elapsed_ms,
        "message": "OK – metriche inviate a CloudWatch",
    }

    logger.info(json.dumps({"event": "response", **response}))

    return response
