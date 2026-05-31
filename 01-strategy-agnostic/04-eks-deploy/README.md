# 📘 Lezione 4 – Orchestrazione con Kubernetes (EKS)

**📅 Data:** Mercoledì 10/06/2025  
**🗂️ Modulo:** Modulo 1 – Strategia & Agnosticismo  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere l'architettura di Kubernetes (control plane vs worker nodes)
- Creare e gestire Pod, Deployment e Service
- Eseguire uno scaling manuale e automatico
- Effettuare un rolling update senza downtime

## 📚 Concetti Chiave

### Kubernetes: Orchestratore di Container
Kubernetes (K8s) è il sistema open source per orchestrare container in produzione. Risolve i problemi che Docker da solo non gestisce: cosa succede se un container crasha? Come bilancio il traffico tra più istanze? Come aggiorno l'app senza downtime?

**Componenti del Control Plane:**
- **API Server**: punto di ingresso per tutte le operazioni — `kubectl` comunica con lui
- **etcd**: database distribuito che mantiene lo stato del cluster
- **Scheduler**: decide su quale nodo avviare i Pod
- **Controller Manager**: mantiene lo stato desiderato (es. "voglio 3 repliche" → avvia repliche mancanti)

**Componenti dei Worker Nodes:**
- **kubelet**: agente che gira su ogni nodo, esegue i Pod
- **kube-proxy**: gestisce le regole di rete per i Service
- **Container Runtime**: Docker o containerd che esegue effettivamente i container

### Oggetti Principali di Kubernetes

**Pod**: l'unità minima deployabile. Contiene uno o più container che condividono rete e storage. I Pod sono effimeri — se crashano vengono ricreati da un Deployment.

**Deployment**: gestisce un insieme di Pod identici (ReplicaSet). Garantisce che N repliche siano sempre attive. Supporta rolling updates e rollback.

**Service**: espone i Pod con un endpoint stabile. Tipi principali:
- `ClusterIP` (default): accessibile solo dentro il cluster
- `NodePort`: apre una porta su ogni nodo
- `LoadBalancer`: crea un load balancer cloud (AWS ELB)

**ConfigMap / Secret**: separano la configurazione dal codice. ConfigMap per dati non sensibili, Secret per credenziali (base64 encoded).

### Amazon EKS
EKS è il Kubernetes gestito di AWS. AWS gestisce il control plane (alta disponibilità, aggiornamenti), tu gestisci i worker nodes (EC2 o Fargate). Integrazione nativa con IAM, ELB, EBS, CloudWatch.

## 🛠️ Hands-on: Deploy del Gestionale su EKS

### Prerequisiti
- `kubectl` installato (`kubectl version --client`)
- `eksctl` installato (`eksctl version`)
- AWS CLI configurata con permessi EKS

```bash
# macOS
brew install kubectl
brew tap weaveworks/tap && brew install weaveworks/tap/eksctl

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

curl --silent --location \
  "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
  | tar xz -C /tmp && sudo mv /tmp/eksctl /usr/local/bin/

# Verifica
kubectl version --client
exksctl version
```

### Step 1: Creare il cluster EKS (⚠️ richiede ~15 minuti)

```bash
# Crea cluster EKS con eksctl (approccio Infrastructure as Code)
eksctl create cluster \
  --name gestionale-cluster \
  --region eu-west-1 \
  --nodegroup-name workers \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed

# Configura kubectl per il nuovo cluster
aws eks update-kubeconfig \
  --name gestionale-cluster \
  --region eu-west-1

# Verifica connessione
kubectl get nodes
```
> 💡 **Alternativa:** Per evitare costi EKS, usa `minikube start` o `kind create cluster` per un cluster locale.

#### Cosa fa ogni flag di `eksctl create cluster`

| Flag | Significato |
|---|---|
| `--name gestionale-cluster` | Nome del cluster |
| `--region eu-west-1` | Regione AWS – Irlanda (dati in UE per GDPR) |
| `--nodegroup-name workers` | Nome del gruppo di nodi (le VM che eseguono i container) |
| `--node-type t3.medium` | Tipo di istanza EC2: 2 vCPU, 4 GiB RAM — adatta per test |
| `--nodes 2` | Numero iniziale di nodi al momento della creazione |
| `--nodes-min 1` | Soglia minima autoscaling: non scende mai sotto 1 nodo |
| `--nodes-max 4` | Soglia massima autoscaling: crea fino a 4 nodi se il carico cresce |
| `--managed` | Abilita i **Managed Node Groups**: AWS gestisce OS, patch e aggiornamenti K8s |

`eksctl` configura automaticamente anche VPC, sottoreti, Security Group e ruoli IAM.

### Step 2: Esaminare il Deployment esistente

```bash
cat 01-strategy-agnostic/04-eks-deploy/deployment.yaml
```

Il file `deployment.yaml` definisce il Deployment e il Service per il gestionale. Analizziamo la struttura:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gestionale-app
  labels:
    app: gestionale
spec:
  replicas: 2                    # 2 Pod sempre attivi
  selector:
    matchLabels:
      app: gestionale
  strategy:
    type: RollingUpdate          # Aggiornamento senza downtime
    rollingUpdate:
      maxSurge: 1                # Avvia 1 Pod nuovo prima di killare vecchi
      maxUnavailable: 0          # Nessun Pod offline durante update
  template:
    spec:
      containers:
      - name: gestionale
        image: gestionale-app:1.0
        ports:
        - containerPort: 8000
        resources:
          requests:              # Risorse minime garantite
            memory: "128Mi"
            cpu: "100m"
          limits:                # Risorse massime consentite
            memory: "256Mi"
            cpu: "500m"
        readinessProbe:          # K8s aspetta che sia pronto prima di inviare traffico
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 10
```

### Step 2b: Creare il repository ECR e fare il push dell'immagine

Il `deployment.yaml` referenzia un'immagine ECR (`<ACCOUNT_ID>.dkr.ecr.eu-west-1.amazonaws.com/gestionale-app:1.0`). Prima del deploy occorre creare il repository, costruire l'immagine dal Dockerfile della Lezione 3 e fare il push. Tagghiamo subito anche la versione `1.1` che servirà per il Rolling Update.

```bash
# Variabili
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=eu-west-1
ECR_REPO=gestionale-app
ECR_URI=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO

# 1. Crea il repository ECR (una tantum; --image-scanning-configuration abilita scan automatico al push)
aws ecr create-repository \
  --repository-name $ECR_REPO \
  --region $REGION \
  --image-scanning-configuration scanOnPush=true

# 2. Autentica Docker su ECR
aws ecr get-login-password --region $REGION \
  | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# 3. Build dell'immagine (usa il Dockerfile della Lezione 3)
docker build -t $ECR_REPO:1.0 01-strategy-agnostic/03-docker-agnostic/

# 4. Tag e push versione 1.0
docker tag $ECR_REPO:1.0 $ECR_URI:1.0
docker push $ECR_URI:1.0

# 5. Tag e push versione 1.1 (simula rilascio nuovo — necessario per lo Step 6)
docker tag $ECR_REPO:1.0 $ECR_URI:1.1
docker push $ECR_URI:1.1

echo "Immagini disponibili in ECR: $ECR_URI:1.0 e $ECR_URI:1.1"
```

> 💡 `scanOnPush=true` fa partire automaticamente una scansione CVE (Trivy-based) ad ogni push — risultati visibili in **ECR → Repository → gestionale-app → Image scanning**.

### Step 3: Deploy dell'applicazione

> ⚠️ **Il file `deployment.yaml` contiene il placeholder `<ACCOUNT_ID>`** che deve essere sostituito con l'ID del tuo account AWS prima di applicarlo. Kubernetes non riesce a risolvere il nome dell'immagine ECR se il placeholder è rimasto letterale (errore `InvalidImageName`).

```bash
# Sostituisce <ACCOUNT_ID> al volo senza modificare il file
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "Account ID: $ACCOUNT_ID"

sed "s/<ACCOUNT_ID>/$ACCOUNT_ID/g" \
  01-strategy-agnostic/04-eks-deploy/deployment.yaml \
  | kubectl apply -f -

# Monitora lo stato del deployment
kubectl rollout status deployment/gestionale-app-deployment

# Vedi i Pod creati
kubectl get pods -l app=gestionale

# Dettagli su un Pod (utile per debug)
kubectl describe pod $(kubectl get pods -l app=gestionale -o jsonpath='{.items[0].metadata.name}')
```

> 💡 Il Pod resta in `Pending` o `ImagePullBackOff` se l'immagine `gestionale-app:1.0` non esiste nel tuo ECR. In quel caso, o crei prima il repository ECR e fai il push dell'immagine, oppure usa l'immagine locale dalla lezione 3:
> ```bash
> # Alternativa con immagine pubblica per test rapido
> kubectl set image deployment/gestionale-app-deployment \
>   gestionale-container=python:3.12-slim
> ```

### Step 4: Scaling Manuale

> `kubectl scale` imposta **manualmente** un numero fisso di repliche. Decidi tu quante istanze avviare. È immediato ma non reagisce al carico in modo autonomo.

```bash
# Scala a 4 repliche per gestire un picco di traffico
kubectl scale deployment gestionale-app-deployment --replicas=4

# Verifica
kubectl get pods -l app=gestionale
# OUTPUT: 4 pod Running

# Scala di nuovo a 2 (risparmio costi/energia)
kubectl scale deployment gestionale-app-deployment --replicas=2
```

### Step 5: Horizontal Pod Autoscaler (HPA)

> `kubectl autoscale` (HPA) crea un controller che **monitora le metriche in continuo** e aggiusta automaticamente le repliche tra `--min` e `--max`. A differenza di `kubectl scale`, non intervieni tu: è Kubernetes che scala su e giù in base al carico reale.
>
> | | `kubectl scale` | HPA (`kubectl autoscale`) |
> |---|---|---|
> | Chi decide | Tu, manualmente | Kubernetes, in automatico |
> | Reagisce al carico | No | Sì (CPU, memoria, metriche custom) |
> | Persistente | No (va riapplicato) | Sì (risorsa `HorizontalPodAutoscaler`) |
> | Caso d'uso | Picchi noti, manutenzione | Produzione, traffico variabile |

```bash
# metrics-server è già installato su EKS managed — se ricevi conflitti
# ("spec.selector: field is immutable"), elimina e reinstalla:
kubectl delete deployment metrics-server -n kube-system 2>/dev/null || true
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Attendi che metrics-server sia pronto
kubectl rollout status deployment/metrics-server -n kube-system

# Elimina eventuale HPA esistente prima di ricrearlo
kubectl delete hpa gestionale-app-deployment 2>/dev/null || true

# Crea HPA: scala da 2 a 10 pod se CPU > 70%
# Nota: --cpu-percent è deprecato da K8s 1.23+, usare --cpu=70%
kubectl autoscale deployment gestionale-app-deployment \
  --cpu=70% \
  --min=2 \
  --max=10

# Visualizza lo stato HPA
kubectl get hpa gestionale-app-deployment
```

### Step 6: Rolling Update

```bash
# Aggiorna all'immagine versione 1.1 senza downtime
# (ACCOUNT_ID necessario perché l'immagine è su ECR)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
kubectl set image deployment/gestionale-app-deployment \
  gestionale-container=$ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/gestionale-app:1.1

# Monitora il rolling update (pod vecchi vengono sostituiti gradualmente)
kubectl rollout status deployment/gestionale-app-deployment

# Se qualcosa va storto, rollback alla versione precedente
kubectl rollout undo deployment/gestionale-app-deployment

# Visualizza la storia dei deployment
kubectl rollout history deployment/gestionale-app-deployment
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Elimina le risorse Kubernetes
kubectl delete -f 01-strategy-agnostic/04-eks-deploy/deployment.yaml
kubectl delete hpa gestionale-app-deployment 2>/dev/null || true

# Elimina il repository ECR e tutte le immagini (--force rimuove anche immagini presenti)
aws ecr delete-repository \
  --repository-name gestionale-app \
  --region eu-west-1 \
  --force

# Elimina il cluster EKS (evita costi)
eksctl delete cluster --name gestionale-cluster --region eu-west-1

echo "Cluster EKS ed ECR eliminati - nessun costo ricorrente"
```

## ✅ Checkpoint
- [ ] Comprendo la differenza tra Pod, Deployment e Service
- [ ] Cluster EKS creato (o minikube come alternativa)
- [ ] Repository ECR creato e immagine pushata (`:1.0` e `:1.1`)
- [ ] Deployment applicato e Pod in Running
- [ ] Scaling manuale eseguito con `kubectl scale`
- [ ] HPA configurato
- [ ] Rolling update eseguito senza downtime

## 📖 Approfondimenti
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Amazon EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/)
- [eksctl documentation](https://eksctl.io/)
- Libro: "Kubernetes in Action" di Marko Lukša (Manning)
