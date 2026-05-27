# 📘 Lezione 20 – Osservabilità con Grafana

**📅 Data:** Mercoledì 07/09/2025  
**🗂️ Modulo:** Modulo 4 – IaC & Osservabilità  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere i tre pilastri dell'osservabilità: metrics, logs, traces
- Configurare Prometheus per la raccolta di metriche
- Creare dashboard Grafana per il gestionale
- Integrare CloudWatch come datasource Grafana
- Preparare una demo con una Lambda reale creata via Terraform

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
- AWS CLI configurata
- Terraform installato
- Credenziali AWS con permessi per creare IAM Role, Lambda e leggere CloudWatch
- Regione AWS disponibile per la demo: `eu-west-1`

### File della demo
Questa cartella contiene i file Terraform per creare una Lambda reale di test:
- `main.tf`
- `variables.tf`
- `lambda_demo.py`
- `dashboard-metrics.json`

La Lambda creata si chiama di default `grafana-demo-metrics` ed è la funzione usata dai pannelli Lambda del dashboard.

### Step 1: Creare la Lambda demo con Terraform

```bash
cd 04-iac-observability/20-observability-grafana
terraform init
terraform apply
```

Quando Terraform termina, crea:
- un ruolo IAM per l'esecuzione della Lambda
- una Lambda Python di test
- gli output con nome funzione, ARN e account AWS

### Step 2: Generare metriche reali in CloudWatch

Invoca la Lambda più volte per popolare i pannelli Grafana:

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

Questo popolerà almeno queste metriche native CloudWatch:
- `Invocations`
- `Duration`
- `Errors` (solo se la funzione va in errore)

### Step 3: Avviare Grafana localmente

```bash
docker run -d \
  --name gestionale-grafana \
  -p 3000:3000 \
  -e GF_SECURITY_ADMIN_PASSWORD=admin123 \
  grafana/grafana:latest

echo "Grafana disponibile su http://localhost:3000"
echo "Login: admin / admin123"
```

### Step 4: Configurare CloudWatch Datasource

```
1. Configuration → Data Sources → Add data source
2. Seleziona CloudWatch
3. Auth Provider: AWS SDK Default
4. Default Region: eu-west-1
5. Save & Test
```

> Il datasource CloudWatch leggerà le metriche direttamente dal tuo account AWS. La Lambda `grafana-demo-metrics` appena creata sarà quindi visibile come sorgente reale delle metriche Lambda.

### Step 5: Esaminare il dashboard JSON

```bash
cat dashboard-metrics.json
```

### Step 6: Importare il dashboard

```
1. Apri http://localhost:3000
2. Login: admin / admin123
3. Dashboards → Import → Upload JSON file
4. Seleziona dashboard-metrics.json
5. Associa il datasource CloudWatch configurato nello step precedente
```

### Step 7: Verificare i pannelli

Con questa demo saranno popolati subito questi pannelli:
- Lambda Invocations
- Lambda Duration (avg)
- Lambda Errors (solo se generi errori)

I pannelli RDS, ALB ed ECS restano nel dashboard perché fanno parte della struttura originale della lezione, ma richiedono risorse AWS reali aggiuntive:
- RDS con `DBInstanceIdentifier=gestionale-db`
- ECS con `ClusterName=gestionale-cluster`
- un Application Load Balancer attivo

Quindi la demo è davvero eseguibile end-to-end già con la sola Lambda, senza stravolgere il materiale didattico.

### Step 8: Cleanup

```bash
terraform destroy

docker stop gestionale-grafana && docker rm gestionale-grafana
rm -f /tmp/lambda-output.json
```

## ✅ Checkpoint
- [ ] Comprendo metrics/logs/traces
- [ ] Ho creato la Lambda demo con Terraform
- [ ] Ho generato metriche reali in CloudWatch
- [ ] Grafana avviato localmente
- [ ] CloudWatch datasource configurato
- [ ] Dashboard importato
- [ ] Vedo i pannelli Lambda valorizzati

## 📖 Approfondimenti
- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [AWS CloudWatch](https://docs.aws.amazon.com/cloudwatch/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
