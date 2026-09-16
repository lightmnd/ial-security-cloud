# Lezione 26 - Deep Learning, LLMs e RAG

**Durata:** 60 minuti  
**Obiettivo:** introdurre il concetto di deep learning, la logica delle reti neurali e come i LLM si integrano con applicazioni cloud tramite RAG.

## 1. Obiettivi della lezione (10 min)
- Comprendere il funzionamento di base delle reti neurali
- Capire come i transformer hanno rivoluzionato NLP
- Definire LLM e applicazioni reali
- Integrare conoscenza aziendale con RAG

## 2. Deep Learning e reti neurali (15 min)
Le reti neurali apprendono rappresentazioni di dati attraverso layer connesi da pesi e funzioni di attivazione.

### Componenti principali
- input layer
- hidden layers
- output layer
- weights, bias, gradients
- backpropagation

### Applicazioni tipiche
- classificazione di testo
- riconoscimento immagini
- analisi di log e eventi
- forecasting e anomaly detection

## 3. LLMs: da NLP a foundation models (15 min)
I Large Language Models sono modelli addestrati su grandi quantità di testo e capaci di generare testo, risposte, codice e sintesi.

### Elementi chiave
- tokenizzazione
- embeddings
- attention mechanism
- transformer architecture

### Differenza tra prompt engineering e fine-tuning
- prompt engineering: guida il modello senza modificarne i pesi
- fine-tuning: adattamento del modello su dataset specifici
- RAG: recupera documenti rilevanti e li usa in contesto

## 4. Retriever-Augmented Generation (RAG) (10 min)
RAG combina:
- search/retrieval di documenti rilevanti
- prompt con contesto aggiuntivo
- generazione del modello

### Flusso tipico
1. Ingresso utente
2. Query vector search
3. Recupero documenti rilevanti
4. Costruzione prompt
5. Risposta del modello

### Vantaggi
- riduce allucinazioni sui contenuti interni
- consuma documenti aziendali
- migliora contesto e accuratezza

## 5. Esempio architetturale cloud (5 min)
- S3 per documenti e artefatti
- OpenSearch/Elasticsearch o vector DB
- API LLM esterna o modello self-hosted
- IAM e secret management per credenziali
- audit log per monitorare richieste e output

## 6. Hands-on (5 min)
Esegui un esempio minimale di embedding e retrieval con una lista di documenti.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install sentence-transformers
```

```python
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('all-MiniLM-L6-v2')

texts = [
    'Politica di sicurezza: i dati sensibili devono essere crittografati.',
    'La policy di accesso zero trust riduce i rischi di privilege escalation.',
    'Il backup deve essere replicato in region differenti.'
]

embeddings = model.encode(texts)
print(embeddings.shape)
print('Primo embedding:', embeddings[0][:5])
```

## Checkpoint finale
- [ ] Comprendo reti neurali e deep learning
- [ ] Distinguo prompt engineering, fine-tuning e RAG
- [ ] So cos'è un LLM e come viene usato in cloud
- [ ] Ho eseguito un esempio di embedding

## Risorse utili
- Attention Is All You Need
- Hugging Face course
- LangChain / LlamaIndex overview
