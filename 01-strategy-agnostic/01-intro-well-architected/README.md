# 📘 Lezione 1 – Intro: Qualità e Sostenibilità nel Cloud moderno

**📅 Data:** Lunedì 01/06/2025  
**🗂️ Modulo:** Modulo 1 – Strategia & Agnosticismo  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere i 6 pilastri del AWS Well-Architected Framework
- Saper valutare un'architettura esistente rispetto ai pilastri
- Utilizzare l'AWS Well-Architected Tool dalla console

## 📚 Concetti Chiave

### Il Well-Architected Framework
Il AWS Well-Architected Framework è una guida pratica per costruire infrastrutture cloud sicure, affidabili ed efficienti. Fu pubblicato da AWS nel 2012 e aggiornato regolarmente. Non è uno standard rigido, ma una serie di best practice e domande guida per far riflettere i team sulle proprie scelte architetturali.

Il Framework si basa su **6 pilastri** fondamentali, ognuno dei quali affronta una dimensione diversa della qualità di un sistema. Pensalo come una checklist multi-dimensionale: non basta che il sistema "funzioni", deve funzionare bene su tutti i fronti.

Un aspetto importante: AWS non dice "devi fare esattamente così". Il Framework ti chiede invece "hai considerato questo? Perché hai fatto questa scelta?" — è un approccio Socratico alla progettazione.

### I 6 Pilastri

**1. Operational Excellence (Eccellenza Operativa)**
Riguarda la capacità di eseguire e monitorare i sistemi per consegnare valore aziendale, e migliorare continuamente processi e procedure. Key questions: hai runbook automatizzati? Monitori le metriche giuste? Fai post-mortem after each incident?

**2. Security (Sicurezza)**
Proteggere informazioni e sistemi. Include: gestione delle identità (IAM), tracciabilità degli eventi, protezione dell'infrastruttura, protezione dei dati (encryption), risposta agli incidenti. Il principio chiave è "zero trust" — non fidarti di nessuno per default.

**3. Reliability (Affidabilità)**
La capacità di un sistema di funzionare correttamente e di riprendersi automaticamente dai guasti. Include: test di recovery, gestione dei limiti di servizio, gestione dei cambiamenti. Un sistema affidabile è progettato per fallire in modo controllato.

**4. Performance Efficiency (Efficienza delle Prestazioni)**
Usare le risorse computazionali in modo efficiente per soddisfare i requisiti, mantenendo quella efficienza anche quando la domanda cambia. Include: scelta del tipo di compute giusto, monitoraggio delle performance, sperimentazione.

**5. Cost Optimization (Ottimizzazione dei Costi)**
Evitare spese inutili. Include: comprensione e controllo delle spese, scelta del modello di pricing giusto (on-demand vs reserved vs spot), eliminazione delle risorse inutilizzate. FinOps è la pratica che implementa questo pilastro.

**6. Sustainability (Sostenibilità)** ← *Aggiunto nel 2021*
Minimizzare l'impatto ambientale dei carichi di lavoro cloud. Include: massimizzare l'utilizzo delle risorse, adottare managed services più efficienti, usare regioni con energia rinnovabile, ridurre il footprint complessivo.

### Come si usa il Well-Architected Tool
AWS offre uno strumento gratuito nella console chiamato **Well-Architected Tool**. Funziona così:
1. Crei un "Workload" (descrizione del tuo sistema)
2. Rispondi a una serie di domande per ogni pilastro
3. Lo strumento identifica i "High Risk Issues" (HRI) e "Medium Risk Issues" (MRI)
4. Genera un piano di miglioramento con azioni concrete

## 🛠️ Hands-on: Analisi Well-Architected di un Sistema Gestionale

### Prerequisiti
- Account AWS con accesso alla console
- AWS CLI configurato (`aws configure`)
- Permessi IAM: `wellarchitected:*`

### Step 1: Configurare AWS CLI

```bash
aws configure
# AWS Access Key ID: [inserisci la tua key]
# AWS Secret Access Key: [inserisci il tuo secret]
# Default region name: eu-west-1
# Default output format: json

# Verifica la configurazione
aws sts get-caller-identity
```
> 💡 **Cosa sta succedendo:** `sts get-caller-identity` è il modo più semplice per verificare che le credenziali funzionino. Ti restituisce l'ARN dell'utente/ruolo corrente.

### Step 2: Creare un Workload nel Well-Architected Tool

```bash
# aws wellarchitected create-workload \
#   --workload-name "Sistema-Gestionale-IAL" \
#   --description "Sistema gestionale per scuola di formazione professionale" \
#   --environment "PRODUCTION" \
#   --aws-regions "eu-west-1" \
#   --industry-type "Education" \
#   --industry "Education_Other" \     
#   --lenses "wellarchitected" \
#   --region eu-west-1 \
#   --review-owner "<your-name>" # your name here

  aws wellarchitected create-workload \
  --workload-name "Sistema-Gestionale-IAL" \
  --description "Sistema gestionale per scuola di formazione professionale" \
  --environment "PRODUCTION" \
  --aws-regions "eu-west-1" \
  --industry-type "Education" \
  --industry "Higher_Ed_Research" \
  --lenses "wellarchitected" \
  --region eu-west-1 \
  --review-owner "Roberto"

# Salva il workload-id dall'output, es:
# "WorkloadId": "abc123def456"

# eg:
# {
#     "WorkloadId": "928d94c1f2d3778ed90757743009e170",
#     "WorkloadArn": "arn:aws:wellarchitected:eu-west-1:890465783209:workload/928d94c1f2d3778ed90757743009e170"
# }

```
> 💡 **Cosa sta succedendo:** Stai creando un "progetto" nel WAT che rappresenta la tua applicazione. Il `--lenses` specifica quale set di domande usare — "wellarchitected" è il framework standard.

### Step 3: Listare i Workload esistenti

```bash
aws wellarchitected list-workloads \
  --region eu-west-1 \
  --query 'WorkloadSummaries[*].{Nome:WorkloadName,ID:WorkloadId,Rischio:RiskCounts}' \
  --output table
```

### Step 4: Analizzare le domande del pilastro Security

```bash
WORKLOAD_ID="il-tuo-workload-id"

aws wellarchitected list-answers \
  --workload-id $WORKLOAD_ID \
  --lens-alias "wellarchitected" \
  --pillar-id "security" \
  --region eu-west-1 \
  --query 'AnswerSummaries[*].{Domanda:QuestionTitle,Rischio:Risk}' \
  --output table
```

### Step 5: Compilare la Checklist Manuale (Esercizio)

```
PILASTRO: OPERATIONAL EXCELLENCE
[ ] Hai runbook documentati per le operazioni comuni?
[ ] I deployment sono automatizzati (CI/CD)?
[ ] Hai un sistema di alerting configurato?
[ ] Esegui post-mortem dopo ogni incidente?

PILASTRO: SECURITY
[ ] Usi MFA per tutti gli accessi alla console AWS?
[ ] Le policy IAM seguono il principio del minimo privilegio?
[ ] I dati sensibili sono cifrati at-rest e in-transit?
[ ] Hai CloudTrail abilitato per l'audit?

PILASTRO: RELIABILITY
[ ] Hai testato il recovery da un'interruzione?
[ ] L'applicazione scala automaticamente sotto carico?
[ ] Hai un backup e disaster recovery plan?

PILASTRO: PERFORMANCE EFFICIENCY
[ ] Hai scelto il tipo di istanza appropriato?
[ ] Usi caching dove possibile?
[ ] Monitori le metriche di performance?

PILASTRO: COST OPTIMIZATION
[ ] Hai configurato Budget Alerts?
[ ] Usi Reserved Instances per carichi prevedibili?
[ ] Elimini le risorse inutilizzate regolarmente?

PILASTRO: SUSTAINABILITY
[ ] Usi le regioni AWS con energia rinnovabile?
[ ] I tuoi Lambda/container si spengono quando non usati?
[ ] Hai ottimizzato la dimensione delle immagini container?
```

### Step 6: Visualizzare i Risk Summary

```bash
aws wellarchitected get-workload \
  --workload-id $WORKLOAD_ID \
  --region eu-west-1 \
  --query 'Workload.{Nome:WorkloadName,HRI:RiskCounts.HIGH,MRI:RiskCounts.MEDIUM}' \
  --output table
```

### 🧹 Cleanup (Sostenibilità)

```bash
aws wellarchitected delete-workload \
  --workload-id $WORKLOAD_ID \
  --client-request-token "cleanup-$(date +%s)" \
  --region eu-west-1
```

## ✅ Checkpoint
- [ ] AWS CLI configurata e funzionante (`aws sts get-caller-identity` risponde)
- [ ] Workload creato nel Well-Architected Tool
- [ ] Checklist compilata per almeno 3 pilastri
- [ ] Comprendo la differenza tra HRI e MRI

## 📖 Approfondimenti
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html)
- [Well-Architected Tool nella console](https://console.aws.amazon.com/wellarchitected/)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- Libro: "AWS Well-Architected Framework" (whitepaper ufficiale AWS, gratuito)
