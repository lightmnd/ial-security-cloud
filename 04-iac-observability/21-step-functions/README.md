# 📘 Lezione 21 – Step Functions

**📅 Data:** Lunedì 09/09/2025  
**🗂️ Modulo:** Modulo 4 – IaC & Osservabilità  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere l'orchestrazione serverless con Step Functions
- Scrivere una state machine in ASL (Amazon States Language)
- Implementare retry, catch e wait states
- Deployare e testare il workflow di iscrizione

## 📚 Concetti Chiave

### Step Functions: Orchestrazione Visuale
AWS Step Functions orchestra funzioni Lambda e servizi AWS in workflow visivi. Ogni "stato" può essere: un Task (Lambda), una scelta (Choice), un'attesa (Wait), un loop (Map), o la fine (Succeed/Fail).

**Vantaggi:**
- Stato del workflow persistito da AWS (non nella tua applicazione)
- Retry automatico con backoff esponenziale
- Visualizzazione grafica dell'esecuzione
- Audit completo di ogni step

### ASL (Amazon States Language)
JSON che descrive la state machine. Ogni stato ha: Type, Next (o End:true), Retry, Catch.

## 🛠️ Hands-on: Workflow Iscrizione Studente

### Prerequisiti
- AWS CLI con permessi `states:*`, `lambda:*`
- Funzione Lambda dalla lezione 15 deployata (o placeholder ARN)

### Step 1: Esaminare la definizione della state machine

```bash
cat 04-iac-observability/21-step-functions/workflow-definition.json
```

### Step 2: Creare il ruolo IAM per Step Functions

```bash
ROLE_ARN=$(aws iam create-role \
  --role-name gestionale-sfn-role \
  --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"states.amazonaws.com"},"Action":"sts:AssumeRole"}]}' \
  --query 'Role.Arn' --output text)

aws iam attach-role-policy \
  --role-name gestionale-sfn-role \
  --policy-arn arn:aws:iam::aws:policy/AWSLambdaRole
```

### Step 3: Creare la state machine

```bash
SFN_ARN=$(aws stepfunctions create-state-machine \
  --name gestionale-iscrizione-workflow \
  --definition file://04-iac-observability/21-step-functions/workflow-definition.json \
  --role-arn $ROLE_ARN \
  --region eu-west-1 \
  --query 'stateMachineArn' --output text)

echo "State machine creata: $SFN_ARN"
```

### Step 4: Eseguire il workflow

```bash
EXECUTION_ARN=$(aws stepfunctions start-execution \
  --state-machine-arn $SFN_ARN \
  --input '{"studente_id":1,"studente_nome":"Mario Rossi","pagamento_effettuato":true}' \
  --region eu-west-1 \
  --query 'executionArn' --output text)

# Monitora l'esecuzione
aws stepfunctions describe-execution \
  --execution-arn $EXECUTION_ARN \
  --region eu-west-1 \
  --query '{Stato:status,Inizio:startDate,Fine:stopDate}'
```

### 🧹 Cleanup

```bash
aws stepfunctions delete-state-machine --state-machine-arn $SFN_ARN --region eu-west-1
aws iam detach-role-policy --role-name gestionale-sfn-role --policy-arn arn:aws:iam::aws:policy/AWSLambdaRole
aws iam delete-role --role-name gestionale-sfn-role
```

## ✅ Checkpoint
- [ ] ASL compreso (States, Type, Next, Retry, Catch)
- [ ] State machine creata
- [ ] Workflow eseguito con successo
- [ ] Esecuzione visualizzata nella console

## 📖 Approfondimenti
- [AWS Step Functions Documentation](https://docs.aws.amazon.com/step-functions/)
- [ASL Reference](https://states-language.net/spec.html)
