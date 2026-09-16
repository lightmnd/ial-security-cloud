# Rubriche di valutazione e risposte guida

## 1. Obiettivo della valutazione
La valutazione del modulo verifica se lo studente è in grado di:
- distinguere i concetti fondamentali di AI, ML, DL e LLM;
- applicare i principi dell'AI Security;
- riconoscere minacce specifiche dell'AI;
- valutare il ruolo dell'AI in DFIR e in sicurezza operativa;
- discutere governance, privacy, trasparenza e responsabilità professionale.

---

## 2. Rubrica di valutazione

### Livello 1 - Base
Lo studente comprende i concetti essenziali ma li presenta in modo superficiale.

Criteri:
- identifica AI e ML in modo generico;
- riconosce alcuni rischi di sicurezza AI;
- dimostra poca capacità di collegare teoria e applicazioni pratiche;
- usa un lessico impreciso.

Valutazione indicativa: 1/5 a 2/5

### Livello 2 - Sufficientemente corretto
Lo studente comprende i temi principali ed è in grado di esprimere definizioni essenziali.

Criteri:
- distingue correttamente AI, ML e LLM;
- riconosce le minacce principali;
- spiega il ruolo dell'AI in DFIR in modo adeguato;
- comprende il legame tra dati, sicurezza e governance.

Valutazione indicativa: 3/5

### Livello 3 - Buono
Lo studente mostra comprensione solida e capacità di applicazione.

Criteri:
- spiega correttamente ciclo di vita del modello, overfitting, provenance, prompt injection e model drift;
- collega l'AI alle sfide concrete del DFIR;
- usa un lessico tecnico corretto;
- propone contromisure adeguate e riflette su governance e responsabilità.

Valutazione indicativa: 4/5

### Livello 4 - Eccellente
Lo studente mostra padronanza critica e capacità di sintesi professionale.

Criteri:
- analizza le criticità dell'AI in modo completo e articolato;
- distingue tra opportunità difensive e strumenti a rischio;
- discute privacy, bias, explainability e chain of custody;
- propone soluzioni realistiche e ben motivate.

Valutazione indicativa: 5/5

---

## 3. Esempi di esercizi valutativi

### Esercizio A - Definizione di concetti
Chiedere di definire in 2-3 righe:
- AI
- Machine Learning
- LLM
- Overfitting
- Prompt Injection
- Model Drift

### Esercizio B - Analisi di caso
Un'organizzazione usa un modello AI per analizzare email interne e scarti; il modello esegue analisi automatica. Quali rischi ci sono in termini di:
- dati sensibili;
- prompt injection;
- governance;
- responsabilità umana?

### Esercizio C - Rilevamento di minacce
Dato un log e una richiesta di triage automatica, chiedere di individuare:
- pattern sospetti;
- indicatori di compromissione;
- eventuali limiti dell'AI nella conclusione finale.

### Esercizio D - Esposizione orale
Ogni studente spiega:
- come un modello AI può aiutare in DFIR;
- perché non può sostituire un analista umano;
- quali controlli di sicurezza devono essere adottati.

---

## 4. Risposte guida

### Domanda 1
Quale termine descrive la capacità di rispondere a: da dove proviene un dato, quando è stato raccolto e se è stato modificato?

Risposta guida: provenance.

### Domanda 2
Qual è il nome del corpus pubblico più usato che supporta gran parte dei principali modelli moderni?

Risposta guida: Common Crawl.

### Domanda 3
Qual è l'equivalente AI di un Software Bill of Materials (SBOM)?

Risposta guida: ML-BOM.

### Domanda 4
Che cosa descrive un'epoch?

Risposta guida: una completa passata dell'intero dataset durante l'addestramento.

### Domanda 5
Quale problema si verifica quando un modello memorizza i dati di training invece di apprendere pattern generali?

Risposta guida: overfitting.

### Domanda 6
Quale tecnica di ottimizzazione post-training riduce la precisione numerica dei pesi del modello per ridurre memoria e costi computazionali?

Risposta guida: quantizzazione.

### Domanda 7
Quale approccio di training addestra un modello su dispositivi decentralizzati con condivisione solo dei pesi, non dei dati grezzi?

Risposta guida: federated learning.

### Domanda 8
Che cosa è un pre-trained model?

Risposta guida: un modello già addestrato su un grande dataset generico e pronto per essere specializzato.

### Domanda 9
Qual è il processo di continuare l'addestramento di un modello pre-addestrato su un dataset più piccolo e specifico a un compito?

Risposta guida: fine-tuning.

### Domanda 10
Quale artefatto documentale accompagna un modello per descrivere funzionamento, dati, limiti e uso previsto?

Risposta guida: model card.

### Domanda 11
Come si chiamano collettivamente i miliardi di numeri che costituiscono un modello addestrato?

Risposta guida: pesi del modello.

### Domanda 12
Che tipo di rete neurale viene usata spesso in image e video forensics per imparare pattern spaziali?

Risposta guida: CNN (Convolutional Neural Network).

### Domanda 13
Quale tipo di analisi su chat e social media valuta il tono emotivo dei messaggi?

Risposta guida: sentiment analysis.

### Domanda 14
Quali dati vengono correlati per ricostruire automaticamente la timeline di un incidente?

Risposta guida: log, filesystem timestamps, firewall e application logs.

### Domanda 15
Quale tipo di analisi osserva il comportamento di un programma per capire se è maligno, ad esempio studiando le API call?

Risposta guida: dynamic analysis.

### Domanda 16
Quale framework MITRE è stato creato per mappare tattiche e tecniche usate contro sistemi AI?

Risposta guida: ATLAS.

### Domanda 17
Quale vulnerabilità si verifica quando un input dell'utente sovrascrive le istruzioni originali del modello?

Risposta guida: prompt injection.

### Domanda 18
Quale attacco manipola i dati di training per causare output errati o distorti?

Risposta guida: data poisoning.

### Domanda 19
Quale attacco interroga ripetutamente un'API di un modello per costruire un clone del suo comportamento?

Risposta guida: model theft / model extraction.

### Domanda 20
Quale termine descrive il degrado graduale delle prestazioni di un modello quando l'ambiente cambia nel tempo?

Risposta guida: model drift.

### Domanda 21
Quale tecnica usata per generare repliche convincenti della voce o dell'aspetto di una persona?

Risposta guida: deepfake generation.

### Domanda 22
Quale metodo iniziale di accesso è diventato più difficile da rilevare grazie alla capacità dell'AI di generare contenuti fluido e mirati a scala?

Risposta guida: phishing.

### Domanda 23
Quale parametro di un modello LLM si usa per ridurre la casualità e avvicinarsi al comportamento deterministico?

Risposta guida: temperature.

### Domanda 24
Quale parametro limita la scelta dei token considerati dal modello in base a una massa probabilistica cumulata?

Risposta guida: top-p.

### Domanda 25
Qual è il termine per la massima memoria di contesto di un LLM, misurata in token?

Risposta guida: context window.

### Domanda 26
Quale pilastro del prompt engineering descrive la struttura desiderata della risposta, come bullet list o JSON?

Risposta guida: output format.

### Domanda 27
Quale pilastro del prompt engineering stabilisce regole o limiti come tono, argomenti proibiti o vincoli formali?

Risposta guida: constraints.

### Domanda 28
Quale pilastro del prompt engineering fornisce il contesto necessario per far capire la situazione al modello?

Risposta guida: context.

### Domanda 29
Quale pilastro del prompt engineering indica l'azione da svolgere, ad esempio "riassumi", "analizza" o "classifica"?

Risposta guida: instruction.

### Domanda 30
Quale tipo di prompt è definito dal developer, persistente e costante tra tutte le sessioni?

Risposta guida: system prompt.

### Domanda 31
Come si chiama l'ordine di priorità tra istruzioni di sistema e richieste dell'utente?

Risposta guida: instruction hierarchy.

### Domanda 32
Quale tecnica di prompting introdotta da Google nel 2022 richiede al modello di scomporre il compito in passaggi intermedi?

Risposta guida: chain-of-thought prompting.

### Domanda 33
Quale tecnica di prompting usa zero esempi e si basa unicamente sulla conoscenza pre-addestrata del modello?

Risposta guida: zero-shot prompting.

### Domanda 34
Quale tecnica di prompting riutilizza una struttura standardizzata per compiti ricorrenti?

Risposta guida: prompt templates.

### Domanda 35
Quale semplice frase può essere usata per attivare una reasoning step-by-step senza esempi?

Risposta guida: "Let's think step by step".

### Domanda 36
Quale test legale statunitense valuta se una testimonianza scientifica o esperta è ammissibile in tribunale?

Risposta guida: Daubert test.

### Domanda 37
Come si definiscono i modelli AI la cui logica interna è difficile da interpretare?

Risposta guida: black box models.

### Domanda 38
Quale tecnologia impiegata dalle forze dell'ordine è stata dimostrata biasata contro gruppi minoritari nell'identificazione di sospetti?

Risposta guida: facial recognition.

### Domanda 39
Quale tecnica consente di addestrare un modello senza trasferire dati sensibili a un server centrale?

Risposta guida: federated learning.

### Domanda 40
Secondo IBM, quanti giorni in media l'AI aiuta a identificare e contenere una violazione rispetto ai team senza AI?

Risposta guida: 108 giorni.

### Domanda 41
Quale prodotto Microsoft è citato come esempio di analisi basata su AI?

Risposta guida: Microsoft Defender for Endpoint.

### Domanda 42
Quale capacità difensiva dell'AI consiste nell'alimentare un LLM con log grezzi per capire cosa è successo in un incidente?

Risposta guida: investigation / log analysis support.

### Domanda 43
Quale percentuale di iniziative generative AI è attualmente considerata sicura, secondo IBM?

Risposta guida: 24%.

### Domanda 44
Quale modello di access control è consigliato per limitare chi può interagire con un sistema AI?

Risposta guida: RBAC (Role-Based Access Control).

### Domanda 45
Quale standard ISO fornisce indicazioni per identificare e mitigare minacce specifiche ai sistemi AI?

Risposta guida: ISO/IEC 27090.

---

## 5. Criterio finale di valutazione
Valutazione finale consigliata:
- 40% conoscenza teorica
- 30% capacità di applicazione pratica
- 20% qualità della discussione e del ragionamento
- 10% uso corretto del lessico tecnico e della documentazione

---

## 6. Suggerimento didattico
Per ottenere il massimo valore dal modulo, utilizzare il materiale in questo ordine:
1. programma del corso;
2. handout per studenti;
3. esercitazioni guidate;
4. test finale;
5. discussione delle risposte con rubriche di valutazione.
