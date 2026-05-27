# 📘 Lezione 20 – Osservabilità con Grafana

**📅 Data:** Mercoledì 07/09/2025  
**🗂️ Modulo:** Modulo 4 – IaC & Osservabilità  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere i tre pilastri dell'osservabilità: metrics, logs, traces
- Configurare Prometheus per la raccolta di metriche
- Creare dashboard Grafana per il gestionale
- Integrare CloudWatch come datasource Grafana
- Preparare una demo che generi metriche AWS reali e visibili nel dashboard

## 📚 Concetti Chiave

### I Tre Pilastri dell'Osservabilità

**Metrics (Metriche)**: valori numerici nel tempo. CPU, memoria, richieste/secondo, latenza. Permettono di rispondere "cosa sta succedendo adesso?".

**Logs (Log)**: eventi testuali con timestamp. Permettono di rispondere "perché è successo?".

**Traces (Tracce)**: percorso di una richiesta attraverso i microservizi (distributed tracing). Permettono di rispondere "dove si è perso tempo?".

### Prometheus + Grafana
- **Prometheus**: scrapa metriche dagli endpoint `/metrics` degli applicativi. Salva serie temporali.
- **Grafana**: visualizza metriche da Prometheus, CloudWatch, Loki, e altri datasource in dashboard interattive.

### CloudWatch come Datasource Grafana
Grafana supporta CloudWatch nativamente tramite il plugin ufficiale. Permette di visualizzare metriche Lambda, ECS, RDS, ALB nello stesso dashboard con metriche Prometheus.

## 🛠️ Hands-on: Dashboard Grafana per il Gestionale

### Prerequisiti
- Docker installato per eseguire Grafana localmente
- AWS CLI configurata per CloudWatch datasource
- Credenziali AWS con permessi di lettura su CloudWatch
- Almeno una risorsa AWS reale che stia generando metriche in CloudWatch

### Risorsa demo consigliata
Per rendere la demo realizzabile al 100%, conviene usare una **Lambda di test** perché è la risorsa più veloce da creare, invocare e osservare in Grafana.

La Lambda genera subito metriche native in CloudWatch come:
- `Invocations`
- `Errors`
- `Duration`

Questo permette di validare almeno tre pannelli del dashboard senza dover predisporre un intero stack ECS + ALB + RDS.

### Step 0: Creare una risorsa AWS che generi metriche

Crea una funzione Lambda minimale in `eu-west-1`:

```bash
cat > lambda-demo.py <<'EOF'
def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": "ok"
    }
EOF

zip lambda-demo.zip lambda-demo.py

aws iam create-role \
  --role-name grafana-lambda-demo-role \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "lambda.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

aws iam attach-role-policy \
  --role-name grafana-lambda-demo-role \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

aws lambda create-function \
  --function-name grafana-demo-metrics \
  --runtime python3.12 \
  --handler lambda-demo.lambda_handler \
  --zip-file fileb://lambda-demo.zip \
  --role arn:aws:iam::<ACCOUNT_ID>:role/grafana-lambda-demo-role \
  --region eu-west-1
```

> Sostituisci `<ACCOUNT_ID>` con il tuo AWS Account ID. Dopo la creazione, attendi circa 1-2 minuti prima delle prime invocazioni.

### Step 1: Generare metriche reali

Invoca la Lambda più volte per popolare CloudWatch:

```bash
for i in {1..20}; do
  aws lambda invoke \
    --function-name grafana-demo-metrics \
    --payload '{}' \
    --cli-binary-format raw-in-base64-out \
    --region eu-west-1 \
    /tmp/lambda-output.json > /dev/null
  sleep 2
done

echo "Metriche Lambda inviate a CloudWatch"
```

Se vuoi generare anche errori visibili nel pannello `Lambda Errors`, modifica temporaneamente la funzione per restituire un'eccezione oppure crea una seconda versione volutamente errata.

### Step 2: Avviare Grafana localmente

```bash
docker run -d \
  --name gestionale-grafana \
  -p 3000:3000 \
  -e GF_SECURITY_ADMIN_PASSWORD=admin123 \
  grafana/grafana:latest

echo "Grafana disponibile su http://localhost:3000"
echo "Login: admin / admin123"
```

### Step 3: Configurare CloudWatch Datasource

```
1. Configuration → Data Sources → Add data source
2. Seleziona CloudWatch
3. Auth Provider: AWS SDK Default
4. Default Region: eu-west-1
5. Save & Test
```

### Step 4: Esaminare il dashboard JSON

```bash
cat 04-iac-observability/20-observability-grafana/dashboard-metrics.json
```

### Step 5: Importare il dashboard

```
1. Apri http://localhost:3000
2. Login: admin / admin123
3. Dashboards → Import → Upload JSON file
4. Seleziona dashboard-metrics.json
5. Associa il datasource CloudWatch configurato nello step precedente
```

### Step 6: Verificare quali pannelli funzionano subito

Con la sola Lambda demo saranno popolati subito questi pannelli:
- Lambda Invocations
- Lambda Errors (solo se generi errori)
- Lambda Duration (avg)

I pannelli RDS, ALB ed ECS richiedono invece risorse AWS reali con questi identificativi o equivalenti:
- RDS con `DBInstanceIdentifier=gestionale-db`
- ECS con `ClusterName=gestionale-cluster`
- ALB esistente visibile in `AWS/ApplicationELB`

Se queste risorse non esistono ancora, è normale che i relativi grafici restino vuoti.

### Variante minima per una demo davvero completa
Se vuoi una demo coerente senza stravolgere il materiale, hai due possibilità:

1. **Versione minima e immediata**: usi solo la Lambda demo e mostri i 3 pannelli Lambda.
2. **Versione estesa**: aggiorni in seguito anche il JSON del dashboard per filtrare solo metriche realmente presenti nel tuo account oppure aggiungi un piccolo stack Terraform con Lambda + ALB + RDS/ECS demo.

Per questa lezione, la prima opzione è la più semplice, economica e ripetibile.

### 🧹 Cleanup

```bash
aws lambda delete-function \
  --function-name grafana-demo-metrics \
  --region eu-west-1

docker stop gestionale-grafana && docker rm gestionale-grafana
rm -f lambda-demo.py lambda-demo.zip /tmp/lambda-output.json
```

## ✅ Checkpoint
- [ ] Comprendo metrics/logs/traces
- [ ] Ho creato almeno una risorsa AWS che genera metriche
- [ ] Ho generato metriche reali in CloudWatch
- [ ] Grafana avviato localmente
- [ ] CloudWatch datasource configurato
- [ ] Dashboard importato
- [ ] Vedo almeno i pannelli Lambda valorizzati

## 📖 Approfondimenti
- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [AWS CloudWatch](https://docs.aws.amazon.com/cloudwatch/)
