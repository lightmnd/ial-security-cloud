# 📘 Lezione 8 – Crittografia KMS

**📅 Data:** Mercoledì 24/06/2025  
**🗂️ Modulo:** Modulo 2 – Sicurezza & Compliance  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere encryption at-rest e in-transit
- Creare e gestire una Customer Managed Key (CMK) in AWS KMS
- Abilitare la rotazione automatica delle chiavi
- Cifrare un bucket S3 con la propria CMK

## 📚 Concetti Chiave

### Encryption at-Rest vs in-Transit
- **At-rest**: i dati sono cifrati quando memorizzati su disco (S3, EBS, RDS). Protegge da furto del supporto fisico o accesso non autorizzato allo storage.
- **In-transit**: i dati sono cifrati durante la trasmissione (HTTPS/TLS). Protegge da intercettazione del traffico di rete (man-in-the-middle).
- **In-use** (emerging): homomorphic encryption — calcoli su dati cifrati senza decifrarli. Ancora sperimentale.

### AWS KMS (Key Management Service)
KMS è il servizio di gestione delle chiavi crittografiche di AWS. Caratteristiche principali:
- **HSM (Hardware Security Module)**: le chiavi non escono mai dall'hardware sicuro
- **Audit completo**: ogni uso della chiave è loggato in CloudTrail
- **Integrazione nativa**: S3, EBS, RDS, Secrets Manager, Lambda usano KMS trasparentemente
- **Key policies**: controllo granulare su chi può usare/amministrare ogni chiave

### Tipi di Chiavi KMS
- **AWS Managed Keys**: create e gestite da AWS per i suoi servizi (es. `aws/s3`). Gratuite, rotazione automatica ogni anno. Meno controllo.
- **Customer Managed Keys (CMK)**: create e controllate da te. $1/mese/chiave + $0.03/10000 operazioni. Massimo controllo: policy personalizzate, rotazione configurabile, possibilità di disabilitarle/eliminarle.
- **Customer Provided Keys (SSE-C)**: tu porti la chiave a ogni richiesta S3. Massima privacy ma complessità elevata.

### Envelope Encryption
KMS usa la tecnica "envelope encryption" per cifrare dati grandi:
1. KMS genera una **Data Encryption Key (DEK)** in chiaro
2. La DEK cifra i tuoi dati
3. KMS cifra la DEK con la tua CMK → **Encrypted DEK**
4. L'Encrypted DEK viene salvata insieme ai dati cifrati
5. Per decifrare: KMS decifra la DEK (con CMK), poi la DEK decifra i dati

## 🛠️ Hands-on: KMS e Cifratura S3

### Prerequisiti
- AWS CLI configurata con permessi `kms:*` e `s3:*`
- Esegui lo script `encrypt-data.sh` per automatizzare i passi

### Step 1: Creare una Customer Managed Key

```bash
# Crea la CMK con descrizione in italiano
CMK_ARN=$(aws kms create-key \
  --description "Chiave per dati gestionale IAL" \
  --key-usage ENCRYPT_DECRYPT \
  --origin AWS_KMS \
  --region eu-west-1 \
  --query 'KeyMetadata.Arn' \
  --output text)

echo "CMK creata: $CMK_ARN"

# Crea un alias leggibile
aws kms create-alias \
  --alias-name alias/gestionale-cmk \
  --target-key-id $CMK_ARN \
  --region eu-west-1
```

### Step 2: Abilitare la rotazione automatica annuale

```bash
aws kms enable-key-rotation \
  --key-id $CMK_ARN \
  --region eu-west-1

# Verifica che la rotazione sia attiva
aws kms get-key-rotation-status \
  --key-id $CMK_ARN \
  --region eu-west-1
```
> 💡 **Nota:** La rotazione non invalida i dati già cifrati. AWS mantiene le versioni precedenti della chiave per decifrare i dati esistenti.

### Step 3: Cifrare e decifrare un dato

```bash
# Cifra un dato (simulazione di un codice fiscale)
PLAINTEXT="DatiSensibili-IAL-2025"
CIPHERTEXT=$(aws kms encrypt \
  --key-id alias/gestionale-cmk \
  --plaintext "$PLAINTEXT" \
  --region eu-west-1 \
  --query 'CiphertextBlob' \
  --output text)

echo "Dati cifrati (base64): $CIPHERTEXT"

# Decifra il dato
DECRYPTED=$(aws kms decrypt \
  --ciphertext-blob fileb://<(echo $CIPHERTEXT | base64 -d) \
  --region eu-west-1 \
  --query 'Plaintext' \
  --output text | base64 -d)

echo "Dati decifrati: $DECRYPTED"

# Verifica che corrispondano
[ "$PLAINTEXT" = "$DECRYPTED" ] && echo "✅ Cifratura/decifratura OK" || echo "❌ ERRORE"
```

### Step 4: Cifrare un bucket S3 con la CMK

```bash
BUCKET_NAME="gestionale-documenti-$(aws sts get-caller-identity --query Account --output text)"

# Crea il bucket
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1

# Imposta la cifratura di default con la nostra CMK
aws s3api put-bucket-encryption \
  --bucket $BUCKET_NAME \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "aws:kms",
        "KMSMasterKeyID": "alias/gestionale-cmk"
      },
      "BucketKeyEnabled": true
    }]
  }'

# Blocca accesso pubblico
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "Bucket $BUCKET_NAME cifrato con CMK gestionale"
```

### Step 5: Verificare la cifratura in CloudTrail

```bash
# Carica un file nel bucket (verrà cifrato automaticamente)
echo "Documento sensibile studente" > test-doc.txt
aws s3 cp test-doc.txt s3://$BUCKET_NAME/documenti/test-doc.txt

# Verifica i metadata di cifratura dell'oggetto
aws s3api head-object \
  --bucket $BUCKET_NAME \
  --key documenti/test-doc.txt \
  --query '{SSEAlgorithm:ServerSideEncryption,KMSKeyId:SSEKMSKeyId}'
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Elimina il file di test
rm -f test-doc.txt

# Svuota e elimina il bucket
aws s3 rm s3://$BUCKET_NAME --recursive
aws s3api delete-bucket --bucket $BUCKET_NAME --region eu-west-1

# Elimina l'alias KMS
aws kms delete-alias --alias-name alias/gestionale-cmk --region eu-west-1

# Schedula la cancellazione della CMK (minimo 7 giorni di attesa)
aws kms schedule-key-deletion \
  --key-id $CMK_ARN \
  --pending-window-in-days 7 \
  --region eu-west-1

echo "CMK schedulata per eliminazione tra 7 giorni"
```

## ✅ Checkpoint
- [ ] Comprendo la differenza tra encryption at-rest e in-transit
- [ ] CMK creata con alias leggibile
- [ ] Rotazione automatica abilitata
- [ ] Cifratura/decifratura eseguita via CLI
- [ ] Bucket S3 configurato con CMK come default encryption
- [ ] Oggetto caricato e metadata di cifratura verificati

## 📖 Approfondimenti
- [AWS KMS Documentation](https://docs.aws.amazon.com/kms/latest/developerguide/)
- [S3 Server-Side Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html)
- [Envelope Encryption Explained](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/protecting-data-at-rest.html)
- [AWS Encryption SDK](https://docs.aws.amazon.com/encryption-sdk/latest/developer-guide/)
