# 📘 Lezione 13 – Sostenibilità e Shared Responsibility Model

**📅 Data:** Lunedì 13/07/2025  
**🗂️ Modulo:** Modulo 3 – Sostenibilità & FinOps  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere il Shared Responsibility Model di AWS per la sostenibilità
- Utilizzare il AWS Customer Carbon Footprint Tool
- Identificare le regioni AWS con energia rinnovabile
- Applicare il pilastro Sustainability del Well-Architected Framework

## 📚 Concetti Chiave

### Shared Responsibility Model
Il modello di responsabilità condivisa definisce chi è responsabile di cosa tra cliente e AWS:

**AWS è responsabile di:**
- Sicurezza DELL'infrastruttura cloud (data center, hardware, rete globale)
- Efficienza energetica dei data center (PUE, raffreddamento)
- Approvvigionamento di energia rinnovabile
- Sostenibilità dell'infrastruttura fisica

**Il cliente è responsabile di:**
- Sicurezza NEL cloud (configurazione, dati, applicazioni)
- Efficienza del codice e delle architetture scelte
- Eliminazione delle risorse inutilizzate
- Scelta delle regioni e dei servizi più efficienti
- Ottimizzazione dell'utilizzo delle risorse (non pagare per idle)

### Impegni AWS sulla Sostenibilità
AWS ha annunciato i seguenti impegni:
- **100% energia rinnovabile entro il 2025** (già raggiunto nel 2023 in molte regioni)
- **Net-zero carbon entro il 2040** (The Climate Pledge)
- **Water positive entro il 2030**: restituire più acqua di quella usata
- **Zero waste to landfill**: riuso e riciclo dell'hardware

**Regioni AWS più sostenibili (2024):**
- 🇮🇪 eu-west-1 (Irlanda): 100% rinnovabile
- 🇩🇪 eu-central-1 (Francoforte): alta % rinnovabile
- 🇸🇪 eu-north-1 (Stoccolma): 100% idroelettrica
- 🇺🇸 us-west-2 (Oregon): alta % rinnovabile
- ⚠️ ap-southeast-1 (Singapore): meno rinnovabile

### Il Pilastro Sustainability del Well-Architected Framework

Il sesto pilastro (aggiunto nel novembre 2021) definisce best practice per minimizzare l'impatto ambientale:

**Principio 1: Comprendi il tuo impatto**
- Misura il carbon footprint prima di ottimizzare
- Usa il Customer Carbon Footprint Tool

**Principio 2: Stabilisci obiettivi di sostenibilità**
- Definisci KPI: kWh/transazione, gCO2/richiesta API

**Principio 3: Massimizza l'utilizzo**
- CPU idle al 30% significa spreco del 70%
- Right-sizing, auto-scaling, serverless

**Principio 4: Anticipa e adotta offerte hardware più efficienti**
- Graviton3 è il 60% più efficiente di x86 equivalente

**Principio 5: Usa servizi gestiti**
- Lambda, Fargate, RDS: AWS ottimizza il hardware sottostante

**Principio 6: Riduci il downstream impact**
- CDN per ridurre i trasferimenti dati
- Compressione, caching, ottimizzazione delle immagini

## 🛠️ Hands-on: Carbon Footprint e Ottimizzazioni

### Prerequisiti
- Account AWS con accesso alla console
- Almeno 3 mesi di utilizzo AWS per dati significativi

### Step 1: Accedere al Customer Carbon Footprint Tool

```bash
# Via AWS CLI (richiede permessi billing:*)
aws ce get-cost-and-usage \
  --time-period Start=2025-01-01,End=2025-07-01 \
  --granularity MONTHLY \
  --metrics "UsageQuantity" \
  --group-by Type=DIMENSION,Key=SERVICE \
  --region us-east-1

# Il Carbon Footprint Tool è accessibile dalla console:
# AWS Console → Billing → Carbon Footprint Tool
# Oppure direttamente: https://console.aws.amazon.com/billing/home#/costexplorer/carbonFootprint
```

### Step 2: Analizzare le emissioni per servizio

```bash
# Ottieni il carbon footprint per regione (API)
aws ce get-cost-and-usage \
  --time-period Start=2025-04-01,End=2025-07-01 \
  --granularity MONTHLY \
  --metrics "BlendedCost" \
  --group-by Type=DIMENSION,Key=REGION \
  --region us-east-1 \
  --query 'ResultsByTime[*].Groups[*].{Regione:Keys[0],Costo:Metrics.BlendedCost.Amount}' \
  --output table
```

### Step 3: Confronto impatto tra regioni

```bash
# Calcolo teorico: se usi eu-north-1 invece di ap-southeast-1
# eu-north-1 (Stoccolma): carbon intensity ~10 gCO2/kWh (idroelettrica)
# ap-southeast-1 (Singapore): carbon intensity ~450 gCO2/kWh (mix fossile)
# Risparmio: 97.8% di emissioni CO2 a parità di carico!

echo "Calcolo risparmio CO2:"
echo "Stoccolma:   10 gCO2/kWh × 100 kWh = 1 kg CO2/mese"
echo "Singapore:  450 gCO2/kWh × 100 kWh = 45 kg CO2/mese"
echo "Risparmio scegliendo la regione giusta: 44 kg CO2/mese"
```

### Step 4: Identificare risorse idle nel proprio account

```bash
# Trova una EC2 in esecuzione (se presente)
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters Name=instance-state-name,Values=running \
  --region eu-west-1 \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text)

if [ "$INSTANCE_ID" = "None" ]; then
  echo "Nessuna EC2 in running in eu-west-1. Salta questo step o avvia una istanza di test."
  exit 0
fi

START_TIME=$(python3 - <<'PY'
from datetime import datetime, timedelta, timezone
print((datetime.now(timezone.utc) - timedelta(days=14)).strftime('%Y-%m-%dT%H:%M:%SZ'))
PY
)

END_TIME=$(python3 - <<'PY'
from datetime import datetime, timezone
print(datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'))
PY
)

# Verifica CPU media giornaliera nelle ultime 2 settimane
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --start-time $START_TIME \
  --end-time $END_TIME \
  --period 86400 \
  --statistics Average \
  --region eu-west-1 \
  --query 'Datapoints[*].{Data:Timestamp,CPU:Average}' \
  --output table
```

### Step 5: Checklist Sostenibilità (Esercizio)

```
SOSTENIBILITÀ - CHECKLIST GESTIONALE IAL

REGIONE E INFRASTRUTTURA
[ ] Il sistema usa eu-west-1 o eu-north-1 (alte % rinnovabili)?
[ ] Hai considerato eu-north-1 per ambienti non-produzione?

COMPUTE
[ ] Usi istanze Graviton (ARM) dove possibile?
[ ] Le EC2 hanno auto-scaling configurato?
[ ] Lambda viene usato per carichi event-driven?
[ ] Le EC2 di sviluppo si spengono fuori orario?

STORAGE
[ ] I dati vecchi hanno lifecycle policy verso Glacier?
[ ] Le immagini Docker sono ottimizzate (multi-stage)?
[ ] I log hanno retention period configurato?

NETWORKING
[ ] Usi CDN per asset statici?
[ ] I trasferimenti dati inter-AZ sono ottimizzati?
[ ] La compressione gzip/brotli è abilitata?

SERVERLESS E MANAGED SERVICES
[ ] Hai considerato ECS Fargate invece di EC2 per container?
[ ] RDS si spegne in ambienti dev fuori orario?
```

### 🧹 Cleanup (Sostenibilità)
Questo lab è principalmente teorico. Nessuna risorsa cloud da eliminare se non hai avviato istanze EC2 o RDS durante gli esercizi.

## ✅ Checkpoint
- [ ] Accesso al Customer Carbon Footprint Tool verificato
- [ ] Comprendo le responsabilità cliente vs AWS sulla sostenibilità
- [ ] So identificare le regioni AWS più sostenibili
- [ ] Checklist di sostenibilità compilata per il gestionale
- [ ] Comprendo i 6 principi del pilastro Sustainability del WAF

## 📖 Approfondimenti
- [AWS Sustainability](https://sustainability.aboutamazon.com/products-services/the-cloud)
- [AWS Customer Carbon Footprint Tool](https://aws.amazon.com/aws-cost-management/aws-customer-carbon-footprint-tool/)
- [Well-Architected Sustainability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/)
- [The Climate Pledge](https://www.theclimatepledge.com/)
- [Electricity Maps - Carbon Intensity](https://www.electricitymaps.com/)
