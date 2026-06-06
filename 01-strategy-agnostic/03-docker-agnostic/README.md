# 📘 Lezione 3 – Containerizzazione con Docker

**📅 Data:** Lunedì 08/06/2025  
**🗂️ Modulo:** Modulo 1 – Strategia & Agnosticismo  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Comprendere il ciclo di vita di un container Docker
- Creare un Dockerfile multi-stage per ottimizzare la dimensione dell'immagine
- Effettuare il push di un'immagine su Amazon ECR
- Eseguire la scansione di vulnerabilità sull'immagine

## 📚 Concetti Chiave

### Perché i Container?
I container risolvono il classico problema "funziona sulla mia macchina!". Un container impacchetta l'applicazione insieme a tutte le sue dipendenze (librerie, runtime, configurazione) in un'unità isolata che gira in modo identico ovunque: laptop, server on-premise, AWS, Azure, GCP.

**Differenza tra Container e VM:**
- Una VM virtualizza l'hardware intero (include SO completo) → pesante (~GB), lenta da avviare (minuti)
- Un container virtualizza solo il processo → leggero (~MB), veloce da avviare (secondi)
- I container condividono il kernel del sistema operativo host

### Dockerfile: Costruire Immagini
Un Dockerfile è una ricetta testuale per costruire un'immagine container. Ogni istruzione crea un layer nell'immagine. I layer vengono cachati, quindi ricostruire un'immagine dopo una piccola modifica è veloce.

**Istruzioni principali:**
- `FROM`: immagine base di partenza
- `WORKDIR`: directory di lavoro dentro il container
- `COPY`: copia file dall'host al container
- `RUN`: esegue un comando durante la build
- `ENV`: imposta variabile d'ambiente
- `EXPOSE`: documenta la porta (non la apre)
- `CMD`: comando eseguito all'avvio del container

### Multi-Stage Build: Immagini Leggere
La tecnica **multi-stage** usa più `FROM` nello stesso Dockerfile. La prima fase (builder) installa tutti gli strumenti di build; la seconda fase (runtime) copia solo i file compilati. Risultato: immagine finale molto più piccola e sicura (meno software = meno superficie d'attacco).

```
Stage 1 (builder): Python 3.11 + pip + dipendenze (~500MB)
                         ↓ copia solo /app e site-packages
Stage 2 (runtime): Python 3.11-slim (~100MB)
```

### Differenza tra Single-Stage e Multi-Stage

| Aspetto | Single-Stage | Multi-Stage |
|---|---|---|
| Numero di stage | 1 solo `FROM` | 2 o piu `FROM` |
| Contenuto immagine finale | Include spesso tool di build + runtime | Include solo cio che serve a runtime |
| Dimensione immagine | In genere maggiore | In genere minore |
| Superficie d'attacco | Maggiore (piu pacchetti installati) | Minore (meno componenti) |
| Velocita deploy/pull | Piu lenta su rete | Piu veloce su rete |
| Complessita Dockerfile | Piu semplice | Leggermente piu complesso |
| Quando usarlo | Demo rapide o prototipi | Produzione e ambienti cloud |

In pratica: con single-stage e piu facile partire, ma con multi-stage ottieni immagini piu leggere, piu sicure e piu efficienti da distribuire.

### Amazon ECR (Elastic Container Registry)
ECR è il registro privato di AWS per immagini Docker. Integrato con IAM per autenticazione, supporta scansione automatica delle vulnerabilità (ECR Enhanced Scanning con Inspector v2), lifecycle policies per eliminare immagini vecchie.

## 🛠️ Hands-on: Build, Scan e Push su ECR

### Prerequisiti
- Docker installato (`docker --version`)
- AWS CLI configurata con permessi `ecr:*`
- Regione: eu-west-1

### Step 1: Esaminare il Dockerfile multi-stage esistente

```bash
cat 01-strategy-agnostic/03-docker-agnostic/Dockerfile
```

Il Dockerfile dell'app gestionale già presente usa multi-stage build. Analizziamolo:

```dockerfile
# Stage 1: Builder — installa dipendenze
FROM python:3.12-alpine AS builder
WORKDIR /app
ENV VENV_PATH=/opt/venv
RUN python -m venv "$VENV_PATH"
ENV PATH="$VENV_PATH/bin:$PATH"
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt
COPY app.py .

# Stage 2: Runtime — immagine finale leggera
FROM python:3.12-alpine AS runtime
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
ENV VENV_PATH=/opt/venv
ENV PATH="$VENV_PATH/bin:$PATH"
COPY --from=builder "$VENV_PATH" "$VENV_PATH"
COPY --from=builder /app/app.py /app/app.py
USER appuser
EXPOSE 8080
CMD ["python", "app.py"]
```

### Step 2: Build dell'immagine

```bash
cd 01-strategy-agnostic/03-docker-agnostic/

# Build immagine ottimizzata (stage runtime) usata nei prossimi step
docker build --target runtime -t gestionale-app:1.0 .

# Tag aggiuntivo per confronto esplicito
docker tag gestionale-app:1.0 gestionale-app:multi

# Build stage builder (piu pesante) per confronto didattico
docker build --target builder -t gestionale-app:single .

# Confronta dimensioni: single-stage (builder) vs multi-stage (runtime)
docker images | grep 'gestionale-app'
```
> 💡 **Output atteso:** Vedrai almeno `gestionale-app:single` e `gestionale-app:multi` (oltre a `gestionale-app:1.0`). La versione multi-stage sarà significativamente più piccola.

### Step 3: Testare il container localmente

```bash
# Avvia il container
docker run -d \
  --name gestionale-test \
  -p 8080:8080 \
  -e ENVIRONMENT=development \
  gestionale-app:1.0

# Verifica che risponda
curl http://localhost:8080/api/health

# Controlla i log
docker logs gestionale-test

# Ferma e rimuovi il container
docker stop gestionale-test && docker rm gestionale-test
```

### Step 4: Creare il repository ECR

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="eu-west-1"

# Crea il repository ECR
aws ecr create-repository \
  --repository-name gestionale-app \
  --image-scanning-configuration scanOnPush=true \
  --encryption-configuration encryptionType=AES256 \
  --region $REGION

echo "Repository ECR creato: $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/gestionale-app"
```

### Step 5: Login e Push su ECR

```bash
# Login al registry ECR
aws ecr get-login-password --region $REGION | \
  docker login --username AWS --password-stdin \
  $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Tagga l'immagine per ECR
docker tag gestionale-app:1.0 \
  $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/gestionale-app:1.0

# Push
docker push \
  $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/gestionale-app:1.0

echo "Push completato!"
```

### Step 6: Scansione vulnerabilità ECR

```bash
# Avvia una scansione manuale (se scanOnPush non è bastato)
aws ecr start-image-scan \
  --repository-name gestionale-app \
  --image-id imageTag=1.0 \
  --region $REGION

# Attendi il completamento (circa 30 secondi)
sleep 30

# Visualizza i risultati
aws ecr describe-image-scan-findings \
  --repository-name gestionale-app \
  --image-id imageTag=1.0 \
  --region $REGION \
  --query 'imageScanFindings.findingSeverityCounts'
```

### Step 7: Lifecycle Policy per ECR (Sostenibilità)

```bash
# Mantieni solo le ultime 5 immagini tagged, elimina le untagged dopo 1 giorno
aws ecr put-lifecycle-policy \
  --repository-name gestionale-app \
  --lifecycle-policy-text '{
    "rules": [
      {
        "rulePriority": 1,
        "description": "Elimina immagini untagged dopo 1 giorno",
        "selection": {"tagStatus": "untagged", "countType": "sinceImagePushed", "countUnit": "days", "countNumber": 1},
        "action": {"type": "expire"}
      },
      {
        "rulePriority": 2,
        "description": "Mantieni solo le ultime 5 versioni",
        "selection": {"tagStatus": "tagged", "tagPrefixList": ["v"], "countType": "imageCountMoreThan", "countNumber": 5},
        "action": {"type": "expire"}
      }
    ]
  }' \
  --region $REGION
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Elimina tutte le immagini e il repository ECR
aws ecr delete-repository \
  --repository-name gestionale-app \
  --force \
  --region $REGION

# Rimuovi immagini locali
docker rmi gestionale-app:1.0 2>/dev/null || true
docker rmi gestionale-app:multi 2>/dev/null || true
docker rmi gestionale-app:single 2>/dev/null || true
docker rmi $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/gestionale-app:1.0 2>/dev/null || true

echo "Cleanup completato"
```

## ✅ Checkpoint
- [ ] Dockerfile multi-stage compreso e analizzato
- [ ] Immagine costruita localmente con `docker build`
- [ ] Container testato localmente con `docker run`
- [ ] Repository ECR creato con scansione automatica abilitata
- [ ] Immagine pushata su ECR
- [ ] Risultati scansione vulnerabilità visualizzati

## 📖 Approfondimenti
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Amazon ECR Documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/)
- [Docker Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Trivy Container Scanner](https://aquasecurity.github.io/trivy/)
