LAB 18 - CLOUDFRONT CLI GUIDE (macOS/Linux)
==========================================

Questa guida evita comandi con JSON inline troppo lunghi.
Tutti i file temporanei vengono creati nella cartella del lab.

1) Variabili iniziali
---------------------
export REGION=eu-west-1
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export STATIC_BUCKET="gestionale-static-${ACCOUNT_ID}"
export LAB_DIR="03-sustainability-finops/18-cdn-cloudfront"

2) Crea bucket e contenuti statici
----------------------------------
aws s3api create-bucket \
	--bucket "$STATIC_BUCKET" \
	--region "$REGION" \
	--create-bucket-configuration LocationConstraint="$REGION"

cat > index.html <<'EOF'
<html>
	<head><title>Gestionale IAL</title></head>
	<body>
		<h1>Gestionale IAL - CDN Lab</h1>
		<link rel="stylesheet" href="/static/style.css" />
	</body>
</html>
EOF

echo "body { font-family: sans-serif; }" > style.css

aws s3 cp index.html "s3://${STATIC_BUCKET}/"
aws s3 cp style.css "s3://${STATIC_BUCKET}/static/style.css"

3) Crea Origin Access Control (OAC)
-----------------------------------
OAC_ID=$(aws cloudfront create-origin-access-control \
	--origin-access-control-config '{
		"Name": "gestionale-oac",
		"Description": "OAC per lab CloudFront",
		"SigningProtocol": "sigv4",
		"SigningBehavior": "always",
		"OriginAccessControlOriginType": "s3"
	}' \
	--query 'OriginAccessControl.Id' \
	--output text)

4) Crea configurazione distribuzione da file
--------------------------------------------
cat > "${LAB_DIR}/distribution-config.json" <<EOF
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
				"DomainName": "${STATIC_BUCKET}.s3.${REGION}.amazonaws.com",
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
	--distribution-config file://"${LAB_DIR}/distribution-config.json" \
	--query 'Distribution.Id' \
	--output text)

DOMAIN=$(aws cloudfront get-distribution \
	--id "$DISTRIBUTION_ID" \
	--query 'Distribution.DomainName' \
	--output text)

5) Applica bucket policy per OAC
--------------------------------
cat > "${LAB_DIR}/bucket-policy.json" <<EOF
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
	--bucket "$STATIC_BUCKET" \
	--policy file://"${LAB_DIR}/bucket-policy.json"

6) Verifica stato e metrica cache hit rate
------------------------------------------
aws cloudfront wait distribution-deployed --id "$DISTRIBUTION_ID"
curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" "https://${DOMAIN}/"
curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" "https://${DOMAIN}/"

START_TIME=$(python3 - <<'PY'
from datetime import datetime, timedelta, timezone
print((datetime.now(timezone.utc) - timedelta(hours=1)).strftime("%Y-%m-%dT%H:%M:%SZ"))
PY
)

END_TIME=$(python3 - <<'PY'
from datetime import datetime, timezone
print(datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"))
PY
)

aws cloudwatch get-metric-statistics \
	--namespace AWS/CloudFront \
	--metric-name CacheHitRate \
	--dimensions Name=DistributionId,Value="$DISTRIBUTION_ID" Name=Region,Value=Global \
	--start-time "$START_TIME" \
	--end-time "$END_TIME" \
	--period 3600 \
	--statistics Average \
	--region us-east-1

echo "Distribuzione disponibile su: https://${DOMAIN}"

7) Cleanup completo
-------------------
ETAG=$(aws cloudfront get-distribution-config --id "$DISTRIBUTION_ID" --query ETag --output text)
aws cloudfront get-distribution-config \
	--id "$DISTRIBUTION_ID" \
	--query DistributionConfig > "${LAB_DIR}/distribution-current.json"

python3 - <<'PY'
import json
with open("03-sustainability-finops/18-cdn-cloudfront/distribution-current.json", "r", encoding="utf-8") as f:
		data = json.load(f)
data["Enabled"] = False
with open("03-sustainability-finops/18-cdn-cloudfront/distribution-disabled.json", "w", encoding="utf-8") as f:
		json.dump(data, f)
PY

aws cloudfront update-distribution \
	--id "$DISTRIBUTION_ID" \
	--if-match "$ETAG" \
	--distribution-config file://"${LAB_DIR}/distribution-disabled.json"

aws cloudfront wait distribution-deployed --id "$DISTRIBUTION_ID"

ETAG_DELETE=$(aws cloudfront get-distribution-config --id "$DISTRIBUTION_ID" --query ETag --output text)
aws cloudfront delete-distribution --id "$DISTRIBUTION_ID" --if-match "$ETAG_DELETE"

OAC_ETAG=$(aws cloudfront get-origin-access-control --id "$OAC_ID" --query ETag --output text)
aws cloudfront delete-origin-access-control --id "$OAC_ID" --if-match "$OAC_ETAG"

aws s3 rm "s3://${STATIC_BUCKET}" --recursive
aws s3api delete-bucket --bucket "$STATIC_BUCKET" --region "$REGION"

rm -f index.html style.css
rm -f "${LAB_DIR}/distribution-config.json"
rm -f "${LAB_DIR}/bucket-policy.json"
rm -f "${LAB_DIR}/distribution-current.json"
rm -f "${LAB_DIR}/distribution-disabled.json"
