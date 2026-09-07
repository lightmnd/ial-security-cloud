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
| **13** | 25-29 | AI, ML, LLMs & AI Security | ML basics, RAG, AI Security Governance |

## 🚀 Inizializzazione Ambiente
Per configurare i tool necessari (AWS CLI, Terraform, Docker, kubectl), esegui:

```bash
chmod +x setup-env.sh
./setup-env.sh
```

## 🔧 Installazione Tool Necessari (macOS / Linux / Windows)

Tool richiesti nel corso:
- AWS CLI
- Terraform
- Docker
- kubectl

### macOS (Homebrew)

```bash
brew update
brew install awscli terraform kubectl
brew install --cask docker
```

Avvia Docker Desktop almeno una volta e verifica:

```bash
aws --version
terraform -version
docker --version
kubectl version --client
```

### Linux (Debian/Ubuntu)

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release unzip

# AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Terraform (HashiCorp apt repo)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform

# Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
```

Verifica:

```bash
aws --version
terraform -version
docker --version
kubectl version --client
```

### Windows CMD (winget)

Apri CMD come amministratore:

```bat
winget install --id Amazon.AWSCLI -e
winget install --id Hashicorp.Terraform -e
winget install --id Docker.DockerDesktop -e
winget install --id Kubernetes.kubectl -e
```

Verifica da CMD:

```bat
aws --version
terraform -version
docker --version
kubectl version --client
```

### Windows Git Bash (alternativa con Chocolatey)

Se usi Git Bash, installa i pacchetti da PowerShell amministratore:

```powershell
choco install awscli terraform kubernetes-cli docker-desktop -y
```

Poi verifica da Git Bash:

```bash
aws --version
terraform -version
docker --version
kubectl version --client
```

## ⚙️ setup-env.sh (Versione da copiare)

```bash
#!/bin/bash
echo "Inizializzazione Ambiente di Sviluppo per il Corso..."

# Controllo installazione strumenti
command -v aws >/dev/null 2>&1 || { echo >&2 "AWS CLI non trovato."; }
command -v terraform >/dev/null 2>&1 || { echo >&2 "Terraform non trovato."; }
command -v docker >/dev/null 2>&1 || { echo >&2 "Docker non trovato."; }
command -v kubectl >/dev/null 2>&1 || { echo >&2 "kubectl non trovato."; }

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
