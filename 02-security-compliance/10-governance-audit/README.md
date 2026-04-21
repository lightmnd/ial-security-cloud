# 📘 Lezione 10 – Governance e Audit

**📅 Data:** Mercoledì 01/07/2025  
**🗂️ Modulo:** Modulo 2 – Sicurezza & Compliance  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Configurare AWS CloudTrail per il tracciamento completo delle attività
- Creare regole AWS Config per la compliance continua
- Impostare allarmi per eventi critici (login root, modifiche IAM)
- Interrogare i log CloudTrail con Amazon Athena

## 📚 Concetti Chiave

### AWS CloudTrail: Chi ha fatto cosa e quando
CloudTrail registra ogni chiamata API AWS fatta nel tuo account: chi (utente/ruolo), cosa (azione), quando, da dove (IP), su quale risorsa. È la "scatola nera" del tuo account AWS.

**Management Events**: operazioni su risorse (create/delete/modify). Abilitati di default per 90 giorni.
**Data Events**: operazioni sui dati (s3:GetObject, lambda:InvokeFunction). Devono essere abilitati esplicitamente (più costosi).

**Trail**: configurazione per salvare i log in modo permanente su S3 (oltre i 90 giorni default).

### AWS Config: Lo Stato delle Risorse nel Tempo
Config registra la configurazione di ogni risorsa AWS e le sue modifiche nel tempo. Permette di rispondere a domande come:
- "Com'era configurato questo bucket S3 il 15 marzo?"
- "Quali EC2 hanno il volume EBS non cifrato?"
- "Quando è stata modificata questa Security Group?"

**Config Rules**: regole che valutano le risorse contro policy aziendali.
- **Managed Rules**: regole preconfigurate da AWS (es. `encrypted-volumes`, `s3-bucket-public-read-prohibited`)
- **Custom Rules**: scritte da te in Lambda per logic personalizzata

### Modello di Compliance Continua
Il tradizionale audit annuale è insufficiente per il cloud. Con Config e CloudTrail puoi avere **compliance continua**:
1. Config Rules definiscono lo stato desiderato
2. Config valuta continuamente le risorse
3. Risorse non conformi vengono segnalate (e opzionalmente rimediate automaticamente)
4. CloudTrail fornisce il "chi e quando" per ogni deviazione

## 🛠️ Hands-on: CloudTrail, Config e Audit

### Prerequisiti
- AWS CLI configurata con permessi `cloudtrail:*`, `config:*`, `cloudwatch:*`
- Vedi il file `cloudtrail-setup.txt` per la guida completa

### Step 1: Configurare CloudTrail Multi-Region

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
TRAIL_BUCKET="cloudtrail-logs-gestionale-$ACCOUNT_ID"

# Crea bucket per i log CloudTrail
aws s3api create-bucket \
  --bucket $TRAIL_BUCKET \
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1

# Aggiungi la bucket policy richiesta da CloudTrail
aws s3api put-bucket-policy \
  --bucket $TRAIL_BUCKET \
  --policy "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
      {
        \"Sid\": \"AWSCloudTrailAclCheck\",
        \"Effect\": \"Allow\",
        \"Principal\": {\"Service\": \"cloudtrail.amazonaws.com\"},
        \"Action\": \"s3:GetBucketAcl\",
        \"Resource\": \"arn:aws:s3:::$TRAIL_BUCKET\"
      },
      {
        \"Sid\": \"AWSCloudTrailWrite\",
        \"Effect\": \"Allow\",
        \"Principal\": {\"Service\": \"cloudtrail.amazonaws.com\"},
        \"Action\": \"s3:PutObject\",
        \"Resource\": \"arn:aws:s3:::$TRAIL_BUCKET/AWSLogs/$ACCOUNT_ID/*\"
      }
    ]
  }"

# Crea il trail multi-region
aws cloudtrail create-trail \
  --name gestionale-audit-trail \
  --s3-bucket-name $TRAIL_BUCKET \
  --is-multi-region-trail \
  --enable-log-file-validation \
  --region eu-west-1

# Avvia il logging
aws cloudtrail start-logging \
  --name gestionale-audit-trail \
  --region eu-west-1
```

### Step 2: Configurare AWS Config

```bash
CONFIG_BUCKET="config-recordings-gestionale-$ACCOUNT_ID"

aws s3api create-bucket \
  --bucket $CONFIG_BUCKET \
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1

# Crea IAM role per Config
aws iam create-role \
  --role-name AWSConfigRole \
  --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"config.amazonaws.com"},"Action":"sts:AssumeRole"}]}'

aws iam attach-role-policy \
  --role-name AWSConfigRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWS_ConfigRole

# Configura il recorder
aws configservice put-configuration-recorder \
  --configuration-recorder name=default,roleARN=arn:aws:iam::$ACCOUNT_ID:role/AWSConfigRole

# Configura il delivery channel
aws configservice put-delivery-channel \
  --delivery-channel name=default,s3BucketName=$CONFIG_BUCKET

# Avvia il recording
aws configservice start-configuration-recorder --configuration-recorder-name default

echo "AWS Config attivo"
```

### Step 3: Creare Config Rules per la Compliance

```bash
# Regola 1: Volumi EBS devono essere cifrati
aws configservice put-config-rule \
  --config-rule '{
    "ConfigRuleName": "encrypted-volumes",
    "Source": {"Owner": "AWS", "SourceIdentifier": "ENCRYPTED_VOLUMES"}
  }' \
  --region eu-west-1

# Regola 2: Bucket S3 non devono essere pubblici
aws configservice put-config-rule \
  --config-rule '{
    "ConfigRuleName": "s3-bucket-public-read-prohibited",
    "Source": {"Owner": "AWS", "SourceIdentifier": "S3_BUCKET_PUBLIC_READ_PROHIBITED"}
  }' \
  --region eu-west-1

# Regola 3: Policy password IAM deve essere configurata
aws configservice put-config-rule \
  --config-rule '{
    "ConfigRuleName": "iam-password-policy",
    "Source": {"Owner": "AWS", "SourceIdentifier": "IAM_PASSWORD_POLICY"}
  }' \
  --region eu-west-1

# Regola 4: Account root deve avere MFA abilitata
aws configservice put-config-rule \
  --config-rule '{
    "ConfigRuleName": "root-account-mfa-enabled",
    "Source": {"Owner": "AWS", "SourceIdentifier": "ROOT_ACCOUNT_MFA_ENABLED"}
  }' \
  --region eu-west-1
```

### Step 4: Allarme CloudWatch per Login Root

```bash
# Crea un metric filter per rilevare login dell'utente root
LOG_GROUP_NAME="cloudtrail-logs"

aws cloudwatch put-metric-alarm \
  --alarm-name "RootAccountLogin" \
  --alarm-description "CRITICO: Accesso con account root rilevato" \
  --metric-name RootLoginCount \
  --namespace CloudTrailMetrics \
  --statistic Sum \
  --period 300 \
  --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --evaluation-periods 1 \
  --treat-missing-data notBreaching \
  --region eu-west-1
```

### Step 5: Query CloudTrail con Athena (avanzato)

```sql
-- Crea tabella Athena per CloudTrail (esegui nella console Athena)
CREATE EXTERNAL TABLE cloudtrail_logs (
  eventVersion STRING,
  userIdentity STRUCT<type:STRING, principalId:STRING, arn:STRING, accountId:STRING, userName:STRING>,
  eventTime STRING,
  eventSource STRING,
  eventName STRING,
  awsRegion STRING,
  sourceIPAddress STRING,
  errorCode STRING,
  errorMessage STRING
)
PARTITIONED BY (region STRING, year STRING, month STRING, day STRING)
ROW FORMAT SERDE 'com.amazon.emr.hive.serde.CloudTrailSerde'
STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://cloudtrail-logs-gestionale-123456789012/AWSLogs/123456789012/CloudTrail/';

-- Query: chi ha fatto le ultime 50 operazioni IAM?
SELECT eventTime, userIdentity.userName, eventName, sourceIPAddress
FROM cloudtrail_logs
WHERE eventSource = 'iam.amazonaws.com'
ORDER BY eventTime DESC
LIMIT 50;

-- Query: tentativi di accesso falliti
SELECT eventTime, userIdentity.userName, sourceIPAddress, errorCode, errorMessage
FROM cloudtrail_logs
WHERE errorCode IN ('AccessDenied', 'UnauthorizedAccess')
ORDER BY eventTime DESC;
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Ferma CloudTrail
aws cloudtrail stop-logging --name gestionale-audit-trail --region eu-west-1
aws cloudtrail delete-trail --name gestionale-audit-trail --region eu-west-1

# Ferma Config recorder
aws configservice stop-configuration-recorder --configuration-recorder-name default --region eu-west-1
aws configservice delete-delivery-channel --delivery-channel-name default --region eu-west-1
aws configservice delete-configuration-recorder --configuration-recorder-name default --region eu-west-1

# Elimina Config rules
for rule in encrypted-volumes s3-bucket-public-read-prohibited iam-password-policy root-account-mfa-enabled; do
  aws configservice delete-config-rule --config-rule-name $rule --region eu-west-1
done

# Svuota e elimina bucket
for bucket in $TRAIL_BUCKET $CONFIG_BUCKET; do
  aws s3 rm s3://$bucket --recursive
  aws s3api delete-bucket --bucket $bucket --region eu-west-1
done
```

## ✅ Checkpoint
- [ ] CloudTrail trail multi-region creato e attivo
- [ ] AWS Config recorder configurato
- [ ] Almeno 3 Config Rules attive
- [ ] Allarme CloudWatch per login root configurato
- [ ] Comprendo come interrogare CloudTrail con Athena

## 📖 Approfondimenti
- [AWS CloudTrail Documentation](https://docs.aws.amazon.com/cloudtrail/latest/userguide/)
- [AWS Config Documentation](https://docs.aws.amazon.com/config/latest/developerguide/)
- [AWS Security Hub](https://docs.aws.amazon.com/securityhub/)
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/benchmark/amazon_web_services)
