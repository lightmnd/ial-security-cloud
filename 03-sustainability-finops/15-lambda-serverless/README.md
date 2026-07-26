# 📘 Lezione 15 – Lambda Serverless

**📅 Data:** Lunedì 20/07/2025  
**🗂️ Modulo:** Modulo 3 – Sostenibilità & FinOps  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere il modello serverless e il paradigma event-driven
- Creare e deployare una funzione Lambda in Python
- Gestire il cold start e ottimizzare le performance
- Implementare idempotenza e gestione degli errori

## 📚 Concetti Chiave

### Serverless: Scale-to-Zero
In un'architettura serverless, non gestisci server. AWS esegue il tuo codice in risposta a eventi e scala automaticamente da 0 a migliaia di esecuzioni concorrenti. Paghi solo per le esecuzioni effettive (tempo × memoria), non per il tempo idle.

**Vantaggi:**
- Costo zero quando non usato (scale-to-zero)
- Scaling automatico e illimitato
- Nessun patching del SO o del runtime
- Sostenibilità: risorse consumate solo durante l'esecuzione

**Limiti AWS Lambda:**
- Timeout massimo: 15 minuti
- Memoria: 128 MB – 10 GB
- Storage temporaneo: 512 MB – 10 GB (/tmp)
- Dimensione pacchetto: 50 MB (zip) / 250 MB (unzipped)

### Cold Start: Il Tallone d'Achille
Quando una funzione Lambda non viene invocata per un po', AWS "congela" il container. La prima invocazione successiva richiede di:
1. Avviare un nuovo container (millisecondi)
2. Scaricare il codice
3. Inizializzare il runtime Python
4. Eseguire il codice di inizializzazione fuori dall'handler

**Mitigazioni:**
- Usa Lambda SnapStart (Java) o Provisioned Concurrency
- Minimizza le dipendenze (usa Lambda Layers per condividere librerie)
- Mantieni il codice di init fuori dall'handler leggero
- Usa container images per funzioni con molte dipendenze

### Pattern Event-Driven con Lambda

```
SQS Queue  →  Lambda  →  DynamoDB (idempotency check)
EventBridge →  Lambda  →  SES (email notification)
S3 Event   →  Lambda  →  Processamento file
API Gateway → Lambda  →  REST API handler
```

## 🛠️ Hands-on: Funzione Lambda per Iscrizioni

### Prerequisiti
- AWS CLI configurata con permessi `lambda:*`, `iam:*`
- Python 3.12 installato localmente

### Step 1: Esaminare la funzione Lambda esistente

```bash
cat 03-sustainability-finops/15-lambda-serverless/green_function.py
```

### Step 2: Creare il ruolo IAM per Lambda

```bash
# Crea il ruolo con la trust policy
aws iam create-role \
  --role-name gestionale-lambda-role \
  --assume-role-policy-document file://03-sustainability-finops/15-lambda-serverless/trust-policy.json

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Permessi base per CloudWatch Logs
aws iam attach-role-policy \
  --role-name gestionale-lambda-role \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Permessi aggiuntivi per SES e DynamoDB
cat > lambda-inline-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ses:SendEmail", "ses:SendRawEmail"],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["dynamodb:GetItem", "dynamodb:PutItem"],
      "Resource": "arn:aws:dynamodb:eu-west-1:${ACCOUNT_ID}:table/gestionale-idempotency"
    }
  ]
}
EOF

aws iam put-role-policy \
  --role-name gestionale-lambda-role \
  --policy-name gestionale-lambda-permissions \
  --policy-document file://lambda-inline-policy.json

ROLE_ARN=$(aws iam get-role --role-name gestionale-lambda-role --query 'Role.Arn' --output text)
aws iam wait role-exists --role-name gestionale-lambda-role
echo "Ruolo creato: $ROLE_ARN"
```

### Step 3: Creare la tabella DynamoDB per idempotenza

```bash
aws dynamodb create-table \
  --table-name gestionale-idempotency \
  --attribute-definitions AttributeName=event_id,AttributeType=S \
  --key-schema AttributeName=event_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region eu-west-1

aws dynamodb wait table-exists \
  --table-name gestionale-idempotency \
  --region eu-west-1

echo "Tabella DynamoDB creata per idempotenza"
```

### Step 4: Deploy della funzione Lambda

```bash
# Crea il pacchetto ZIP
zip -j 03-sustainability-finops/15-lambda-serverless/green_function.zip \
  03-sustainability-finops/15-lambda-serverless/green_function.py

# Deploy della funzione
aws lambda create-function \
  --function-name gestionale-iscrizioni \
  --runtime python3.12 \
  --role $ROLE_ARN \
  --handler green_function.lambda_handler \
  --zip-file fileb://03-sustainability-finops/15-lambda-serverless/green_function.zip \
  --timeout 30 \
  --memory-size 256 \
  --environment "Variables={DYNAMODB_TABLE=gestionale-idempotency,SES_FROM_EMAIL=noreply@gestionale.ial.it,ENABLE_SES=false,ENVIRONMENT=dev}" \
  --description "Funzione per notifiche iscrizione studenti" \
  --region eu-west-1

aws lambda wait function-active \
  --function-name gestionale-iscrizioni \
  --region eu-west-1

echo "Lambda deployata!"
```

### Step 5: Testare la funzione

```bash
# Crea un evento di test
cat > 03-sustainability-finops/15-lambda-serverless/test-event.json << 'EOF'
{
  "source": "gestionale.iscrizioni",
  "detail-type": "StudenteIscritto",
  "detail": {
    "event_id": "test-001",
    "studente_id": 1,
    "studente_nome": "Mario Rossi",
    "studente_email": "mario.rossi@test.com",
    "corso_nome": "Cloud Security & Sostenibilità",
    "data_iscrizione": "2025-07-20"
  }
}
EOF

# Invoca la funzione
aws lambda invoke \
  --cli-binary-format raw-in-base64-out \
  --function-name gestionale-iscrizioni \
  --payload file://03-sustainability-finops/15-lambda-serverless/test-event.json \
  --region eu-west-1 \
  03-sustainability-finops/15-lambda-serverless/response.json

# Visualizza la risposta
cat 03-sustainability-finops/15-lambda-serverless/response.json

# Controlla i log CloudWatch degli ultimi 5 minuti
aws logs tail /aws/lambda/gestionale-iscrizioni --since 5m --region eu-west-1
```

### Step 6: Misurare il Cold Start

```bash
# Prima invocazione (cold start)
LOG_RESULT=$(aws lambda invoke \
  --cli-binary-format raw-in-base64-out \
  --function-name gestionale-iscrizioni \
  --payload file://03-sustainability-finops/15-lambda-serverless/test-event.json \
  --log-type Tail \
  --region eu-west-1 \
  /dev/null \
  --query 'LogResult' \
  --output text)

python3 - "$LOG_RESULT" <<'PY'
import base64
import sys

decoded = base64.b64decode(sys.argv[1]).decode("utf-8", errors="ignore")
for line in decoded.splitlines():
    if "Init Duration" in line or "Duration" in line:
        print(line)
PY

# Seconda invocazione (warm — molto più veloce)
LOG_RESULT=$(aws lambda invoke \
  --cli-binary-format raw-in-base64-out \
  --function-name gestionale-iscrizioni \
  --payload file://03-sustainability-finops/15-lambda-serverless/test-event.json \
  --log-type Tail \
  --region eu-west-1 \
  /dev/null \
  --query 'LogResult' \
  --output text)

python3 - "$LOG_RESULT" <<'PY'
import base64
import sys

decoded = base64.b64decode(sys.argv[1]).decode("utf-8", errors="ignore")
for line in decoded.splitlines():
    if "Duration" in line:
        print(line)
PY
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Elimina la funzione Lambda
aws lambda delete-function --function-name gestionale-iscrizioni --region eu-west-1

# Elimina la tabella DynamoDB
aws dynamodb delete-table --table-name gestionale-idempotency --region eu-west-1

# Elimina il ruolo IAM
aws iam delete-role-policy --role-name gestionale-lambda-role --policy-name gestionale-lambda-permissions
aws iam detach-role-policy --role-name gestionale-lambda-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws iam delete-role --role-name gestionale-lambda-role

# Rimuovi file temporanei
rm -f 03-sustainability-finops/15-lambda-serverless/green_function.zip
rm -f 03-sustainability-finops/15-lambda-serverless/test-event.json
rm -f 03-sustainability-finops/15-lambda-serverless/response.json
rm -f lambda-inline-policy.json
```

## ✅ Checkpoint
- [ ] Comprendo il modello serverless e il cold start
- [ ] Funzione Lambda creata con runtime Python 3.12
- [ ] Funzione testata con payload di test
- [ ] Log CloudWatch visualizzati
- [ ] Idempotency check implementato via DynamoDB

## 📖 Approfondimenti
- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/latest/dg/)
- [Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [Serverless Land (patterns)](https://serverlessland.com/)
- [AWS Lambda Power Tuning](https://github.com/alexcasalboni/aws-lambda-power-tuning)
