# 📘 Lezione 17 – Storage e Lifecycle S3

**📅 Data:** Lunedì 27/07/2025  
**🗂️ Modulo:** Modulo 3 – Sostenibilità & FinOps  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere le classi di storage S3 e i loro casi d'uso
- Configurare lifecycle policies per la gestione automatica dei dati
- Implementare Intelligent-Tiering per dati con accesso imprevedibile
- Calcolare il risparmio economico e ambientale delle lifecycle policies

## 📚 Concetti Chiave

### Classi di Storage S3

| Classe | Costo/GB | Retrieval | Minimum Storage | Uso |
|--------|----------|-----------|-----------------|-----|
| Standard | $0.023 | Immediato | — | Dati acceduti frequentemente |
| Standard-IA | $0.0125 | Immediato | 30 giorni | Accesso raro, recupero veloce |
| One Zone-IA | $0.01 | Immediato | 30 giorni | Dati riproducibili, 1 AZ |
| Intelligent-Tiering | $0.023/$0.0125 | Immediato | — | Accesso imprevedibile |
| Glacier Instant | $0.004 | Millisecondi | 90 giorni | Archivio, accesso raro |
| Glacier Flexible | $0.0036 | 1-12 ore | 90 giorni | Archivio con SLA flessibile |
| Glacier Deep Archive | $0.00099 | 12-48 ore | 180 giorni | Archiviazione a lungo termine |

### Lifecycle Policies: Automatizzare la Gestione
Una lifecycle policy sposta automaticamente gli oggetti tra classi di storage in base all'età. Esempio per i documenti del gestionale:
- 0-30 giorni: S3 Standard (accesso frequente)
- 30-90 giorni: S3 Standard-IA (accesso ridotto)
- 90-365 giorni: S3 Glacier Flexible (archivio)
- 365-2555 giorni: S3 Glacier Deep Archive (conservazione GDPR)
- Dopo 2555 giorni (7 anni): eliminazione automatica

### S3 Intelligent-Tiering
AWS monitora i pattern di accesso e sposta automaticamente gli oggetti tra livelli:
- Frequent Access tier: oggetti acceduti negli ultimi 30 giorni
- Infrequent Access tier: non acceduti per 30+ giorni (-40% costo)
- Archive Instant Access tier: non acceduti per 90+ giorni (-68% costo)
- Archive Access: non acceduti per 90-730 giorni (richiede configurazione)

Costo aggiuntivo: $0.0025/1000 oggetti/mese per il monitoring.

### Versioning e Compliance GDPR
Con il versioning abilitato, S3 mantiene tutte le versioni degli oggetti. Per il GDPR:
- Abilita il versioning per audit trail
- Configura MFA Delete per prevenire cancellazioni accidentali
- Usa lifecycle per le versioni non correnti (espira versioni vecchie dopo 30 giorni)
- Configura Object Lock per immutabilità (WORM) se richiesto dal regolatore

## 🛠️ Hands-on: Lifecycle Policies per il Gestionale

### Prerequisiti
- AWS CLI configurata con permessi `s3:*`

### Step 1: Creare il bucket con versioning

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET="gestionale-archivio-$ACCOUNT_ID"

aws s3api create-bucket \
  --bucket $BUCKET \
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1

# Abilita versioning
aws s3api put-bucket-versioning \
  --bucket $BUCKET \
  --versioning-configuration Status=Enabled

# Blocca accesso pubblico
aws s3api put-public-access-block \
  --bucket $BUCKET \
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "Bucket $BUCKET creato con versioning"
```

### Step 2: Applicare la lifecycle policy

```bash
# Applica la lifecycle policy dal file esistente
aws s3api put-bucket-lifecycle-configuration \
  --bucket $BUCKET \
  --lifecycle-configuration file://03-sustainability-finops/17-storage-lifecycle/s3-lifecycle-rules.json

# Verifica la configurazione
aws s3api get-bucket-lifecycle-configuration \
  --bucket $BUCKET \
  --query 'Rules[0].{ID:ID,Stato:Status,Transizioni:Transitions[*].{GiorniA:Days,Classe:StorageClass}}' \
  --output json
```

### Step 3: Caricare documenti di test

```bash
# Simula upload di documenti studenti
for i in {1..5}; do
  echo "Documento studente $i - $(date)" > "doc-studente-$i.txt"
  aws s3 cp "doc-studente-$i.txt" s3://$BUCKET/archivio/doc-studente-$i.txt
done

# Elenca gli oggetti
aws s3 ls s3://$BUCKET/archivio/ --human-readable

# Controlla la classe di storage (nuovo oggetto = STANDARD)
aws s3api list-objects-v2 \
  --bucket $BUCKET \
  --prefix archivio/ \
  --query 'Contents[*].{Chiave:Key,Dimensione:Size,Classe:StorageClass}' \
  --output table
```

### Step 4: Configurare Intelligent-Tiering

```bash
# Crea una configurazione Intelligent-Tiering con Archive Access
aws s3api put-bucket-intelligent-tiering-configuration \
  --bucket $BUCKET \
  --id gestionale-it-config \
  --intelligent-tiering-configuration '{
    "Id": "gestionale-it-config",
    "Status": "Enabled",
    "Tierings": [
      {
        "Days": 90,
        "AccessTier": "ARCHIVE_ACCESS"
      },
      {
        "Days": 180,
        "AccessTier": "DEEP_ARCHIVE_ACCESS"
      }
    ]
  }'

echo "Intelligent-Tiering configurato"
```

### Step 5: Calcolo del risparmio (Esercizio)

```bash
# Scenario: 100 GB di documenti gestionale
# 30% acceduti spesso, 70% archivio
echo "=== CALCOLO RISPARMIO ANNUO ==="
echo ""
echo "SCENARIO ATTUALE (tutto Standard):"
echo "100 GB × \$0.023 × 12 = \$27.60/anno"
echo ""
echo "SCENARIO CON LIFECYCLE:"
echo "  30 GB Standard:          30 × \$0.023 = \$0.69/mese"
echo "  40 GB Standard-IA:       40 × \$0.0125 = \$0.50/mese"
echo "  20 GB Glacier Flexible:  20 × \$0.0036 = \$0.072/mese"
echo "  10 GB Deep Archive:      10 × \$0.00099 = \$0.0099/mese"
echo "  Totale: \$1.27/mese = \$15.28/anno"
echo ""
echo "RISPARMIO: \$12.32/anno (44.6%)"
echo "Emissioni ridotte proporzionalmente grazie a hardware più efficiente"
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Rimuovi oggetti versionati e delete markers
aws s3api list-object-versions --bucket $BUCKET > versions.json

python3 - <<'PY'
import json

with open("versions.json", "r", encoding="utf-8") as f:
  data = json.load(f)

objects = [
  {"Key": item["Key"], "VersionId": item["VersionId"]}
  for item in data.get("Versions", [])
]
objects.extend(
  {"Key": item["Key"], "VersionId": item["VersionId"]}
  for item in data.get("DeleteMarkers", [])
)

with open("delete-versions.json", "w", encoding="utf-8") as f:
  json.dump({"Objects": objects, "Quiet": True}, f)

print(f"Versioni/delete markers da eliminare: {len(objects)}")
PY

aws s3api delete-objects \
  --bucket $BUCKET \
  --delete file://delete-versions.json

# Elimina il bucket
aws s3api delete-bucket --bucket $BUCKET --region eu-west-1

# Rimuovi file locali di test
rm -f doc-studente-*.txt
rm -f versions.json delete-versions.json
```

## ✅ Checkpoint
- [ ] Comprendo le differenze tra le classi di storage S3
- [ ] Bucket S3 con versioning abilitato
- [ ] Lifecycle policy configurata con transizioni a IA, Glacier, Deep Archive
- [ ] Intelligent-Tiering configurato
- [ ] Calcolo del risparmio completato

## 📖 Approfondimenti
- [S3 Storage Classes](https://aws.amazon.com/s3/storage-classes/)
- [S3 Lifecycle Configuration](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)
- [S3 Intelligent-Tiering](https://aws.amazon.com/s3/storage-classes/intelligent-tiering/)
- [S3 Pricing Calculator](https://aws.amazon.com/s3/pricing/)
