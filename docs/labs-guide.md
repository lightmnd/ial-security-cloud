Ecco il file **README.md** completo e pronto all'uso. Include sia il **Modulo 2 (Sicurezza)** che il **Modulo 3 (Sostenibilità)** con tutti i comandi corretti, i percorsi dei file e la formattazione pulita per essere visualizzata correttamente su GitHub.

Puoi copiare il blocco di codice sottostante:

```markdown
# 📘 Manuale Laboratori: Sicurezza e Sostenibilità Cloud

Questo modulo copre le esercitazioni pratiche per la **Sicurezza dei Dati (DevSecOps)** e la **Sostenibilità (FinOps)** all'interno del sistema gestionale digitale.

---

# 🛡️ Laboratorio 2: DevSecOps e Principio del Minimo Privilegio

**Obiettivo:** Implementare il modello *Zero Trust* e automatizzare il controllo delle vulnerabilità nel codice.

### 🔒 Step 1: Configurazione Identità e Accessi (IAM)
In un'architettura Cloud Agnostic, le credenziali non sono mai scritte nel codice. Useremo policy restrittive.

1. **Spostati nella cartella delle policy:**
   ```bash
   cd modules/02-security/iam-policies/
   ```

2. **Crea un Bucket S3** per i dati del gestionale (usa un nome unico):
   ```bash
   # Genera un suffisso casuale per il nome
   BUCKET_NAME="gestionale-data-$(date +%s)"
   aws s3 mb "s3://$BUCKET_NAME" --region eu-west-1
   ```

3. **Configura la Policy:** Apri `least-privilege.json` e sostituisci `NOME-DEL-TUO-BUCKET` con quello appena creato.
4. **Crea la policy su AWS:**
   ```bash
   aws iam create-policy \
       --policy-name GestionaleS3Access \
       --policy-document file://least-privilege.json
   ```

### 🚨 Step 2: Scansione Vulnerabilità (Trivy)
Applichiamo la "Qualità" garantendo che l'immagine Docker non abbia falle di sicurezza.

1. **Installa lo scanner (se non presente):**
   ```bash
   curl -sfL [https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh](https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh) | sh -s -- -b /usr/local/bin
   ```

2. **Esegui la scansione dell'immagine** creata nel Modulo 1:
   ```bash
   trivy image gestionale-app:1.0
   ```
   *Nota: Se il report mostra vulnerabilità 'CRITICAL', il deploy verrebbe bloccato automaticamente dalla pipeline CI/CD.*

---

# 🌿 Laboratorio 3: Green Computing e FinOps (Scale to Zero)

**Obiettivo:** Ridurre l'impatto ambientale e i costi aziendali tramite architetture Serverless che consumano solo al bisogno.

### 🚀 Step 1: Creazione Ruolo e Deploy della Lambda
Dobbiamo fornire alla funzione un "passaporto" (Ruolo IAM) per agire.

1. **Crea il ruolo di esecuzione:**
   ```bash
   cd modules/03-sustainability/
   aws iam create-role \
       --role-name GreenLambdaRole \
       --assume-role-policy-document file://setup/trust-policy.json
   ```

2. **Crea il pacchetto di distribuzione:**
   ```bash
   cd src/
   zip function.zip green_function.py
   ```

3. **Deploy della funzione (Architettura ARM/Graviton):**
   *Sostituisci <ARN_RUOLO> con l'ARN ottenuto al punto 1.*
   ```bash
   aws lambda create-function \
       --function-name GestionaleGreenTask \
       --runtime python3.9 \
       --role <ARN_RUOLO> \
       --handler green_function.lambda_handler \
       --zip-file fileb://function.zip \
       --architectures arm64
   ```

### 📊 Step 2: Test e Analisi FinOps
Misuriamo l'efficienza energetica e il costo reale.

1. **Esegui il task gestionale:**
   ```bash
   aws lambda invoke --function-name GestionaleGreenTask risultato.json
   ```

2. **Verifica il consumo in CloudWatch:**
   * Vai nella console AWS -> **CloudWatch** -> **Log Groups**.
   * Cerca `/aws/lambda/GestionaleGreenTask`.
   * Trova la riga **REPORT**. Osserva `Billed Duration`: pagherai solo per i millisecondi esatti di lavoro. Questa è la massima espressione di **Sostenibilità Digitale**.
```

---

### 📂 Riepilogo file da creare nella Repository

Per far sì che la guida funzioni, assicurati che i file abbiano questi contenuti:

**Modulo 2 - `iam-policies/least-privilege.json`**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
            "Resource": ["arn:aws:s3:::IL-TUO-BUCKET", "arn:aws:s3:::IL-TUO-BUCKET/*"]
        }
    ]
}
```

**Modulo 3 - `src/green_function.py`**
```python
import json
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Esecuzione Sostenibile Completata!')
    }
```

**Modulo 3 - `setup/trust-policy.json`**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "lambda.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
```



Eccoci al gran finale. Il **Modulo 4** è il "collante" di tutto il corso. Qui introduciamo **Terraform** per implementare l'**Infrastructure as Code (IaC)**. 

L'obiettivo è dimostrare come la **Qualità** passi per l'automazione (evitando errori manuali) e come il Cloud Agnostic si realizzi usando tool che supportano diversi provider, mantenendo però il focus pratico su AWS.

---

### 📂 Struttura della Cartella: `modules/04-iac-terraform/`

```text
/modules/04-iac-terraform/
├── docs/
│   └── lab-guide.md       # Guida step-by-step
├── main.tf                # Definizione risorse (S3, IAM)
├── variables.tf           # Parametrizzazione
├── outputs.tf             # Output utili (ARN, Endpoint)
└── providers.tf           # Configurazione AWS
```

---

### 💻 1. I File di Codice Terraform

Questi file permettono di creare l'infrastruttura del Modulo 2 e 3 in modo automatico.

**File: `providers.tf`**
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

**File: `variables.tf`**
```hcl
variable "aws_region" {
  default = "eu-west-1"
}

variable "project_name" {
  default = "gestionale-digitale"
}
```

**File: `main.tf`**
```hcl
# 🌿 Risorsa Sostenibile: Bucket S3 per il gestionale
resource "aws_s3_bucket" "gestionale_data" {
  bucket_prefix = "${var.project_name}-data-"
  force_destroy = true # Per facilitare la pulizia a fine corso
}

# 🛡️ Risorsa Sicurezza: Policy IAM (quella del Modulo 2)
resource "aws_iam_policy" "gestionale_policy" {
  name        = "TerraformGestionalePolicy"
  description = "Policy creata via IaC per il minimo privilegio"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:PutObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.gestionale_data.arn}/*"
      },
    ]
  })
}
```

---

### 📖 2. Guida Laboratorio 4 (Markdown da copiare)

Copia questo contenuto nel file `modules/04-iac-terraform/docs/lab-guide.md`.

```markdown
# 🏗️ Laboratorio 4: Infrastructure as Code con Terraform

**Obiettivo:** Automatizzare la creazione dell'intera infrastruttura garantendo replicabilità (Qualità) e distruzione rapida delle risorse inutilizzate (Sostenibilità).

---

## 🛠️ Step 1: Inizializzazione di Terraform
Terraform deve scaricare i plugin necessari per comunicare con le API di AWS.

1. **Naviga nella cartella:**
   ```bash
   cd modules/04-iac-terraform/
   ```

2. **Inizializza il progetto:**
   ```bash
   terraform init
   ```

---

## 🔍 Step 2: Pianificazione (The "Plan")
Uno dei pilastri della **Qualità** nel Cloud è sapere cosa accadrà *prima* che accada. 

1. **Genera il piano di esecuzione:**
   ```bash
   terraform plan
   ```
   *Analizza l'output: Terraform ti dirà esattamente quali risorse verranno create (Bucket S3 e Policy IAM) senza toccare nulla nel cloud per ora.*

---

## 🚀 Step 3: Applicazione e Creazione
Ora rendiamo reale l'infrastruttura.

1. **Applica le modifiche:**
   ```bash
   terraform apply
   ```
   *(Digita `yes` quando richiesto)*.

2. **Verifica su AWS:** Vai nella console S3 e IAM. Troverai le risorse create con i nomi definiti nelle variabili. Noterai come questo metodo sia infinitamente più veloce e meno propenso a errori rispetto alla creazione manuale.

---

## ♻️ Step 4: Sostenibilità - "Leave no Trace"
La sostenibilità cloud significa anche non lasciare risorse accese o orfane che consumano energia e budget.

1. **Distruggi tutto l'ambiente di laboratorio:**
   ```bash
   terraform destroy
   ```
   *(Digita `yes` quando richiesto)*.
   
   > 💡 **Conclusione:** Hai appena imparato a gestire il ciclo di vita completo di un'infrastruttura. Questo è il cuore di un sistema gestionale digitale moderno.
```

---

### ✅ Riepilogo Finale della Repository
Con questo ultimo modulo, la tua repository GitHub è ora completa di:
1. **Syllabus** e **Setup script** nella root.
2. **Modulo 1**: Docker & Kubernetes (Agnosticismo).
3. **Modulo 2**: IAM & Vulnerability Scan (Sicurezza).
4. **Modulo 3**: Lambda & FinOps (Sostenibilità).
5. **Modulo 4**: Terraform (Automazione e Qualità).

Tutto il materiale è strutturato in modo che ogni lezione di 1 ora abbia una parte teorica (documentazione) e una pratica (codice). Buon corso!


