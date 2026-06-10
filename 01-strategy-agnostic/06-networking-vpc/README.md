# 📘 Lezione 6 – Networking: Connettere sistemi ibridi

**📅 Data:** Mercoledì 17/06/2025  
**🗂️ Modulo:** Modulo 1 – Strategia & Agnosticismo  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere la struttura di una VPC AWS con subnet pubbliche e private
- Configurare Security Groups e Network ACL
- Creare un VPC Peering per connettere ambienti separati

## 📚 Concetti Chiave

### VPC (Virtual Private Cloud)
Una VPC è la tua rete privata isolata all'interno di AWS. Puoi pensarla come il tuo datacenter virtuale. Definisce: range di indirizzi IP (CIDR block), subnet, tabelle di routing, gateway.

### Subnet Pubbliche vs Private
- **Subnet pubblica**: ha una route verso l'Internet Gateway — le risorse qui possono ricevere traffico da internet (es. load balancer, bastion host)
- **Subnet privata**: nessuna route diretta a internet — le risorse qui non sono direttamente raggiungibili dall'esterno (es. database, app server)
- Le risorse in subnet privata accedono a internet (per aggiornamenti) tramite un **NAT Gateway** nella subnet pubblica

### VPC Peering e Transit Gateway
- **VPC Peering**: connessione punto-punto tra due VPC. Semplice, senza costi aggiuntivi (solo traffico). Limite: non è transitivo (A→B e B→C non significa A→C).
- **Transit Gateway**: hub centrale che connette molte VPC e reti on-premise. Più costoso ma scalabile per architetture complesse (>5 VPC).

### Architettura Raccomandata: 3-Tier
```
Internet
   │
   ▼
[Internet Gateway]
   │
   ▼
┌─────────────────────────────────┐
│     SUBNET PUBBLICA us-east-1a  │
│  ┌──────────────┐               │
│  │ Load Balancer│               │
│  │ NAT Gateway  │               │
│  └──────────────┘               │
└─────────────────────────────────┘
   │
   ▼ (solo traffico interno)
┌─────────────────────────────────┐
│    SUBNET PRIVATA us-east-1a    │
│  ┌──────────────┐               │
│  │  App Server  │               │
│  │  (ECS/EC2)   │               │
│  └──────────────┘               │
└─────────────────────────────────┘
   │
   ▼ (solo porta 5432)
┌─────────────────────────────────┐
│    SUBNET DATABASE us-east-1a   │
│  ┌──────────────┐               │
│  │  PostgreSQL  │               │
│  │  (RDS/EC2)   │               │
│  └──────────────┘               │
└─────────────────────────────────┘
```

## 🛠️ Hands-on: VPC Setup e Peering

### Prerequisiti
- AWS CLI configurata
- Permessi IAM: `ec2:*`
- Esegui lo script `vpc-setup.sh` presente in questa cartella per automatizzare i passi

### Step 1: Creare la VPC Principale

```bash
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --region us-east-1 \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=gestionale-vpc},{Key=Project,Value=gestionale}]' \
  --query 'Vpc.VpcId' \
  --output text)

echo "VPC creata: $VPC_ID"

aws ec2 modify-vpc-attribute \
  --vpc-id $VPC_ID \
  --enable-dns-hostnames
```

### Step 2: Creare Subnet Pubblica e Privata

```bash
SUBNET_PUBLIC=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=gestionale-public-1a}]' \
  --query 'Subnet.SubnetId' \
  --output text)

SUBNET_PRIVATE=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.2.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=gestionale-private-1a}]' \
  --query 'Subnet.SubnetId' \
  --output text)
```

### Step 3: Internet Gateway e Routing

```bash
IGW_ID=$(aws ec2 create-internet-gateway \
  --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=gestionale-igw}]' \
  --query 'InternetGateway.InternetGatewayId' \
  --output text)

aws ec2 attach-internet-gateway \
  --internet-gateway-id $IGW_ID \
  --vpc-id $VPC_ID

RT_PUBLIC=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.RouteTableId' \
  --output text)

aws ec2 create-route \
  --route-table-id $RT_PUBLIC \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID

aws ec2 associate-route-table \
  --route-table-id $RT_PUBLIC \
  --subnet-id $SUBNET_PUBLIC
```

### Step 4: Security Groups

```bash
SG_LB=$(aws ec2 create-security-group \
  --group-name "gestionale-lb-sg" \
  --description "SG per load balancer gestionale" \
  --vpc-id $VPC_ID \
  --query 'GroupId' \
  --output text)

aws ec2 authorize-security-group-ingress \
  --group-id $SG_LB \
  --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
  --group-id $SG_LB \
  --protocol tcp --port 443 --cidr 0.0.0.0/0
```

### Step 5: VPC Peering

```bash
VPC_ANALYTICS=$(aws ec2 create-vpc \
  --cidr-block 10.1.0.0/16 \
  --region us-east-1 \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=analytics-vpc}]' \
  --query 'Vpc.VpcId' \
  --output text)

PEER_ID=$(aws ec2 create-vpc-peering-connection \
  --vpc-id $VPC_ID \
  --peer-vpc-id $VPC_ANALYTICS \
  --region us-east-1 \
  --query 'VpcPeeringConnection.VpcPeeringConnectionId' \
  --output text)

aws ec2 accept-vpc-peering-connection \
  --vpc-peering-connection-id $PEER_ID \
  --region us-east-1

echo "Peering creato: $PEER_ID"
```

### 🧹 Cleanup (Sostenibilità)

```bash
aws ec2 delete-vpc-peering-connection --vpc-peering-connection-id $PEER_ID
aws ec2 delete-vpc --vpc-id $VPC_ANALYTICS
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID
aws ec2 delete-subnet --subnet-id $SUBNET_PUBLIC
aws ec2 delete-subnet --subnet-id $SUBNET_PRIVATE
aws ec2 delete-security-group --group-id $SG_LB
aws ec2 delete-vpc --vpc-id $VPC_ID
```

## ✅ Checkpoint
- [ ] VPC creata con CIDR 10.0.0.0/16
- [ ] Subnet pubblica e privata create
- [ ] Internet Gateway attaccato e route configurata
- [ ] Security Group creato con regole corrette
- [ ] VPC Peering configurato tra le due VPC

## 📖 Approfondimenti
- [Amazon VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [VPC Peering Guide](https://docs.aws.amazon.com/vpc/latest/peering/)
- [AWS Transit Gateway](https://docs.aws.amazon.com/transit-gateway/)
