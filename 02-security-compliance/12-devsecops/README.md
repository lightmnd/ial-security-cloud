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

### Prerequisiti
- Repository GitHub con il codice del gestionale
- Account Snyk (gratuito: https://snyk.io)
- Secrets configurati nel repository: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `SNYK_TOKEN`

### Step 1: Esaminare il Workflow GitHub Actions

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
# oppure: curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

# Scansiona l'immagine del gestionale
trivy image gestionale-app:1.0

# Scansiona solo per CRITICAL e HIGH
trivy image --severity CRITICAL,HIGH gestionale-app:1.0

# Output in formato JSON per CI/CD
trivy image --format json --output trivy-results.json gestionale-app:1.0

# Scansiona il filesystem (IaC, secrets, misconfig)
trivy fs --scanners vuln,secret,config 01-strategy-agnostic/
```
> 💡 **Cosa sta succedendo:** Trivy scarica i database CVE aggiornati e confronta i pacchetti nell'immagine con le vulnerabilità note.

### Step 4: Eseguire Snyk Localmente

```bash
# Installa Snyk CLI
npm install -g snyk

# Autenticati
snyk auth

# Scan delle dipendenze Python
cd 01-strategy-agnostic/03-docker-agnostic/
snyk test --file=requirements.txt

# Scan SAST del codice
snyk code test

# Monitora il progetto
snyk monitor
```

### Step 5: Analizzare i Risultati e Correggere

```bash
# Esempio: Snyk rileva una vulnerabilità in requests < 2.31.0
# Fix: aggiorna requirements.txt
sed -i 's/requests==2.28.0/requests==2.31.0/' requirements.txt

# Rebuild e re-scan
docker build -t gestionale-app:1.1 .
trivy image --severity CRITICAL,HIGH gestionale-app:1.1
```

### 🧹 Cleanup (Sostenibilità)

```bash
rm -f trivy-results.json
# Deregistra il progetto da Snyk se non più necessario
# (dal dashboard Snyk: Projects → Delete)
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
