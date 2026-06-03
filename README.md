# Corso: Sistemi Gestionali Digitali (24 Ore)
### Qualità, Sicurezza e Sostenibilità Cloud Agnostic

Benvenuti nel corso pratico dedicato alla progettazione di sistemi cloud moderni. Questo corso segue un approccio **Cloud Agnostic** (standard aperti) con implementazione pratica su **AWS**.

## 📅 Calendario Lezioni

| Settimana | Lezione | Titolo | Tool / Lab |
| :--- | :--- | :--- | :--- |
| **1** | 1-2 | Intro & Design Agnostic | Well-Architected Framework |
| **2** | 3-4 | Container & K8s | Docker, AWS EKS |
| **3** | 5-6 | Data & Networking | RDS, VPC Peering |
| **4** | 7-8 | IAM & KMS | Zero Trust, Encryption |
| **5** | 9-10 | WAF & Compliance | AWS WAF, CloudTrail |
| **6** | 11-12 | DR & DevSecOps | Multi-region, Trivy Scan |
| **7** | 13-14 | Sostenibilità & FinOps | Cost Explorer, Carbon Tool |
| **8** | 15-16 | Serverless & Scaling | Lambda, Graviton |
| **9** | 17-18 | Storage & CDN | S3 Lifecycle, CloudFront |
| **10** | 19-20 | IaC & Osservabilità | Terraform, Grafana |
| **11** | 21-22 | Automation & Cases | Step Functions, Migrazione |
| **12** | 23-24 | Final Lab & Test | Assemblaggio & Valutazione |

## 🚀 Inizializzazione Ambiente
Per configurare i tool necessari (AWS CLI, Terraform, Docker, Kubectl), esegui:
```bash
chmod +x setup-env.sh
./setup-env.sh

---

## ⚙️ setup-env.sh (Versione da copiare)

```bash
#!/bin/bash
echo "🛠️ Inizializzazione Ambiente di Sviluppo per il Corso..."

# Controllo installazione strumenti
command -v aws >/dev/null 2>&1 || { echo >&2 "❌ AWS CLI non trovato."; }
command -v terraform >/dev/null 2>&1 || { echo >&2 "❌ Terraform non trovato."; }
command -v docker >/dev/null 2>&1 || { echo >&2 "❌ Docker non trovato."; }
command -v kubectl >/dev/null 2>&1 || { echo >&2 "❌ Kubectl non trovato."; }

# Creazione cartelle di lavoro locali
mkdir -p workspace/terraform workspace/docker workspace/k8s

echo "✅ Setup completato. Ora puoi procedere con il Modulo 1."

#---------------------------#

# Script Initialization V2

#!/bin/bash

# Esci immediatamente se un comando fallisce (opzionale, ma utile se i passaggi successivi dipendono dai precedenti)
# set -e 

echo "🛠️ Inizializzazione Ambiente di Sviluppo..."
echo "--------------------------------------------"

# Array dei tool da verificare (compatibile anche con la vecchia Bash 3.2 di macOS)
TOOLS=("aws" "terraform" "docker" "kubectl")
MISSING_TOOLS=0

for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "❌ $tool non trovato."
        MISSING_TOOLS=$((MISSING_TOOLS + 1))
    else
        echo "🔹 $tool: OK"
    fi
done

echo "--------------------------------------------"

# Se mancano tool, avvisiamo l'utente invece di dire che è tutto ok
if [ $MISSING_TOOLS -gt 0 ]; then
    echo "⚠️  Attenzione: $MISSING_TOOLS strumento/i mancante/i. Installali prima di procedere."
    # exit 1 # Scommenta se vuoi bloccare categoricamente lo script qui
fi

# Creazione cartelle di lavoro locali
echo "📁 Creazione directory del workspace..."
mkdir -p workspace/terraform workspace/docker workspace/k8s

echo "🎉 Setup completato! Ora puoi procedere con il Modulo 1."
