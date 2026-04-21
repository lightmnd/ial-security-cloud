# 📘 Lezione 16 – Auto Scaling e Graviton

**📅 Data:** Mercoledì 22/07/2025  
**🗂️ Modulo:** Modulo 3 – Sostenibilità & FinOps  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Configurare Auto Scaling con target tracking policy
- Comprendere i vantaggi di Graviton (ARM) per sostenibilità e costo
- Eseguire il right-sizing delle istanze EC2
- Deployare un'architettura con Launch Template e ASG

## 📚 Concetti Chiave

### Auto Scaling: Elasticità Intelligente
L'Auto Scaling Group (ASG) mantiene il numero corretto di istanze EC2 in base al carico. Tipi di policy:

**Target Tracking**: il più semplice. "Mantieni la CPU al 60%". L'ASG scala in e out automaticamente per mantenere il target.

**Step Scaling**: "Se CPU > 70% aggiungi 2 istanze, se CPU > 90% aggiungi 4". Più granulare.

**Scheduled Scaling**: "Ogni lunedì mattina alle 8 scala a 4 istanze". Per carichi prevedibili.

**Predictive Scaling**: ML che prevede il carico futuro e scala in anticipo.

### AWS Graviton: La Rivoluzione ARM nel Cloud
AWS ha sviluppato i propri chip ARM basati su architettura ARM:
- **Graviton1** (2018): prima generazione
- **Graviton2** (2020): 40% migliore prezzo/performance vs generazione precedente
- **Graviton3** (2022): 60% più efficiente energeticamente vs x86 equivalente
- **Graviton4** (2024): +30% performance vs Graviton3

**Famiglie di istanze Graviton (t = "g" suffisso):**
- t4g (General Purpose) → sostituisce t3
- m7g (Memory Optimized) → sostituisce m6i
- c7g (Compute Optimized) → sostituisce c6i
- r7g (Memory Intensive) → sostituisce r6i

**Costi:** tipicamente 20% meno care a parità di performance vs equivalente x86.

**Compatibilità:** qualsiasi applicazione Docker funziona su Graviton. Il codice Python, Java, Node.js funziona senza modifiche. Solo C/C++ potrebbe richiedere ricompilazione.

### Right-Sizing: Non Sprecare
Il right-sizing è il processo di abbinare le dimensioni delle risorse al reale utilizzo:
- Un'istanza `m5.2xlarge` con CPU al 5% → candidata a `t4g.medium`
- Un Lambda con 1024 MB ma ne usa 128 → riduci a 256 MB
- AWS Compute Optimizer fornisce raccomandazioni automatiche basate su 14 giorni di metriche

## 🛠️ Hands-on: ASG con Graviton

### Prerequisiti
- AWS CLI configurata con permessi `ec2:*`, `autoscaling:*`
- VPC con almeno 2 subnet in AZ diverse (dalla lezione 6)
- Esaminare il file `asg-config.yaml` per il template CloudFormation

### Step 1: Esaminare il template CloudFormation

```bash
cat 03-sustainability-finops/16-autoscaling-graviton/asg-config.yaml
```

### Step 2: Deploy del stack CloudFormation

```bash
# Prima ottieni gli ID VPC e subnet creati nella lezione 6
VPC_ID=$(aws ec2 describe-vpcs \
  --filters Name=tag:Name,Value=gestionale-vpc \
  --region eu-west-1 \
  --query 'Vpcs[0].VpcId' --output text)

SUBNET_IDS=$(aws ec2 describe-subnets \
  --filters Name=vpc-id,Value=$VPC_ID \
  --region eu-west-1 \
  --query 'Subnets[*].SubnetId' --output text | tr '\t' ',')

# Deploy il template CloudFormation
aws cloudformation create-stack \
  --stack-name gestionale-asg \
  --template-body file://03-sustainability-finops/16-autoscaling-graviton/asg-config.yaml \
  --parameters \
    ParameterKey=VpcId,ParameterValue=$VPC_ID \
    ParameterKey=SubnetIds,ParameterValue=$SUBNET_IDS \
    ParameterKey=Environment,ParameterValue=dev \
  --capabilities CAPABILITY_IAM \
  --region eu-west-1

# Monitora la creazione dello stack
aws cloudformation wait stack-create-complete \
  --stack-name gestionale-asg \
  --region eu-west-1

echo "Stack CloudFormation creato!"
```

### Step 3: Verificare l'ASG e le istanze

```bash
# Vedi lo stato dell'ASG
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names gestionale-asg \
  --region eu-west-1 \
  --query 'AutoScalingGroups[0].{Min:MinSize,Max:MaxSize,Desired:DesiredCapacity,Istanze:Instances[*].InstanceId}' \
  --output json

# Vedi il tipo di istanza delle istanze Graviton
aws ec2 describe-instances \
  --filters "Name=tag:aws:autoscaling:groupName,Values=gestionale-asg" \
  --region eu-west-1 \
  --query 'Reservations[*].Instances[*].{ID:InstanceId,Tipo:InstanceType,Stato:State.Name,AZ:Placement.AvailabilityZone}' \
  --output table
```

### Step 4: Simulare un picco di carico

```bash
# Ottieni l'ID di un'istanza nell'ASG
INSTANCE_ID=$(aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names gestionale-asg \
  --region eu-west-1 \
  --query 'AutoScalingGroups[0].Instances[0].InstanceId' \
  --output text)

# Imposta manualmente un override al desired capacity (simula carico)
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name gestionale-asg \
  --desired-capacity 3 \
  --region eu-west-1

# Dopo qualche minuto, verifica il scale-out
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names gestionale-asg \
  --region eu-west-1 \
  --query 'AutoScalingGroups[0].Instances[*].{ID:InstanceId,Stato:LifecycleState}' \
  --output table

# Scala di nuovo a 1 (risparmio)
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name gestionale-asg \
  --desired-capacity 1 \
  --region eu-west-1
```

### Step 5: Confronto costo Graviton vs x86

```bash
# Confronto teorico (prezzi eu-west-1, on-demand, Linux)
echo "Confronto istanze simili per il gestionale:"
echo ""
echo "t3.small  (x86):  $0.023/ora  → $16.56/mese"
echo "t4g.small (ARM):  $0.0184/ora → $13.25/mese"
echo "Risparmio: 20% sul costo, 60% meno energia"
echo ""
echo "Per 5 istanze in produzione:"
echo "t3.small x5:  $82.80/mese"
echo "t4g.small x5: $66.24/mese"
echo "Risparmio annuo: $(echo '(82.80 - 66.24) * 12' | bc) USD"
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Elimina lo stack CloudFormation (elimina tutte le risorse)
aws cloudformation delete-stack \
  --stack-name gestionale-asg \
  --region eu-west-1

aws cloudformation wait stack-delete-complete \
  --stack-name gestionale-asg \
  --region eu-west-1

echo "Stack eliminato - nessun costo ricorrente"
```

## ✅ Checkpoint
- [ ] Comprendo la differenza tra Target Tracking e Step Scaling
- [ ] Istanze Graviton (t4g) deploy tramite CloudFormation
- [ ] ASG configurato con min=1, max=4, target CPU 60%
- [ ] Scale-out manuale simulato e verificato
- [ ] Calcolo risparmio Graviton vs x86 completato

## 📖 Approfondimenti
- [Amazon EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/)
- [AWS Graviton Processor](https://aws.amazon.com/ec2/graviton/)
- [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/)
- [CloudFormation Documentation](https://docs.aws.amazon.com/cloudformation/)
