# 📘 Lezione 7 – IAM e Zero Trust

**📅 Data:** Lunedì 22/06/2025  
**🗂️ Modulo:** Modulo 2 – Sicurezza & Compliance  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere il modello Zero Trust applicato ad AWS IAM
- Creare policy IAM con principio del minimo privilegio
- Simulare l'accesso di una policy con IAM Policy Simulator
- Configurare MFA obbligatoria per gli utenti

## 📚 Concetti Chiave

### Zero Trust: Non Fidarsi di Nessuno
Il modello Zero Trust rovescia la sicurezza perimetrale tradizionale: invece di "dentro la rete = fidato", ogni richiesta deve essere autenticata e autorizzata esplicitamente, indipendentemente da dove proviene.

In AWS questo si traduce in:
- Nessun accesso implicito: tutto è negato di default
- Minimo privilegio: ogni entità ha solo i permessi strettamente necessari
- Verifica continua: le credenziali scadono, i ruoli hanno durata limitata
- Audit trail: ogni azione è loggata in CloudTrail

### IAM: Identity and Access Management
IAM è il sistema di controllo accessi di AWS. Gestisce:

**Entità IAM:**
- **User**: persona umana (non raccomandato per applicazioni)
- **Group**: insieme di utenti con stesse policy
- **Role**: identità assunta temporaneamente da servizi, applicazioni o utenti federati
- **Service Account**: via Role per EC2, Lambda, EKS

**Policy IAM:**
- **Identity-based policy**: attaccata a User/Group/Role — "questa identità PUÒ/NON PUÒ fare X"
- **Resource-based policy**: attaccata alla risorsa (es. S3 bucket policy) — "chi PUÒ accedere a questo bucket"
- **SCP (Service Control Policy)**: usata con AWS Organizations — limite massimo di permessi nell'intera organizzazione

### Struttura di una Policy IAM

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "NomeLeggibile",
      "Effect": "Allow",        // Allow o Deny
      "Action": [               // Azioni permesse/negate
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [             // Su quali risorse
        "arn:aws:s3:::gestionale-bucket/*"
      ],
      "Condition": {            // Condizioni opzionali
        "StringEquals": {
          "s3:prefix": ["documenti/"]
        }
      }
    }
  ]
}
```

### Principio del Minimo Privilegio (PoLP)
Ogni identità deve avere solo i permessi necessari per il suo scopo, niente di più. In pratica:
- Inizia con zero permessi, aggiungi solo quello che serve
- Usa Resource ARN specifici, non `"*"` dove possibile
- Aggiungi condizioni (IP, MFA, orario) per restringere ulteriormente
- Revisiona i permessi periodicamente con IAM Access Analyzer

## 🛠️ Hands-on: IAM con Principio del Minimo Privilegio

### Prerequisiti
- AWS CLI configurata come utente con permessi `iam:*`
- Accesso alla console AWS

### Step 1: Esaminare la policy di minimo privilegio esistente

```bash
cat 02-security-compliance/07-iam-zero-trust/least-privilege.json
```

### Step 2: Creare un ruolo IAM per l'applicazione gestionale

```bash
# Il ruolo permette all'applicazione di accedere SOLO al suo bucket S3 e tabella DynamoDB
aws iam create-role \
  --role-name gestionale-app-role \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

# Attacca la policy di minimo privilegio
aws iam put-role-policy \
  --role-name gestionale-app-role \
  --policy-name gestionale-s3-access \
  --policy-document file://02-security-compliance/07-iam-zero-trust/least-privilege.json

echo "Ruolo creato: gestionale-app-role"
```

### Step 3: Creare un utente per i developer (con MFA obbligatoria)

```bash
# Crea utente sviluppatore
aws iam create-user --user-name dev-mario-rossi

# Crea gruppo sviluppatori
aws iam create-group --group-name Sviluppatori

# Policy che permette azioni solo se MFA è attiva
aws iam put-group-policy \
  --group-name Sviluppatori \
  --policy-name require-mfa \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "DenyAllWithoutMFA",
        "Effect": "Deny",
        "NotAction": [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:ListMFADevices",
          "sts:GetSessionToken"
        ],
        "Resource": "*",
        "Condition": {
          "BoolIfExists": {"aws:MultiFactorAuthPresent": "false"}
        }
      }
    ]
  }'

# Aggiungi utente al gruppo
aws iam add-user-to-group \
  --user-name dev-mario-rossi \
  --group-name Sviluppatori
```

### Step 4: IAM Policy Simulator

```bash
# Simula se il ruolo ha il permesso di fare GetObject su S3
aws iam simulate-principal-policy \
  --policy-source-arn "arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/gestionale-app-role" \
  --action-names "s3:GetObject" \
  --resource-arns "arn:aws:s3:::gestionale-bucket/documenti/test.pdf" \
  --query 'EvaluationResults[*].{Azione:EvalActionName,Decisione:EvalDecision}' \
  --output table

# Simula una negazione attesa
aws iam simulate-principal-policy \
  --policy-source-arn "arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/gestionale-app-role" \
  --action-names "ec2:DescribeInstances" \
  --resource-arns "*" \
  --query 'EvaluationResults[*].{Azione:EvalActionName,Decisione:EvalDecision}' \
  --output table
```

### Step 5: IAM Access Analyzer

```bash
# Crea un analyzer per trovare accessi non intenzionali
aws accessanalyzer create-analyzer \
  --analyzer-name gestionale-analyzer \
  --type ACCOUNT \
  --region eu-west-1

# Lista i findings (risorse accessibili pubblicamente o da account esterni)
aws accessanalyzer list-findings \
  --analyzer-arn "arn:aws:access-analyzer:eu-west-1:$(aws sts get-caller-identity --query Account --output text):analyzer/gestionale-analyzer" \
  --region eu-west-1
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Rimuovi utente dal gruppo
aws iam remove-user-from-group --user-name dev-mario-rossi --group-name Sviluppatori

# Elimina policy del gruppo
aws iam delete-group-policy --group-name Sviluppatori --policy-name require-mfa

# Elimina gruppo e utente
aws iam delete-group --group-name Sviluppatori
aws iam delete-user --user-name dev-mario-rossi

# Elimina policy del ruolo
aws iam delete-role-policy --role-name gestionale-app-role --policy-name gestionale-s3-access
aws iam delete-role --role-name gestionale-app-role

# Elimina analyzer
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws accessanalyzer delete-analyzer \
  --analyzer-name gestionale-analyzer \
  --region eu-west-1
```

## ✅ Checkpoint
- [ ] Comprendo la struttura di una policy IAM (Effect, Action, Resource, Condition)
- [ ] Ruolo IAM creato con policy di minimo privilegio
- [ ] Policy MFA obbligatoria configurata per il gruppo sviluppatori
- [ ] IAM Policy Simulator usato per verificare i permessi
- [ ] IAM Access Analyzer configurato

## 📖 Approfondimenti
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [IAM Policy Simulator](https://policysim.aws.amazon.com/)
- [Zero Trust on AWS](https://aws.amazon.com/security/zero-trust/)
- [AWS IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)
