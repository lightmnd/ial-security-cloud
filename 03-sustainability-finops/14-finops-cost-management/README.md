# 📘 Lezione 14 – FinOps e Gestione dei Costi

**📅 Data:** Mercoledì 15/07/2025  
**🗂️ Modulo:** Modulo 3 – Sostenibilità & FinOps  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere la pratica FinOps e i suoi principi
- Usare AWS Cost Explorer per analizzare e prevedere i costi
- Configurare Budget Alerts per il controllo della spesa
- Valutare Reserved Instances vs Savings Plans vs Spot

## 📚 Concetti Chiave

### FinOps: Responsabilità Finanziaria nel Cloud
FinOps (Financial Operations) è la pratica di portare responsabilità finanziaria al modello di spesa variabile del cloud. Si basa su tre pilastri: **Inform, Optimize, Operate**.

**Inform (Informare):**
- Visibilità completa sulla spesa: chi spende cosa e perché
- Tagging delle risorse per allocazione dei costi
- Dashboard e report per tutti i team

**Optimize (Ottimizzare):**
- Eliminare risorse inutilizzate (zombie resources)
- Right-sizing: istanze troppo grandi per l'utilizzo reale
- Passare a modelli di pricing più convenienti

**Operate (Operare):**
- Budgets e alert per evitare sorprese
- Governance dei costi a livello di team/progetto
- Cultura di cloud cost awareness

### Modelli di Pricing AWS

**On-Demand**: paghi per quello che usi, senza impegno. Flessibile ma il più costoso.

**Reserved Instances (RI)**: impegno di 1 o 3 anni. Sconto fino al 75% vs On-Demand.
- Standard RI: massimo sconto, istanza e regione fissa
- Convertible RI: puoi cambiare tipo di istanza, meno sconto

**Savings Plans**: più flessibili delle RI. Impegno di spesa ($/ora) per 1 o 3 anni.
- Compute Savings Plans: validi per EC2, Lambda, Fargate — massima flessibilità
- EC2 Instance Savings Plans: solo EC2 di una famiglia in una regione

**Spot Instances**: usa la capacità AWS inutilizzata. Sconto fino al 90% ma possono essere interrotte con 2 minuti di preavviso. Adatte per: batch processing, CI/CD runners, training ML.

### Tagging: Fondamento del Cost Management

```bash
# Strategia di tagging raccomandata per il gestionale
# Questi tag vanno applicati a TUTTE le risorse
aws ec2 create-tags --resources i-1234567890abcdef0 --tags \
  Key=Project,Value=gestionale \
  Key=Environment,Value=production \
  Key=Team,Value=sviluppo \
  Key=CostCenter,Value=CC-001 \
  Key=ManagedBy,Value=Terraform
```

## 🛠️ Hands-on: Cost Explorer e Budget Alerts

### Prerequisiti
- AWS CLI configurata con permessi `ce:*`, `budgets:*`
- Almeno qualche giorno di utilizzo AWS per dati significativi
- Email valida per ricevere notifiche budget (modifica `budget-alert.json`)
- Permessi anche su Compute Optimizer (`compute-optimizer:GetEnrollmentStatus`, `compute-optimizer:UpdateEnrollmentStatus`, `compute-optimizer:GetEC2InstanceRecommendations`)

### Step 1: Esplorare i costi con Cost Explorer

```bash
# Costi dell'ultimo mese per servizio
aws ce get-cost-and-usage \
  --time-period Start=2025-06-01,End=2025-07-01 \
  --granularity MONTHLY \
  --metrics "BlendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE \
  --region us-east-1 \
  --query 'ResultsByTime[0].Groups[*].{Servizio:Keys[0],Costo:Metrics.BlendedCost.Amount}' \
  --output table

# Previsione costi da oggi fino a fine mese
START_DATE=$(python3 - <<'PY'
from datetime import datetime, UTC
print(datetime.now(UTC).strftime('%Y-%m-%d'))
PY
)

NEXT_MONTH=$(python3 - <<'PY'
from datetime import datetime, UTC
now = datetime.now(UTC)
year = now.year
month = now.month
if month == 12:
    print(f"{year + 1}-01-01")
else:
    print(f"{year}-{month + 1:02d}-01")
PY
)

echo "START_DATE=$START_DATE"
echo "NEXT_MONTH=$NEXT_MONTH"

if [ -z "$START_DATE" ] || [ -z "$NEXT_MONTH" ]; then
  echo "Errore: variabili data non valorizzate. Riesegui i blocchi Python sopra."
  exit 1
fi

aws ce get-cost-forecast \
  --time-period Start="$START_DATE",End="$NEXT_MONTH" \
  --metric BLENDED_COST \
  --granularity DAILY \
  --region us-east-1
```

### Step 2: Analizzare i costi per tag

```bash
# Costi per tag Project (mostra quanto spende ogni progetto)
aws ce get-cost-and-usage \
  --time-period Start=2025-06-01,End=2025-07-01 \
  --granularity MONTHLY \
  --metrics "BlendedCost" \
  --group-by Type=TAG,Key=Project \
  --region us-east-1
```

### Step 3: Configurare il Budget Alert

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Prima di creare il budget, modifica budget-alert.json e sostituisci
# instructor@example.com con la tua email.

# Crea il budget di 100 USD/mese con notifiche da file
aws budgets create-budget \
  --account-id $ACCOUNT_ID \
  --budget '{"BudgetName":"gestionale-monthly-budget","BudgetLimit":{"Amount":"100","Unit":"USD"},"TimeUnit":"MONTHLY","BudgetType":"COST"}' \
  --notifications-with-subscribers file://03-sustainability-finops/14-finops-cost-management/budget-alert.json \
  --region us-east-1

echo "Budget configurato: alert all'80% (\$80) e 100% forecast (\$100)"
```
> 💡 **Nota:** I budget AWS vengono creati nella regione us-east-1 — è l'unica regione supportata per il servizio Budgets.

### Step 4: Trovare risorse inutilizzate (Zombie Resources)

```bash
# EC2 ferme (stopped) che continuano ad avere EBS volumes (costo!)
aws ec2 describe-instances \
  --filters Name=instance-state-name,Values=stopped \
  --region eu-west-1 \
  --query 'Reservations[*].Instances[*].{ID:InstanceId,Tipo:InstanceType,FermaIl:StateTransitionReason}' \
  --output table

# Elastic IP non associati (costano anche se non usati!)
aws ec2 describe-addresses \
  --region eu-west-1 \
  --query 'Addresses[?AssociationId==null].{IP:PublicIp,ID:AllocationId}' \
  --output table

# Snapshot EBS non recenti (>90 giorni)
CUTOFF_DATE=$(python3 - <<'PY'
from datetime import datetime, timedelta, UTC
print((datetime.now(UTC) - timedelta(days=90)).strftime('%Y-%m-%d'))
PY
)

aws ec2 describe-snapshots \
  --owner-ids self \
  --region eu-west-1 \
  --query "Snapshots[?StartTime<='${CUTOFF_DATE}'].{ID:SnapshotId,Data:StartTime,Dimensione:VolumeSize}" \
  --output table
```

### Step 5: Calcolare il risparmio con Reserved Instances

```bash
# Ottieni recommendation per RI (AWS analizza il tuo utilizzo)
aws ce get-reservation-purchase-recommendation \
  --service "Amazon Elastic Compute Cloud - Compute" \
  --region us-east-1 \
  --query 'Recommendations[*].{Istanza:RecommendationDetails[0].InstanceDetails.EC2InstanceDetails.InstanceType,RisparmioAnnuo:EstimatedMonthlySavingsAmount,ROI:EstimatedROI}' \
  --output table

# Variante RDS (se vuoi confrontare anche database)
# aws ce get-reservation-purchase-recommendation \
#   --service "Amazon Relational Database Service" \
#   --region us-east-1 \
#   --output table
```

### Step 6: AWS Compute Optimizer

```bash
# Verifica se Compute Optimizer e' attivo nell'account/regione
aws compute-optimizer get-enrollment-status \
  --region eu-west-1 \
  --output table

# Se lo stato e' Inactive, attiva il servizio (una tantum)
aws compute-optimizer update-enrollment-status \
  --status Active \
  --region eu-west-1

echo "Se hai appena attivato Compute Optimizer, attendi 12-24 ore per vedere raccomandazioni utili."

# Ottieni raccomandazioni di right-sizing per le EC2
aws compute-optimizer get-ec2-instance-recommendations \
  --region eu-west-1 \
  --query 'instanceRecommendations[*].{Istanza:instanceArn,TipoAttuale:currentInstanceType,TipoRaccomandato:recommendationOptions[0].instanceType,Risparmio:recommendationOptions[0].estimatedMonthlySavings.value}' \
  --output table
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Elimina il budget di test se non più necessario
aws budgets delete-budget \
  --account-id $ACCOUNT_ID \
  --budget-name "gestionale-monthly-budget" \
  --region us-east-1

echo "Budget eliminato"
```

## ✅ Checkpoint
- [ ] Comprendo la differenza tra On-Demand, RI, Savings Plans e Spot
- [ ] Cost Explorer usato per analizzare i costi per servizio
- [ ] Budget Alert configurato a $100/mese con notifiche
- [ ] Almeno una risorsa inutilizzata identificata
- [ ] Raccomandazione RI o Compute Optimizer visualizzata

## 📖 Approfondimenti
- [AWS Cost Management](https://aws.amazon.com/aws-cost-management/)
- [FinOps Foundation](https://www.finops.org/)
- [AWS Savings Plans](https://aws.amazon.com/savingsplans/)
- [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/)
- Libro: "Cloud FinOps" di J.R. Storment e Mike Fuller (O'Reilly)
