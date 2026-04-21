# 📘 Lezione 2 – Architetture Cloud Agnostic vs Cloud Native

**📅 Data:** Mercoledì 03/06/2025  
**🗂️ Modulo:** Modulo 1 – Strategia & Agnosticismo  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Distinguere tra approccio Cloud Native e Cloud Agnostic
- Identificare i rischi del vendor lock-in
- Progettare un'architettura a microservizi agnostica

## 📚 Concetti Chiave

### Cloud Native vs Cloud Agnostic

**Cloud Native** significa costruire applicazioni sfruttando al massimo le funzionalità specifiche di un cloud provider. Esempio: un'app che usa AWS Lambda, DynamoDB, API Gateway, SQS — servizi che non esistono altrove nella stessa forma. Vantaggi: massima ottimizzazione, meno codice da scrivere, SLA gestiti dal provider. Svantaggio principale: **vendor lock-in** — se vuoi cambiare provider, devi riscrivere tutto.

**Cloud Agnostic** significa costruire usando standard aperti e tecnologie portabili: container Docker, Kubernetes, PostgreSQL, Kafka, MinIO invece di S3. L'app può girare su AWS, Azure, GCP, o on-premise con modifiche minime. Vantaggi: portabilità, nessun lock-in, negoziazione contrattuale più forte. Svantaggio: più complessità operativa, devi gestire tu quello che il provider gestisce.

### Il Vendor Lock-in: Rischio Reale o Esagerato?

Il lock-in è un rischio **reale ma gestibile**. Una scuola di formazione che usa AWS solo per ospitare un gestionale probabilmente non ha motivo di cambiare provider. Ma un'azienda con vincoli regolatori (GDPR, settore finanziario, PA italiana con Codice Appalti) potrebbe avere l'obbligo contrattuale o normativo di poter cambiare fornitore.

La strategia pratica è **ibrida**: usa servizi nativi per le parti non critiche (es. notifiche email via SES), ma mantieni portabile il core business logic. I container e Kubernetes sono il punto di equilibrio ideale: gestiti (EKS, GKE, AKS) ma portabili.

### I Microservizi come Paradigma Agnostico

Un'architettura a microservizi divide l'applicazione in servizi piccoli, indipendenti, ognuno con la sua responsabilità. Ogni microservizio:
- Ha un singolo scopo (Single Responsibility Principle)
- Comunica via API HTTP/REST o messaggi (Kafka, RabbitMQ)
- Può essere sviluppato e deployato indipendentemente
- Può essere scritto in linguaggi diversi
- È containerizzato (Docker) → portabile su qualsiasi cloud

## 🛠️ Hands-on: Disegnare un'Architettura a Microservizi

### Prerequisiti
- Carta e penna (o draw.io: https://draw.io)
- Nessun account cloud necessario per questo lab

### Step 1: Il Sistema Gestionale Monolitico (As-Is)

```
┌─────────────────────────────────────────────────────┐
│                   MONOLITE                          │
│  ┌──────────┐  ┌──────────┐  ┌───────────────────┐ │
│  │  Studenti│  │  Corsi   │  │    Fatturazione   │ │
│  │          │  │          │  │                   │ │
│  │  Docenti │  │  Aule    │  │    Report PDF     │ │
│  └──────────┘  └──────────┘  └───────────────────┘ │
│                     │                               │
│              ┌──────────────┐                       │
│              │   Database   │                       │
│              │  PostgreSQL  │                       │
│              └──────────────┘                       │
└─────────────────────────────────────────────────────┘
```

Il problema: se il modulo Fatturazione ha un bug, cade tutto. Per aggiornare il modulo Corsi devo rideploy di tutto.

### Step 2: Architettura a Microservizi (To-Be)

```
                    ┌─────────────────┐
                    │   API Gateway   │  ← Punto di ingresso unico
                    │  (nginx/Kong)   │  ← Cloud Agnostic!
                    └────────┬────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
     ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐
     │  Studenti   │  │   Corsi     │  │Fatturazione │
     │  Service    │  │   Service   │  │  Service    │
     │  :8001      │  │   :8002     │  │  :8003      │
     │  Python/    │  │  Node.js    │  │   Java      │
     │  FastAPI    │  │  Express    │  │  Spring     │
     └──────┬──────┘  └──────┬──────┘  └──────┬──────┘
            │                │                │
     ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐
     │  PostgreSQL │  │  PostgreSQL │  │  PostgreSQL │
     │  studenti   │  │   corsi     │  │  pagamenti  │
     └─────────────┘  └─────────────┘  └─────────────┘

                    ┌─────────────────┐
                    │  Message Bus    │  ← Kafka o RabbitMQ
                    │  (Async comms)  │  ← Cloud Agnostic!
                    └─────────────────┘
```

### Step 3: Classificare i Componenti (Lock-in vs Agnostico)

| Componente | Tecnologia Scelta | Cloud Native? | Alternativa Agnostica |
|------------|-------------------|---------------|----------------------|
| API Gateway | AWS API Gateway | ✅ Lock-in | nginx, Kong, Traefik |
| Message Queue | AWS SQS | ✅ Lock-in | RabbitMQ, Kafka |
| Database | Amazon RDS | ⚠️ Parziale | PostgreSQL su container |
| Object Storage | Amazon S3 | ✅ Lock-in | MinIO (S3-compatible) |
| Container Runtime | Docker | ❌ Agnostico | — |
| Orchestration | Kubernetes (EKS) | ⚠️ Parziale | K3s, Rancher |
| Monitoring | CloudWatch | ✅ Lock-in | Prometheus + Grafana |
| CI/CD | AWS CodePipeline | ✅ Lock-in | GitHub Actions, GitLab CI |

### Step 4: Definire le API tra Servizi

```
GET    /api/v1/studenti          → Lista tutti gli studenti
GET    /api/v1/studenti/{id}     → Dettaglio studente
POST   /api/v1/studenti          → Crea nuovo studente
PUT    /api/v1/studenti/{id}     → Aggiorna studente
DELETE /api/v1/studenti/{id}     → Elimina studente

GET    /api/v1/studenti/{id}/iscrizioni → Corsi iscritti
```

### Step 5: Pattern di Comunicazione Asincrona

```
StudentiService → pubblica → "studente.iscritto" → Message Bus
                                                         │
                                            ┌────────────┘
                                            │
                                     FatturazioneService
                                     ← ascolta ← "studente.iscritto"
                                     → crea fattura
```

### 🧹 Cleanup (Sostenibilità)
Questo lab è teorico — nessuna risorsa cloud creata. Nessun cleanup necessario. ✅

## ✅ Checkpoint
- [ ] Ho capito la differenza tra Cloud Native e Cloud Agnostic
- [ ] Ho disegnato l'architettura a microservizi del sistema gestionale
- [ ] Ho identificato almeno 3 componenti lock-in e le loro alternative agnostiche
- [ ] Capisco il pattern Event-Driven con message bus

## 📖 Approfondimenti
- [The Twelve-Factor App](https://12factor.net/it/)
- [Martin Fowler: Microservices](https://martinfowler.com/articles/microservices.html)
- [CNCF Landscape](https://landscape.cncf.io/)
- Libro: "Building Microservices" di Sam Newman (O'Reilly)
