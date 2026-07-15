# 📘 Lezione 11 – GDPR e Disaster Recovery

**📅 Data:** Lunedì 06/07/2025  
**🗂️ Modulo:** Modulo 2 – Sicurezza & Compliance  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere gli obblighi GDPR per i sistemi cloud
- Definire RTO e RPO per il sistema gestionale
- Configurare la replica Cross-Region S3 per il disaster recovery
- Implementare una strategia di backup con AWS Backup

## 📚 Concetti Chiave

### GDPR e Cloud: Obblighi Fondamentali
Il GDPR (Regolamento UE 2016/679) impone obblighi specifici per i dati personali processati nel cloud:

**Articolo 32 - Sicurezza del trattamento:**
- Cifratura dei dati (at-rest e in-transit)
- Pseudonimizzazione dove possibile
- Capacità di ripristinare disponibilità dei dati dopo un incidente

**Articolo 17 - Diritto alla cancellazione:**
- Implementa meccanismi di hard-delete (non solo flag "eliminato")
- In S3: Object Expiration + MFA Delete
- In database: stored procedure di cancellazione certificata

**Articolo 5 - Limitazione della conservazione:**
- I dati non devono essere conservati oltre il necessario
- Lifecycle policies su S3 e RDS per eliminazione automatica

**Art. 28 - Responsabile del trattamento (AWS come data processor):**
- AWS sottoscrive il Data Processing Addendum (DPA)
- I dati devono rimanere in UE → usa solo regioni EU

### RTO e RPO: Metriche di Disaster Recovery
- **RTO (Recovery Time Objective)**: quanto tempo possiamo permetterci di stare offline?
  - Sistema di supporto alla didattica: 4-8 ore (non è life-critical)
  - Sistema di pagamenti: 30 minuti
- **RPO (Recovery Point Objective)**: quanti dati possiamo permetterci di perdere?
  - Dati fatturazione: 0 (nessuna perdita accettabile)
  - Log applicativi: 24 ore

### Strategie di DR in AWS

| Strategia | RTO | RPO | Costo | Descrizione |
|-----------|-----|-----|-------|-------------|
| Backup & Restore | Ore | Ore | $ | Backup su S3, ripristino manuale |
| Pilot Light | 10-30 min | Minuti | $$ | Infrastruttura minima attiva in DR region |
| Warm Standby | Minuti | Secondi | $$$ | Versione scalata-down attiva in DR |
| Multi-Site Active/Active | <1 min | 0 | $$$$ | Due region attive in parallelo |

Per il gestionale IAL: **Backup & Restore** è sufficiente (RTO 4h, RPO 1h).

## 🛠️ Hands-on: Replica S3 Cross-Region e AWS Backup

### Prerequisiti
- AWS CLI configurata con permessi `s3:*`, `backup:*`
- Vedi il file `s3-replication-policy.json` per la configurazione replica

### Step 1: Creare bucket sorgente e destinazione

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
SOURCE_BUCKET="gestionale-documenti-$ACCOUNT_ID"
DEST_BUCKET="gestionale-documenti-backup-$ACCOUNT_ID"
DEST_REGION=$(aws s3api get-bucket-location --bucket $DEST_BUCKET --query "LocationConstraint" --output text)
KMS_KEY_ARN="arn:aws:kms:${DEST_REGION}:${ACCOUNT_ID}:alias/aws/s3"

# Bucket sorgente in eu-west-1 (Irlanda)
aws s3api create-bucket \
  --bucket $SOURCE_BUCKET \
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1

# Bucket destinazione in eu-central-1 (Francoforte) per DR
aws s3api create-bucket \
  --bucket $DEST_BUCKET \
  --region eu-central-1 \
  --create-bucket-configuration LocationConstraint=eu-central-1

# Abilita versioning su entrambi (necessario per la replica)
aws s3api put-bucket-versioning \
  --bucket $SOURCE_BUCKET \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-versioning \
  --bucket $DEST_BUCKET \
  --versioning-configuration Status=Enabled

echo "Bucket creati con versioning abilitato"
```

### Step 2: Creare il ruolo IAM per la replica

```bash
aws iam create-role \
  --role-name s3-replication-role \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "s3.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

aws iam put-role-policy \
  --role-name s3-replication-role \
  --policy-name replication-policy \
  --policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
      {
        \"Effect\": \"Allow\",
        \"Action\": [\"s3:GetReplicationConfiguration\",\"s3:ListBucket\"],
        \"Resource\": \"arn:aws:s3:::$SOURCE_BUCKET\"
      },
      {
        \"Effect\": \"Allow\",
        \"Action\": [\"s3:GetObjectVersionForReplication\",\"s3:GetObjectVersionAcl\",\"s3:GetObjectVersionTagging\"],
        \"Resource\": \"arn:aws:s3:::$SOURCE_BUCKET/*\"
      },
      {
        \"Effect\": \"Allow\",
        \"Action\": [\"s3:ReplicateObject\",\"s3:ReplicateDelete\",\"s3:ReplicateTags\"],
        \"Resource\": \"arn:aws:s3:::$DEST_BUCKET/*\"
      }
    ]
  }"
```

### Step 3: Applicare la configurazione di replica

```bash
ROLE_ARN="arn:aws:iam::$ACCOUNT_ID:role/s3-replication-role"

# Aggiorna il file di policy con il Role ARN reale
sed "s|ROLE_ARN_PLACEHOLDER|$ROLE_ARN|g; s|DEST_BUCKET_PLACEHOLDER|$DEST_BUCKET|g; s|aws/s3|$KMS_KEY_ARN|g" s3-replication-policy.json > /tmp/replication-config.json

# Applica la configurazione
aws s3api put-bucket-replication \
  --bucket $SOURCE_BUCKET \
  --replication-configuration file:///tmp/replication-config.json

echo "Replica CRR configurata: $SOURCE_BUCKET → $DEST_BUCKET"
```

### Step 4: Testare la replica

```bash
# Carica un file nel bucket sorgente
echo "Documento confidenziale studente - $(date)" > test-replica.txt
aws s3 cp test-replica.txt s3://$SOURCE_BUCKET/documenti/test-replica.txt

# Attendi la replica (30-60 secondi normalmente)
echo "Attendo la replica..."
sleep 60

# Verifica che il file sia apparso nel bucket di destinazione
aws s3 ls s3://$DEST_BUCKET/documenti/ --region eu-central-1
```

### Step 5: Configurare AWS Backup per RDS

```bash
# Crea un vault di backup
aws backup create-backup-vault \
  --backup-vault-name gestionale-backup-vault \
  --region eu-west-1

# Crea un piano di backup: giornaliero alle 02:00, retention 30 giorni
aws backup create-backup-plan \
  --backup-plan '{
    "BackupPlanName": "gestionale-daily-backup",
    "Rules": [{
      "RuleName": "DailyBackup",
      "TargetBackupVaultName": "gestionale-backup-vault",
      "ScheduleExpression": "cron(0 2 * * ? *)",
      "StartWindowMinutes": 60,
      "CompletionWindowMinutes": 180,
      "Lifecycle": {
        "DeleteAfterDays": 30
      }
    }]
  }' \
  --region eu-west-1
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Rimuovi la configurazione di replica
aws s3api delete-bucket-replication --bucket $SOURCE_BUCKET

# Svuota e elimina bucket
for bucket in $SOURCE_BUCKET $DEST_BUCKET; do
  REGION=$(aws s3api get-bucket-location --bucket $bucket --query 'LocationConstraint' --output text 2>/dev/null || echo "eu-west-1")
  aws s3 rm s3://$bucket --recursive
  aws s3api delete-bucket --bucket $bucket --region ${REGION:-eu-west-1}
done

# Elimina ruolo IAM
aws iam delete-role-policy --role-name s3-replication-role --policy-name replication-policy
aws iam delete-role --role-name s3-replication-role

# Pulisci file temporanei
rm -f test-replica.txt /tmp/replication-config.json
```

## ✅ Checkpoint
- [ ] Comprendo la differenza tra RTO e RPO
- [ ] Bucket S3 con versioning abilitato su due regioni
- [ ] Replica Cross-Region (CRR) configurata
- [ ] File replicato e verificato nel bucket di destinazione
- [ ] Piano di backup AWS Backup creato

## 📖 Approfondimenti
- [AWS Disaster Recovery Whitepaper](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws/)
- [S3 Replication Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html)
- [AWS Backup Documentation](https://docs.aws.amazon.com/aws-backup/)
- [GDPR e AWS](https://aws.amazon.com/compliance/gdpr-center/)
