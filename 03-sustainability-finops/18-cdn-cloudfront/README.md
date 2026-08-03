# 📘 Lezione 18 – CDN e CloudFront

**📅 Data:** Mercoledì 29/07/2025  
**🗂️ Modulo:** Modulo 3 – Sostenibilità & FinOps  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere il funzionamento di una CDN e il suo impatto sulla sostenibilità
- Creare una distribuzione CloudFront con origin S3 protetta da OAC
- Configurare cache policy efficaci per asset statici
- Misurare il cache hit ratio e ottimizzare la configurazione

## 📚 Concetti Chiave

### CDN: Content Delivery Network
Una CDN distribuisce i contenuti su server chiamati **edge locations** sparsi nel mondo. Quando un utente richiede un asset (immagine, JS, CSS), riceve la risposta dall'edge più vicino invece che dal server centrale.

**Benefici:**
- Latenza ridotta (ms invece di decine di ms)
- Riduzione del traffico verso l'origin server (risparmio di bandwidth)
- Protezione DDoS automatica (AWS Shield Standard incluso)
- **Sostenibilità**: meno dati trasferiti su lunghe distanze = meno energia

### Amazon CloudFront
CloudFront è la CDN di AWS con 450+ edge locations in tutto il mondo. Funzionalità chiave:
- **Origins**: S3, ALB, EC2, API Gateway, HTTP personalizzato
- **Cache Behaviors**: regole diverse per path diversi (es. /api/* no cache, /static/* cache 1 anno)
- **Lambda@Edge / CloudFront Functions**: esegui codice all'edge (redirect, A/B testing, auth)
- **Price Classes**: limita le edge locations per risparmiare (es. solo EU+NA)
- **WAF Integration**: associa una WebACL WAF alla distribuzione

### Cache Behaviors: La Strategia di Caching

```
Richiesta /static/logo.png  → Cache 1 anno (immutable)
Richiesta /api/studenti     → No cache (dati real-time)
Richiesta /index.html       → Cache 1 ora (HTML)
Richiesta /docs/corso.pdf   → Cache 1 settimana (file statici)
```

**Best practices:**
- Usa URL versionate o hash per asset immutabili (`app.v2.1.0.js`)
- Imposta `Cache-Control: max-age=31536000` per asset statici
- Imposta `Cache-Control: no-store` per API dinamiche
- Usa **Invalidation** con parsimonia (costo per invalidation)

### CloudFront e Sostenibilità
CloudFront riduce il consumo energetico:
1. Meno dati viaggiano su lunghe distanze (reti fisiche consumano energia)
2. Edge locations AWS hanno alta efficienza energetica (PUE ~1.2)
3. Price Class 100 (EU+NA) evita edge inefficienti in regioni con alta carbon intensity
4. Caching riduce i compute cycles sull'origin

## 🛠️ Hands-on: CloudFront per il Gestionale

### Prerequisiti
- AWS CLI configurata con permessi `cloudfront:*`, `s3:*`
- Vedi il file `cloudfront-dist.md` per la guida completa CLI

### Step 1: Creare il bucket S3 per gli asset statici

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
STATIC_BUCKET="gestionale-static-$ACCOUNT_ID"

aws s3api create-bucket \
  --bucket $STATIC_BUCKET \
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1

aws s3api put-public-access-block \
  --bucket $STATIC_BUCKET \
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

# Carica alcuni file statici di test
echo "<html><body><h1>Gestionale IAL</h1></body></html>" > index.html
echo "body { font-family: sans-serif; }" > style.css

aws s3 cp index.html s3://$STATIC_BUCKET/
aws s3 cp style.css s3://$STATIC_BUCKET/static/

echo "Asset statici caricati su s3://$STATIC_BUCKET"
```

### Step 2: Creare Origin Access Control (OAC)

```bash
# OAC permette a CloudFront di accedere al bucket S3 senza renderlo pubblico
OAC_ID=$(aws cloudfront create-origin-access-control \
  --origin-access-control-config '{
    "Name": "gestionale-oac",
    "Description": "OAC per gestionale static assets",
    "SigningProtocol": "sigv4",
    "SigningBehavior": "always",
    "OriginAccessControlOriginType": "s3"
  }' \
  --query 'OriginAccessControl.Id' \
  --output text)

echo "OAC creato: $OAC_ID"
```

### Step 3: Creare la distribuzione CloudFront

```bash
cat > 03-sustainability-finops/18-cdn-cloudfront/distribution-config.json <<EOF
{
  "CallerReference": "gestionale-$(date +%s)",
  "Comment": "Distribuzione CDN per gestionale IAL",
  "Enabled": true,
  "PriceClass": "PriceClass_100",
  "HttpVersion": "http2and3",
  "DefaultRootObject": "index.html",
  "Origins": {
    "Quantity": 1,
    "Items": [
      {
        "Id": "S3-${STATIC_BUCKET}",
        "DomainName": "${STATIC_BUCKET}.s3.eu-west-1.amazonaws.com",
        "OriginAccessControlId": "${OAC_ID}",
        "S3OriginConfig": {
          "OriginAccessIdentity": ""
        }
      }
    ]
  },
  "DefaultCacheBehavior": {
    "TargetOriginId": "S3-${STATIC_BUCKET}",
    "ViewerProtocolPolicy": "redirect-to-https",
    "AllowedMethods": {
      "Quantity": 2,
      "Items": ["GET", "HEAD"],
      "CachedMethods": {
        "Quantity": 2,
        "Items": ["GET", "HEAD"]
      }
    },
    "Compress": true,
    "CachePolicyId": "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }
}
EOF

DISTRIBUTION_ID=$(aws cloudfront create-distribution \
  --distribution-config file://03-sustainability-finops/18-cdn-cloudfront/distribution-config.json \
  --query 'Distribution.Id' \
  --output text)

echo "Distribuzione CloudFront creata: $DISTRIBUTION_ID"
echo "Attendi il deploy (5-10 minuti)..."
```

### Step 4: Aggiornare la bucket policy per OAC

```bash
DOMAIN=$(aws cloudfront get-distribution \
  --id $DISTRIBUTION_ID \
  --query 'Distribution.DomainName' \
  --output text)

cat > 03-sustainability-finops/18-cdn-cloudfront/bucket-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${STATIC_BUCKET}/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::${ACCOUNT_ID}:distribution/${DISTRIBUTION_ID}"
        }
      }
    }
  ]
}
EOF

aws s3api put-bucket-policy \
  --bucket $STATIC_BUCKET \
  --policy file://03-sustainability-finops/18-cdn-cloudfront/bucket-policy.json

echo "Distribuzione disponibile su: https://$DOMAIN"
```

### Step 5: Verificare il Cache Hit Ratio

```bash
# Attendi che la distribuzione sia Deployed
aws cloudfront wait distribution-deployed --id $DISTRIBUTION_ID

# Fai alcune richieste per popolare la cache
curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" https://$DOMAIN/
curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" https://$DOMAIN/  # Seconda richiesta = da cache

# Controlla il cache hit ratio in CloudWatch
START_TIME=$(python3 - <<'PY'
from datetime import datetime, timedelta, timezone
print((datetime.now(timezone.utc) - timedelta(hours=1)).strftime('%Y-%m-%dT%H:%M:%SZ'))
PY
)

END_TIME=$(python3 - <<'PY'
from datetime import datetime, timezone
print(datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'))
PY
)

aws cloudwatch get-metric-statistics \
  --namespace AWS/CloudFront \
  --metric-name CacheHitRate \
  --dimensions Name=DistributionId,Value=$DISTRIBUTION_ID Name=Region,Value=Global \
  --start-time $START_TIME \
  --end-time $END_TIME \
  --period 3600 \
  --statistics Average \
  --region us-east-1
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Disabilita la distribuzione prima di eliminarla
ETAG=$(aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query 'ETag' --output text)
aws cloudfront get-distribution-config \
  --id $DISTRIBUTION_ID \
  --query 'DistributionConfig' > 03-sustainability-finops/18-cdn-cloudfront/distribution-current.json

python3 - <<'PY'
import json

with open('03-sustainability-finops/18-cdn-cloudfront/distribution-current.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

data['Enabled'] = False

with open('03-sustainability-finops/18-cdn-cloudfront/distribution-disabled.json', 'w', encoding='utf-8') as f:
    json.dump(data, f)
PY

aws cloudfront update-distribution \
  --id $DISTRIBUTION_ID \
  --if-match $ETAG \
  --distribution-config file://03-sustainability-finops/18-cdn-cloudfront/distribution-disabled.json

# Attendi la disabilitazione, poi elimina
aws cloudfront wait distribution-deployed --id $DISTRIBUTION_ID
ETAG_DELETE=$(aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query 'ETag' --output text)
aws cloudfront delete-distribution \
  --id $DISTRIBUTION_ID \
  --if-match $ETAG_DELETE

# Elimina l'OAC
OAC_ETAG=$(aws cloudfront get-origin-access-control --id $OAC_ID --query 'ETag' --output text)
aws cloudfront delete-origin-access-control --id $OAC_ID --if-match $OAC_ETAG

# Svuota e elimina il bucket
aws s3 rm s3://$STATIC_BUCKET --recursive
aws s3api delete-bucket --bucket $STATIC_BUCKET --region eu-west-1
rm -f index.html style.css
rm -f 03-sustainability-finops/18-cdn-cloudfront/distribution-config.json
rm -f 03-sustainability-finops/18-cdn-cloudfront/bucket-policy.json
rm -f 03-sustainability-finops/18-cdn-cloudfront/distribution-current.json
rm -f 03-sustainability-finops/18-cdn-cloudfront/distribution-disabled.json
```

## ✅ Checkpoint
- [ ] Comprendo il funzionamento di una CDN e degli edge locations
- [ ] Bucket S3 creato con asset statici
- [ ] Origin Access Control configurato
- [ ] Distribuzione CloudFront creata con Price Class 100
- [ ] Cache Hit Ratio verificato in CloudWatch

## 📖 Approfondimenti
- [Amazon CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [CloudFront Cache Behaviors](https://docs.aws.amazon.com/cloudfront/latest/developerguide/distribution-web-values-specify.html)
- [CloudFront Pricing](https://aws.amazon.com/cloudfront/pricing/)
- [Best Practices for CloudFront](https://docs.aws.amazon.com/cloudfront/latest/developerguide/best-practices.html)
