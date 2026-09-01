# 📘 Lezione 19a - Terraform Core (Hands-on 30 minuti)

**Modulo:** 04 - IaC & Osservabilita  
**Durata massima:** 30 minuti  
**Livello:** Base/Intermedio

## 🎯 Obiettivi del laboratorio
- Capire il ciclo Terraform: `init`, `plan`, `apply`, `destroy`
- Usare variabili e output per rendere il codice riusabile
- Creare risorse AWS minime ma realistiche e sicure
- Verificare rapidamente il risultato con AWS CLI

## 🧱 Cosa viene creato
- 1 bucket S3 con:
  - versioning abilitato
  - cifratura server-side (SSE-S3)
  - blocco accessi pubblici
- 1 log group CloudWatch con retention configurabile

## ⏱️ Agenda consigliata (30 minuti)
1. 0-5 min: prerequisiti e setup
2. 5-10 min: `terraform init` + `validate`
3. 10-15 min: `terraform plan`
4. 15-20 min: `terraform apply` + output
5. 20-25 min: verifica da AWS CLI
6. 25-30 min: mini modifica + `destroy`

## ✅ Prerequisiti
- Terraform >= 1.6 (`terraform version`)
- AWS CLI configurata (`aws sts get-caller-identity`)
- Permessi IAM per S3, CloudWatch Logs e lettura account

## 📂 File del laboratorio
- `providers.tf`: provider AWS e tag di default
- `variables.tf`: input parametrizzabili
- `main.tf`: risorse, data source e output

## 🚀 Esecuzione step-by-step

### 1) Vai nella cartella e inizializza

```bash
cd 04-iac-observability/19a-terraform-core
terraform init
terraform validate
```

### 2) Esegui il piano

```bash
terraform plan \
  -var="project_name=gestionale" \
  -var="environment=lab" \
  -var="owner=roberto" \
  -out=tfplan
```

Controlla nel piano che siano previste risorse S3 e CloudWatch.

### 3) Applica il piano

```bash
terraform apply tfplan
```

### 4) Leggi gli output

```bash
terraform output
```

Output attesi:
- `aws_account_id`
- `aws_region`
- `s3_bucket_name`
- `cloudwatch_log_group_name`

### 5) Verifica veloce con AWS CLI

```bash
BUCKET=$(terraform output -raw s3_bucket_name)
LOG_GROUP=$(terraform output -raw cloudwatch_log_group_name)

aws s3api get-bucket-versioning --bucket "$BUCKET"
aws s3api get-bucket-encryption --bucket "$BUCKET"
aws s3api get-public-access-block --bucket "$BUCKET"
aws logs describe-log-groups --log-group-name-prefix "$LOG_GROUP" --max-items 1
```

## 🔁 Mini esercizio (3-5 minuti)
Aggiorna la retention log a 14 giorni senza toccare il codice:

```bash
terraform plan -var="log_retention_days=14"
terraform apply -auto-approve -var="log_retention_days=14"
```

Osserva nel piano che Terraform propone un update in-place del log group.

## 🧹 Cleanup obbligatorio (evita costi)

```bash
terraform destroy \
  -var="project_name=gestionale" \
  -var="environment=lab" \
  -var="owner=roberto" \
  -auto-approve
```

## 🛟 Troubleshooting rapido
- Errore credenziali AWS: riesegui `aws configure` o esporta il profilo corretto.
- Errore nome bucket: il bucket e globale; cambia `bucket_prefix` nel comando `plan/apply`.
- Errore regione: imposta `-var="aws_region=<regione>"`.

## 📌 Checkpoint finale
- [ ] `terraform init` e `terraform validate` OK
- [ ] `terraform plan` comprensibile e senza errori
- [ ] `terraform apply` completato
- [ ] verifiche AWS CLI positive
- [ ] `terraform destroy` eseguito

## 📖 Risorse utili
- Terraform docs: https://developer.hashicorp.com/terraform/docs
- AWS provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
