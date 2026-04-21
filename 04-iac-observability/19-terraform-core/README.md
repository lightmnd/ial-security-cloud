# 📘 Lezione 19 – Terraform IaC

**📅 Data:** Lunedì 03/08/2025  
**🗂️ Modulo:** Modulo 4 – IaC & Osservabilità  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere Infrastructure as Code con Terraform
- Gestire providers, state e modules
- Eseguire plan/apply/destroy in modo sicuro

## 📚 Concetti Chiave

### Terraform: IaC Dichiarativo
Terraform descrive l'infrastruttura desiderata in file HCL. Il motore Terraform calcola la differenza tra stato attuale e desiderato e applica solo le modifiche necessarie.

**Workflow:**
1. `terraform init` — scarica i providers
2. `terraform plan` — mostra le modifiche senza applicarle
3. `terraform apply` — applica le modifiche
4. `terraform destroy` — distrugge l'infrastruttura

**State**: Terraform salva lo stato dell'infrastruttura in `terraform.tfstate`. In team, usa un backend remoto (S3 + DynamoDB lock) per condividere lo state in modo sicuro.

### Struttura dei File
- `providers.tf` — configurazione provider e backend
- `variables.tf` — variabili di input
- `main.tf` — risorse principali
- `outputs.tf` — valori di output

## 🛠️ Hands-on: Deploy del Gestionale con Terraform

### Prerequisiti
- Terraform >= 1.5 installato (`terraform version`)
- AWS CLI configurata

### Step 1: Esaminare i file Terraform

```bash
cat 04-iac-observability/19-terraform-core/providers.tf
cat 04-iac-observability/19-terraform-core/variables.tf
cat 04-iac-observability/19-terraform-core/main.tf
```

### Step 2: Inizializzare Terraform

```bash
cd 04-iac-observability/19-terraform-core/

# Inizializza (scarica provider AWS)
terraform init

# Valida la sintassi
terraform validate
```

### Step 3: Pianificare e applicare

```bash
# Piano con variabili custom
terraform plan \
  -var="environment=dev" \
  -var="project_name=gestionale" \
  -out=gestionale.tfplan

# Rivedi il piano, poi applica
terraform apply gestionale.tfplan
```

### Step 4: Verificare le risorse create

```bash
# Visualizza gli output
terraform output

# Lista risorse nello state
terraform state list
```

### 🧹 Cleanup (Sostenibilità)

```bash
terraform destroy -var="environment=dev" -auto-approve
```

## ✅ Checkpoint
- [ ] Terraform init eseguito con successo
- [ ] terraform plan mostra le risorse da creare
- [ ] terraform apply completato
- [ ] terraform destroy eseguito

## 📖 Approfondimenti
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
