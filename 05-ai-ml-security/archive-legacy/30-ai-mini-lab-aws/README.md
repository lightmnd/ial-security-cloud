# Mini-Lab AWS - Secure AI Document Review

**Durata:** 45-60 minuti  
**Obiettivo:** costruire un workflow cloud semplice ma realistico per un servizio AI che processa documenti sensibili, con attenzione a IAM, logging, sicurezza dei dati e controllo dell’output.

## 1. Scenario
Un team interno vuole automatizzare la lettura di documenti aziendali per:
- identificare dati sensibili
- classificare il contenuto
- generare un riassunto semplificato
- conservare un log di accesso e di utilizzo

L'obiettivo non è costruire un modello complesso, ma un pattern sicuro e realistico per AI in cloud.

## 2. Obiettivi formativi
- capire come un servizio AI si integra con AWS
- separare accessi, dati e applicazione
- applicare principi di least privilege e logging
- evitare esposizione accidentale di dati sensibili

## 3. Architettura proposta
- Amazon S3: storage dei documenti
- AWS Lambda: elaborazione del testo e validazione input/output
- Amazon CloudWatch Logs: audit delle chiamate
- IAM Role: permessi minimizzati
- optional: Amazon Bedrock o Comprehend in una seconda fase

## 4. Requisiti
- AWS account con privilegi utili per S3, Lambda, IAM, CloudWatch
- AWS CLI configurata
- Python 3.12 disponibile
- regione di default: eu-west-1

## 5. Setup base

### Passo 1 - creare bucket S3
```bash
aws s3 mb s3://ai-secure-docs-$(date +%s) --region eu-west-1
```

### Passo 2 - abilitare cifratura a riposo
```bash
aws s3api put-bucket-encryption \
  --bucket <bucket-name> \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
```

### Passo 3 - bloccare accessi pubblici
```bash
aws s3api put-public-access-block \
  --bucket <bucket-name> \
  --public-access-block-configuration \
  "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

## 6. Creare una funzione Lambda sicura
Costruiamo una Lambda che legge un file di testo e rileva parole chiave sensibili.

### Esempio di codice Python
```python
import json
import os

SENSITIVE = ["password", "token", "iban", "ssn", "secret", "api_key"]


def lambda_handler(event, context):
    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event["Records"][0]["s3"]["object"]["key"]

    print(f"Processing object: {bucket}/{key}")

    # in un caso reale: leggere il file da S3
    text = "Token di accesso, password, IBAN e dati personali sono presenti in questo documento."
    matches = [word for word in SENSITIVE if word.lower() in text.lower()]

    result = {
        "status": "processed",
        "sensitive_terms_found": matches,
        "risk_level": "high" if matches else "low",
        "document": key,
        "bucket": bucket
    }

    return {
        "statusCode": 200,
        "body": json.dumps(result)
    }
```

### Politica IAM minima consigliata
- `s3:GetObject` solo sul bucket specifico
- `logs:CreateLogGroup`
- `logs:CreateLogStream`
- `logs:PutLogEvents`

### Assenza di privilegi eccessivi
La Lambda non deve avere accesso automatico a tutti i bucket S3, né a risorse non necessarie. L’idea è ridurre la superficie di attacco.

## 7. Fase pratica: invocazione e verifica
### Carica un file di test in S3
```bash
cat > sample.txt <<'EOF'
Cliente: Mario Rossi
IBAN: IT60X0542811101000000123456
Token: secret-demo-123
EOF

aws s3 cp sample.txt s3://<bucket-name>/sample.txt
```

### Verifica log CloudWatch
- aprire la console AWS
- andare in CloudWatch Logs
- controllare il log group della Lambda
- verificare che i record contengano i dati di input e il risultato

## 8. Best practice di sicurezza da applicare subito
- usare bucket policy restrittive
- criptare dati in riposo e in transito
- limitare accessi tramite IAM e ruolo specifico
- registrare tutti gli accessi in CloudTrail
- evitare loggare contenuti sensibili completi
- introdurre review umano per output critici

## 9. Extensio n possibile (opzionale)
In un secondo round, aggiungere:
- Amazon Comprehend per rilevamento PII
- Amazon Bedrock per riassunto di documenti testuali
- Amazon OpenSearch per indexing dei documenti
- valutazione di prompt e guardrails per contenuti sensibili

## 10. Checkpoint finale
- [ ] Ho creato un bucket S3 sicuro
- [ ] Ho applicato cifratura e blocco pubblico
- [ ] Ho creato una Lambda con minimi permessi
- [ ] Ho verificato il log e i risultati
- [ ] Ho identificato un rischio di sicurezza e una correzione

## 11. Debrief docente
Discuta con gli studenti:
- dove si colloca il punto di rischio maggiore?
- quali permessi sono davvero necessari?
- come si evita il leakage di dati sensibili nel log?
- cosa cambia se il sistema usa un modello LLM vero?
