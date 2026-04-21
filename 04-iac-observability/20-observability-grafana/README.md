# 📘 Lezione 20 – Osservabilità con Grafana

**📅 Data:** Mercoledì 07/09/2025  
**🗂️ Modulo:** Modulo 4 – IaC & Osservabilità  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere i tre pilastri dell'osservabilità: metrics, logs, traces
- Configurare Prometheus per la raccolta di metriche
- Creare dashboard Grafana per il gestionale
- Integrare CloudWatch come datasource Grafana

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

### Step 1: Avviare Grafana localmente

```bash
docker run -d \
  --name gestionale-grafana \
  -p 3000:3000 \
  -e GF_SECURITY_ADMIN_PASSWORD=admin123 \
  grafana/grafana:latest

echo "Grafana disponibile su http://localhost:3000"
echo "Login: admin / admin123"
```

### Step 2: Esaminare il dashboard JSON

```bash
cat 04-iac-observability/20-observability-grafana/dashboard-metrics.json
```

### Step 3: Importare il dashboard

```
1. Apri http://localhost:3000
2. Login: admin / admin123
3. Dashboards → Import → Upload JSON file
4. Seleziona dashboard-metrics.json
5. Configura il datasource CloudWatch (richiede AWS credentials)
```

### Step 4: Configurare CloudWatch Datasource

```
1. Configuration → Data Sources → Add data source
2. Seleziona CloudWatch
3. Auth Provider: AWS SDK Default
4. Default Region: eu-west-1
5. Save & Test
```

### 🧹 Cleanup

```bash
docker stop gestionale-grafana && docker rm gestionale-grafana
```

## ✅ Checkpoint
- [ ] Comprendo metrics/logs/traces
- [ ] Grafana avviato localmente
- [ ] Dashboard importato
- [ ] CloudWatch datasource configurato

## 📖 Approfondimenti
- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [AWS CloudWatch](https://docs.aws.amazon.com/cloudwatch/)
