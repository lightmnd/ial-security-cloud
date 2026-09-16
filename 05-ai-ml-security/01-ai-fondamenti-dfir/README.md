# Lezione 1 - AI, ML, LLM e AI nel DFIR

## Durata: 2 ore

## Obiettivo della lezione
L'obiettivo è introdurre gli studenti ai concetti fondamentali di AI, ML e LLM e collegarli ai problemi reali del DFIR: analisi di evidenze, ricerca di pattern, correlazione di eventi, rilevamento di anomalie e supporto all'investigazione digitale.

---

## 1. Introduzione: perché l'AI è importante in sicurezza
(15 minuti)

L'AI non è solo una tecnologia emergente: è ormai un componente operativo in molte organizzazioni. Nei contesti di sicurezza, l'AI aiuta a:
- analizzare enormi volumi di log e dati;
- rilevare anomalie e comportamenti insoliti;
- classificare file, email, contenuti e segnali;
- supportare la priorizzazione degli incidenti;
- accelerare la ricostruzione di timeline e correlazioni.

In DFIR, il problema principale non è solo la raccolta delle evidenze, ma la loro trasformazione in informazioni utili. Qui l'AI può svolgere un ruolo di supporto, non sostitutivo dell'esperto umano.

### Domande guida
- Come gestiamo dati di forensics in grandi quantità?
- Quali informazioni possono essere automatizzate?
- Dove l'AI accelera il lavoro e dove rischia di diventare poco affidabile?

---

## 2. AI, ML, Deep Learning e LLM
(20 minuti)

### AI
L'AI è l'area generale che studia sistemi capaci di svolgere compiti tipicamente associati all'intelligenza umana, come riconoscimento, classificazione, pianificazione e supporto decisionale.

### Machine Learning
Il Machine Learning costruisce modelli partendo da dati storici per fare previsioni o classificare eventi. Il modello impara schemi dai dati, senza essere programmato con regole esplicite per ogni caso.

### Deep Learning
Il Deep Learning usa reti neurali con molti strati per elaborare dati complessi come immagini, audio, segnali e testo. È particolarmente utile per:
- immagini/video;
- classificazione di malware;
- analisi di testo e linguaggio naturale.

### LLM
Gli LLM (Large Language Models) sono modelli addestrati su grandi quantità di testo e capaci di generare, completare, riassumere e trasformare informazioni linguistiche. Sono utili per:
- riassumere incident report;
- classificare email;
- estrarre pattern da log;
- supportare la triage delle segnalazioni.

### Differenza pratica
- AI = campo generale
- ML = approccio basato su dati
- Deep Learning = reti neurali profonde
- LLM = modelli linguistici su larga scala

---

## 3. Il ciclo di vita di un modello ML
(25 minuti)

Un modello ML nasce da un processo strutturato:
1. Raccolta dati
2. Pulizia e preprocessing
3. Feature engineering
4. Addestramento
5. Validazione
6. Test
7. Deploy
8. Monitoraggio e retraining

### Dati e provenance
Una delle prime questioni critiche e spesso trascurate è: da dove arrivano i dati e chi li ha puliti? Questo è fondamentale in sicurezza, perché lore qualità e origine dei dati definiscono la qualità del modello.

### Problemi comuni
- dati rumorosi o incompleti;
- dati sensibili non adeguatamente gestiti;
- training su dataset distorti;
- modello che apprende regole sbagliate o si adatta troppo al training set.

### Overfitting e validation
- Overfitting: il modello impara troppo bene i dati di addestramento ma non generalizza bene ai dati nuovi.
- Validation set: porzione di dati tenuta fuori dall'addestramento per verificare la generalizzazione.

### Metriche di valutazione
- Accuracy
- Precision
- Recall
- F1-score

### Perché sono importanti in DFIR
In un contesto forense, errori o falsi positivi possono avere conseguenze legali, procedurali ed operative. Una precisione elevata è importante per evitare di seguire piste inutili; un recall elevato è importante per non perdere evidenze rilevanti.

---

## 4. Dati, provenance e responsabilità
(20 minuti)

### Dove provengono i dati?
I dataset usati per addestrare modelli possono derivare da:
- web scraping;
- dataset commerciali;
- dati interni;
- dati sintetici;
- dati di utenti o organizzazioni.

### Problema della provenance
Data provenance significa essere in grado di rispondere a:
- da dove è arrivato il dato?
- quando è stato raccolto?
- è stato modificato dopo la raccolta?

Questo è fondamentale per capire se il set di addestramento è affidabile, legittimo e sicuro.

### ML-BOM
Come un SBOM per il software, l'AI richiede un inventario documentato dei dati, delle licenze, dei filtri applicati e delle categorie di dati sensibili. Questo supporta governance, conformità e responsabilità.

### PII e dati sensibili
I dati dell'AI possono includere:
- informazioni personali;
- email e messaggi privati;
- dati sanitari;
- credential o secret esposte accidentalmente.

In sicurezza AI, non è solo un problema legale: è un problema di rischio reale.

---

## 5. AI nel DFIR: applicazioni pratiche
(25 minuti)

### 1. Pattern recognition e anomaly detection
L'AI può identificare comportamenti anomali:
- login impossibili
- accessi multipli da posizioni diverse
- sequenze di attività associate a incidenti
- comportamento atipico di utenti e applicazioni

### 2. Comunicazioni e testi
I modelli NLP possono:
- classificare email di phishing;
- analizzare chat e social media;
- individuare linguaggio sospetto o comportamenti di minaccia;
- fare sentiment analysis per valutare il tono di messaggi.

### 3. Timeline e correlazione
L'AI aiuta a correlare log, dati di filesystem, firewall e application logs per ricostruire cronologie degli eventi. Questo riduce il carico manuale degli analisti.

### 4. Malware e immagini/video
- CNN per forensics su immagini e video;
- deepfake detection;
- rilevamento di manipolazioni digitali;
- classificazione di file sospetti usando feature automatizzate.

### 5. Supporto alle indagini
L'AI non sostituisce l'analista: fornisce supporto per:
- triage rapido;
- sintesi di evidenze;
- ricerca di pattern non immediatamente visibili;
- ricostruzione di scenari.

---

## 6. Limiti dell'AI in DFIR
(20 minuti)

L'AI ha grandi capacità, ma presenta limiti strutturali:
- non determinismo: lo stesso input può produrre output diversi;
- probabilità invece di regole certe;
- bias e distribuzioni distorte;
- rischio di falsi positivi/falsi negativi;
- problema di explainability e trasparenza.

### Importante
In DFIR, la decisione finale deve sempre essere verificata da un analista umano. AI può accelerare il lavoro, ma non può sostituire il giudizio professionale, la validazione delle evidenze e la catena di custodia.

---

## 7. Esercizi pratici guidati
(25 minuti)

### Esercizio 1 - Classificazione semplice di log
Obiettivo: costruire una mini classificazione di eventi log in base a pattern.

Passi:
1. Preparare un dataset di 10-20 log di esempio.
2. Etichettare come NORMAL, SUSPICIOUS, ATTACK.
3. Usare un semplice modello di classificazione con scikit-learn.
4. Valutare precision, recall e confusion matrix.

Esempio:
```python
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report

texts = [
    'User admin logged in from 192.168.1.10',
    'Failed login attempt for root from 203.0.113.42',
    '5 failed logins for bob in 10 seconds',
    'User guest logged in from 10.0.0.5',
]
labels = ['NORMAL', 'SUSPICIOUS', 'ATTACK', 'NORMAL']

vectorizer = CountVectorizer()
X = vectorizer.fit_transform(texts)
model = LogisticRegression(max_iter=1000)
model.fit(X, labels)

new_text = ['Failed login attempt for admin from foreign IP 198.51.100.7']
print(model.predict(vectorizer.transform(new_text)))
```

### Esercizio 2 - Prompt engineering per riassunto di evidenza
Prompt di esempio:
```text
Riassumi questo evento di sicurezza in 5 righe massime.
Fornisci: 1) descrizione dell'evento, 2) indicatori di compromissione, 3) azioni consigliate.
Non inventare dati.
```

Obiettivo:
- verificare la capacità dell'AI di sintetizzare un caso senza introdurre informazioni arbitrarie;
- discutere il ruolo dell'analista nel validare l'output.

### Esercizio 3 - Confronto tra determinismo e nondeterminismo
1. Chiedere allo stesso prompt di essere risposto due volte con temperatura bassa e poi alta.
2. Osservare come cambiano le risposte.
3. Discutere perché in sicurezza l'output non può essere assunto come affidabile a priori.

---

## 8. Conclusione
L'AI è uno strumento potente per DFIR, ma non è una scorciatoia alla sicurezza o alla competenza professionale. Il suo valore sta nel supportare l'analista, non nel sostituirlo. In un contesto legale e investigativo, la trasparenza, la documentazione, la validazione e la responsabilità umana restano fondamentali.

---

## Checkpoint finale
- [ ] Distinguo AI, ML, Deep Learning e LLM
- [ ] Comprendo il ciclo di vita di un modello ML
- [ ] So quali sono le principali applicazioni dell'AI in DFIR
- [ ] So individuare i limiti dell'AI e la necessità del controllo umano

---

## Glossario
- Model card: documento che descrive un modello, dati di training, limiti e uso previsto
- Overfitting: apprendimento eccessivo del training set
- Validation set: subset usato per valutare generalizzazione
- Provenance: origine e storia di un dato
- Explainability: capacità di spiegare il motivo di una decisione del modello
