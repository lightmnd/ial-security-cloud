# Hands-On Lab: Terraform & Azure Security

Guida pratica ed esaustiva per il laboratorio hands-on di **Terraform su Azure**, comprensiva di setup dell'ambiente, analisi del codice, analisi statica di sicurezza con `tfsec` (con dimostrazione di failure/pass) e ciclo di vita delle risorse fino alla loro distruzione.

---

## 1. Introduzione e Concetti Chiave

**Terraform** è uno strumento open-source di **Infrastructure as Code (IaC)** sviluppato da HashiCorp. Consente di definire, configurare e rilasciare risorse cloud tramite file dichiarativi scritti in **HCL (HashiCorp Configuration Language)**.

### Vantaggi dell'IaC:
- **Version Control:** L'infrastruttura risiede in repository Git con supporto a Code Review, branching e audit di sicurezza.
- **Multi-Cloud:** Unico workflow per Azure, AWS, GCP e provider custom.
- **Automazione CI/CD:** Integrazione fluida in pipeline di deployment (Azure DevOps, GitHub Actions) per creare e distruggere ambienti senza interventi manuali.

---

## 2. Setup dell'Ambiente: Azure CLI

Per consentire a Terraform di interagire ed autenticarsi su Azure, è necessario installare l'interfaccia a riga di comando (**Azure CLI**) ed eseguire il login.

### Installazione

* **macOS (via Homebrew):**
  ```bash
  brew install azure-cli
  ```

* **Windows (via Winget / PowerShell):**
  ```powershell
  winget install -e --id Microsoft.AzureCLI
  ```

* **Linux (Ubuntu/Debian):**
  ```bash
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  ```

### Autenticazione

Dopo l'installazione, autenticarsi eseguendo:

```bash
az login
```

Verificare la subscription attiva:

```bash
az account list --output table
```

---

## 3. Configurazione Terraform (`main.tf`)

Di seguito il codice `main.tf` utilizzato nel laboratorio per la creazione di un **Resource Group** e uno **Storage Account** in Azure:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.96.0" # Pinning della versione per garantire stabilità
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}

resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "northernstor7778"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # SECURITY FIX (tfsec requirement):
  # min_tls_version = "TLS1_2"
}
```

---

## 4. Static Security Analysis con `tfsec` (via Docker)

Prima di applicare le modifiche in produzione, utilizziamo **tfsec** per eseguire un'analisi statica della sicurezza sul codice HCL tramite Docker.

### Comando di esecuzione

```bash
docker run --rm -it -v "$(pwd):/src" aquasec/tfsec /src
```

### Fase A: Dimostrazione del Test Failure ❌

Mantenendo la riga `min_tls_version = "TLS1_2"` **commentata** nel file `main.tf`, l'analisi con `tfsec` fallisce segnalando una vulnerabilità critica:

* **Regola violata:** `AZU015` (Storage account does not require explicit TLS 1.2 minimum version)
* **Gravità:** CRITICAL
* **Descrizione:** Lo Storage Account accetterebbe connessioni cifrate con versioni di TLS obsolete (es. TLS 1.0/1.1), esponendo il traffico ad attacchi di intercettazione/Man-In-The-Middle.

### Fase B: Remediation & Test Green ✅

Per risolvere il problema ed ottenere l'approvazione di `tfsec`:

1. Aprire `main.tf`.
2. Decommentare la riga all'interno del blocco `azurerm_storage_account`:
   ```hcl
   min_tls_version = "TLS1_2"
   ```
3. Eseguire nuovamente lo scan via Docker:
   ```bash
   docker run --rm -it -v "$(pwd):/src" aquasec/tfsec /src
   ```
4. **Risultato:** Tutti i controlli risulteranno superati (**Green / Passed**).

---

## 5. Deployment e Ciclo di Vita delle Risorse

### 1. Inizializzazione del Progetto
Scarica i provider e i plugin necessari (definiti in `required_providers`):
```bash
terraform init
```

### 2. Generazione del Piano di Esecuzione (Dry-Run)
Verifica quali risorse verranno create, modificate o eliminate:
```bash
terraform plan
```

### 3. Applicazione delle Modifiche
Crea l'infrastruttura reale su Microsoft Azure:
```bash
terraform apply -auto-approve
```

### 4. Teardown e Pulizia (Destroy) 🧹
Al termine dell'esercitazione o della lezione, rimuovere tutte le risorse create per evitare costi inutili in cloud:
```bash
terraform destroy -auto-approve
```

---

## 6. Best Practices e Raccomandazioni Finali

1. **Gestione dei Segreti:**
   - Non salvare mai credenziali o password in chiaro nel codice HCL.
   - Utilizzare variabili d'ambiente di pipeline (es. `ARM_CLIENT_SECRET`) o soluzioni di key vaulting (es. Azure Key Vault).
2. **Pinning delle Versioni:**
   - Fissare sempre la versione del provider Azure (`version = "=2.96.0"`) per evitare che aggiornamenti automatici imprevisti rompano le pipeline CI/CD.
3. **Principio del Minimo Privilegio:**
   - Utilizzare una **Service Principal** o un utente dedicato a Terraform con permessi minimi indispensabili sull'infrastruttura.
