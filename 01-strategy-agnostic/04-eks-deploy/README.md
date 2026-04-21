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

### Step 3: Deploy dell'applicazione

```bash
# Applica il deployment
kubectl apply -f 01-strategy-agnostic/04-eks-deploy/deployment.yaml

# Monitora lo stato del deployment
kubectl rollout status deployment/gestionale-app

# Vedi i Pod creati
kubectl get pods -l app=gestionale

# Dettagli su un Pod
kubectl describe pod $(kubectl get pods -l app=gestionale -o jsonpath='{.items[0].metadata.name}')
```

### Step 4: Scaling Manuale

```bash
# Scala a 4 repliche per gestire un picco di traffico
kubectl scale deployment gestionale-app --replicas=4

# Verifica
kubectl get pods -l app=gestionale
# OUTPUT: 4 pod Running

# Scala di nuovo a 2 (risparmio costi/energia)
kubectl scale deployment gestionale-app --replicas=2
```

### Step 5: Horizontal Pod Autoscaler (HPA)

```bash
# Installa metrics-server (necessario per HPA)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Crea HPA: scala da 2 a 10 pod se CPU > 70%
kubectl autoscale deployment gestionale-app \
  --cpu-percent=70 \
  --min=2 \
  --max=10

# Visualizza lo stato HPA
kubectl get hpa gestionale-app
```

### Step 6: Rolling Update

```bash
# Aggiorna all'immagine versione 1.1 senza downtime
kubectl set image deployment/gestionale-app \
  gestionale=gestionale-app:1.1

# Monitora il rolling update (pod vecchi vengono sostituiti gradualmente)
kubectl rollout status deployment/gestionale-app

# Se qualcosa va storto, rollback alla versione precedente
kubectl rollout undo deployment/gestionale-app

# Visualizza la storia dei deployment
kubectl rollout history deployment/gestionale-app
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Elimina le risorse Kubernetes
kubectl delete -f 01-strategy-agnostic/04-eks-deploy/deployment.yaml
kubectl delete hpa gestionale-app

# Elimina il cluster EKS (evita costi)
eksctl delete cluster --name gestionale-cluster --region eu-west-1

echo "Cluster EKS eliminato - nessun costo ricorrente"
```

## ✅ Checkpoint
- [ ] Comprendo la differenza tra Pod, Deployment e Service
- [ ] Cluster EKS creato (o minikube come alternativa)
- [ ] Deployment applicato e Pod in Running
- [ ] Scaling manuale eseguito con `kubectl scale`
- [ ] HPA configurato
- [ ] Rolling update eseguito senza downtime

## 📖 Approfondimenti
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Amazon EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/)
- [eksctl documentation](https://eksctl.io/)
- Libro: "Kubernetes in Action" di Marko Lukša (Manning)
