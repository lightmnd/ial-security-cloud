# 📘 Lezione 12 – DevSecOps: Sicurezza Integrata nella Pipeline CI/CD

**📅 Data:** Mercoledì 08/07/2025  
**🗂️ Modulo:** Modulo 2 – Sicurezza & Compliance  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere il paradigma DevSecOps e il principio "shift-left security"
- Configurare una pipeline CI/CD con security scanning integrato
- Utilizzare Trivy per la scansione di immagini container e Snyk per SAST

## �� Concetti Chiave

### DevSecOps: Shift-Left Security
DevSecOps integra la sicurezza nel processo di sviluppo fin dall'inizio, invece di applicarla solo alla fine come controllo. Il principio "shift-left" significa spostare i controlli di sicurezza verso le fasi iniziali del ciclo di sviluppo, dove i problemi sono meno costosi da risolvere.

**Vantaggi:**
- Vulnerabilità scoperte early → meno costose da correggere
- Sviluppatori acquisiscono awareness sulla sicurezza
- Nessun "security gate" bloccante last-minute che rallenta i release
- Compliance continua invece di audit periodici

### Strumenti DevSecOps

**SAST (Static Application Security Testing)**: analizza il codice sorgente senza eseguirlo.
- Snyk Code, SonarQube, Semgrep, Bandit (Python)
- Rileva: SQL injection, XSS, hard-coded credentials, insecure dependencies

**Container Security Scanning**: scansiona le immagini Docker per CVE.
- Trivy (open source, veloce), Clair, AWS ECR scanning
- Controlla: librerie OS, dipendenze applicative, configurazioni

**SCA (Software Composition Analysis)**: analizza le dipendenze open source.
- Snyk Open Source, OWASP Dependency-Check
- Verifica: licenze, vulnerabilità note (CVE), versioni obsolete

**Secrets Scanning**: rileva credenziali e segreti committati per errore.
- GitLeaks, TruffleHog, GitHub Secret Scanning
- Cerca: API keys, password, token, certificati privati

### La Pipeline DevSecOps Ideale

```
Developer push → GitHub
        │
        ▼
┌──────────────────────────────────────────────────────┐
│                  GitHub Actions Pipeline              │
│                                                      │
│  1. Checkout & Setup                                 │
│     │                                                │
│  2. SAST (Snyk Code / Semgrep)                      │
│     │  ← Blocca su Critical/High                    │
│     │                                                │
│  3. Dependency Scan (Snyk Open Source)              │
│     │  ← Blocca su CVSS > 7.0                       │
│     │                                                │
│  4. Docker Build                                     │
│     │                                                │
│  5. Container Scan (Trivy)                          │
│     │  ← Blocca su CRITICAL CVE                     │
│     │                                                │
│  6. Push to ECR                                      │
│     │                                                │
│  7. Deploy to EKS (solo su main branch)             │
└──────────────────────────────────────────────────────┘
```

## 🛠️ Hands-on: Pipeline DevSecOps con GitHub Actions

### File della demo
Questa cartella contiene tutti i file necessari all'hands-on:
```
12-devsecops/
├── app/
│   ├── app.py            ← Flask mini-gestionale (3 endpoint)
│   ├── requirements.txt  ← dipendenze Python
│   └── Dockerfile        ← multi-stage build, utente non-root
└── github-actions-security.yml  ← pipeline CI/CD con 4 job
```

### Prerequisiti
- Docker installato localmente
- Account GitHub con un fork/repository del progetto
- Account Snyk gratuito: https://app.snyk.io
- AWS CLI configurata (solo per il job ECR, opzionale per la demo locale)
- Secrets configurati nel repository GitHub:
  - `SNYK_TOKEN` (obbligatorio per i job Snyk)
  - `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` (solo per il push su ECR)

> 💡 **Repository di riferimento:** Se non hai ancora un repo GitHub, crea un fork di questo progetto o crea un nuovo repo e copia la cartella `12-devsecops/` al suo interno. Il workflow si aspetta che i file siano nel percorso `02-security-compliance/12-devsecops/`.

### Step 0: Avviare l'app demo in locale

```bash
cd 02-security-compliance/12-devsecops/app

# Build dell'immagine
docker build -t gestionale-app:1.0 .

# Avvia il container
docker run -d -p 8080:8080 --name gestionale-demo gestionale-app:1.0

# Testa gli endpoint
curl http://localhost:8080/api/health
curl http://localhost:8080/api/studenti

# Stop
docker stop gestionale-demo && docker rm gestionale-demo
```

### Step 1: Esaminare il Workflow GitHub Actions

Il file definisce **4 job** che vengono eseguiti in parallelo (i primi 3) e poi in sequenza (il 4°):

| Job | Tool | Gate |
|---|---|---|
| `sast-snyk` | Snyk Code + Snyk Open Source | Blocca su HIGH/CRITICAL |
| `container-scan` | Trivy image | Blocca su CRITICAL/HIGH CVE |
| `secrets-scan` | Trivy fs | Non bloccante (solo report) |
| `build-push` | Docker + ECR | Solo su push a `main`, dopo tutti i gate |

```bash
cat 02-security-compliance/12-devsecops/github-actions-security.yml
```

### Step 2: Configurare i Secrets nel Repository GitHub

```bash
# Via GitHub CLI
gh secret set SNYK_TOKEN --body "il-tuo-snyk-token"
gh secret set AWS_ACCESS_KEY_ID --body "AKIA..."
gh secret set AWS_SECRET_ACCESS_KEY --body "il-tuo-secret"

# Oppure via interfaccia: Settings → Secrets → Actions → New secret
```

### Step 3: Eseguire Trivy Localmente

```bash
# Installa Trivy
brew install aquasecurity/trivy/trivy  # macOS
# oppure:
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Build dell'immagine (se non già fatto nello Step 0)
cd 02-security-compliance/12-devsecops/app
docker build -t gestionale-app:1.0 .
cd -

# Scansiona l'immagine
trivy image gestionale-app:1.0

# Scansiona solo per CRITICAL e HIGH
trivy image --severity CRITICAL,HIGH gestionale-app:1.0

# Output in formato JSON per CI/CD
trivy image --format json --output trivy-results.json gestionale-app:1.0

# Scansiona il filesystem (IaC, secrets, misconfig)
trivy fs --scanners vuln,secret,config 02-security-compliance/12-devsecops/
```
> 💡 **Cosa sta succedendo:** Trivy scarica i database CVE aggiornati e confronta i pacchetti nell'immagine con le vulnerabilità note.

### Step 4: Eseguire Snyk Localmente

```bash
# Installa Snyk CLI
npm install -g snyk

# Autenticati (apre il browser su https://app.snyk.io)
snyk auth

# Scan delle dipendenze Python (SCA)
cd 02-security-compliance/12-devsecops/app
snyk test --file=requirements.txt

# Scan SAST del codice sorgente
snyk code test

# Monitora il progetto nel dashboard Snyk
snyk monitor

cd -
```

### Step 5: Analizzare i Risultati e Correggere

```bash
# Esempio: Snyk o Trivy rilevano una vulnerabilità in una dipendenza
# Verifica la versione corrente
cat 02-security-compliance/12-devsecops/app/requirements.txt

# Aggiorna la versione vulnerabile (esempio)
sed -i '' 's/requests==2.31.0/requests==2.32.3/' \
  02-security-compliance/12-devsecops/app/requirements.txt

# Rebuild con tag aggiornato
docker build -t gestionale-app:1.1 02-security-compliance/12-devsecops/app/

# Re-scan per verificare che la vulnerabilità sia risolta
trivy image --severity CRITICAL,HIGH gestionale-app:1.1
```

> 💡 **Flusso in CI/CD:** ogni `git push` su un branch riattiva la pipeline. Se il gate Trivy o Snyk fallisce, il job `build-push` non viene eseguito e l'immagine non raggiunge ECR.

### 🧹 Cleanup (Sostenibilità)

```bash
# Rimuovi immagini Docker locali
docker rmi gestionale-app:1.0 gestionale-app:1.1 2>/dev/null || true

# Rimuovi file temporanei
rm -f trivy-results.json

# Deregistra il progetto da Snyk se non più necessario
# (dal dashboard Snyk: Projects → Delete)

# Se hai pushato su ECR, elimina l'immagine remota
# aws ecr batch-delete-image \
#   --repository-name gestionale-app \
#   --image-ids imageTag=latest \
#   --region eu-west-1
```

## ✅ Checkpoint
- [ ] Pipeline GitHub Actions creata e attiva nel repository
- [ ] Trivy installato e scan eseguito sull'immagine locale
- [ ] Snyk configurato con token e primo scan eseguito
- [ ] Almeno una vulnerabilità identificata e risolta
- [ ] Comprendo la differenza tra SAST, SCA e Container Scanning

## 📖 Approfondimenti
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Snyk Learn](https://learn.snyk.io/)
- [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/)
- [GitHub Actions Security Hardening](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
