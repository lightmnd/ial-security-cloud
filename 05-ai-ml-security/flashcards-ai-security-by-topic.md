# Flashcards AI e AI Security - per argomento

## AI basics

### 01 - Q
Che cos'è l'AI?
### 01 - A
È il campo che studia sistemi capaci di svolgere compiti di tipo intelligente, come classificazione, analisi e supporto decisionale.

### 02 - Q
Che differenza c'è tra AI e ML?
### 02 - A
AI è il campo generale; ML è una tecnica per far apprendere ai modelli dai dati.

### 03 - Q
Che cos'è il Deep Learning?
### 03 - A
È un sottoinsieme del ML basato su reti neurali profonde, usate per immagini, testo, audio e segnali.

### 04 - Q
Che cos'è un LLM?
### 04 - A
Un Large Language Model, cioè un modello addestrato su grandi volumi di testo per comprendere e generare linguaggio.

### 05 - Q
Che cos'è l'overfitting?
### 05 - A
Il modello si adatta troppo al training set e perde capacità di generalizzazione.

### 06 - Q
Che cos'è un validation set?
### 06 - A
Un sottoinsieme di dati tenuto fuori dall'addestramento per verificare le prestazioni del modello su dati non visti.

---

## AI security

### 07 - Q
Che cos'è il prompt injection?
### 07 - A
È un attacco che cerca di sovrascrivere le istruzioni originali del modello con input dell'utente.

### 08 - Q
Che cos'è il data poisoning?
### 08 - A
È la manipolazione dei dati di training per far produrre output non affidabili o distorti.

### 09 - Q
Che cos'è il model theft?
### 09 - A
La clonazione di un modello tramite ripetute query e osservazione delle risposte.

### 10 - Q
Che cos'è il privacy leakage?
### 10 - A
La possibilità che un modello riveli informazioni sensibili presenti nei dati di training.

### 11 - Q
Che cos'è il model drift?
### 11 - A
Il peggioramento delle prestazioni nel tempo a causa del cambiamento dell'ambiente o dei dati.

### 12 - Q
Che cos'è il system prompt?
### 12 - A
Il prompt persistente definito dal developer e usato per fissare regole e comportamento del modello.

### 13 - Q
Che cos'è l'instruction hierarchy?
### 13 - A
Il principio secondo cui le istruzioni di sistema devono avere priorità rispetto alle richieste dell'utente.

### 14 - Q
Che cos'è la temperature?
### 14 - A
Un parametro che regola la casualità nella generazione del testo.

### 15 - Q
Che cos'è il top-p?
### 15 - A
Un parametro che limita selezione dei token in base a una probabilità cumulata.

### 16 - Q
Che cos'è il context window?
### 16 - A
La quantità massima di contesto, misurata in token, che il modello può considerare.

---

## DFIR

### 17 - Q
A cosa serve l'AI in DFIR?
### 17 - A
A supportare la rivisitazione di log, la correlazione di eventi, l'analisi di email, le timeline e le anomalie.

### 18 - Q
Che cos'è il sentiment analysis?
### 18 - A
L'analisi del tono emotivo di un testo, utile per chat, social media e strumenti di intelligence.

### 19 - Q
Come l'AI aiuta nella timeline reconstruction?
### 19 - A
Correlando file system timestamps, log, firewall e applicativi per ricostruire gli eventi in ordine cronologico.

### 20 - Q
Che cos'è il deepfake?
### 20 - A
Un contenuto sintetico realistico che imita voce o volto di una persona.

### 21 - Q
Che cos'è l'anomaly detection?
### 21 - A
La rilevazione di comportamenti anomali rispetto a un modello di normalità.

### 22 - Q
Perché l'AI non sostituisce l'analista umano in DFIR?
### 22 - A
Perché le evidenze devono essere validate, spiegate e gestite con responsabilità forense.

---

## Governance

### 23 - Q
Che cosa è la governance AI?
### 23 - A
L'insieme di normative, policy, controlli e responsabilità per gestire il ciclo di vita dell'AI in sicurezza.

### 24 - Q
Perché è importante il monitoring del modello?
### 24 - A
Per rilevare drift, output anomali e problemi di safety in produzione.

### 25 - Q
Che cos'è RBAC?
### 25 - A
Role-Based Access Control, ovvero il controllo degli accessi per ruolo.

### 26 - Q
Perché MFA è importante?
### 26 - A
Per rafforzare l'autenticazione e ridurre il rischio di accesso non autorizzato ai sistemi AI.

### 27 - Q
Che cos'è un model card?
### 27 - A
Una documentazione del modello, dei dati, delle prestazioni e dei limiti.

### 28 - Q
Quale standard ISO è utile per AI security?
### 28 - A
ISO/IEC 27090.

### 29 - Q
Che ruolo ha la provenance dei dati?
### 29 - A
Definisce se i dati sono affidabili, minimizzati e legalmente/eticamente validi.

### 30 - Q
Perché l'audit trail è importante?
### 30 - A
Per documentare trasformazioni e decisioni e garantire tracciabilità e integrità delle evidenze.

---

## Prompt engineering

### 31 - Q
Che cos'è lo zero-shot prompting?
### 31 - A
Un prompt senza esempi e basato sulla conoscenza pre-addestrata del modello.

### 32 - Q
Che cos'è l'one-shot prompting?
### 32 - A
Un prompt con un solo esempio per mostrare il formato o lo stile desiderato.

### 33 - Q
Che cos'è il few-shot prompting?
### 33 - A
Un prompt con più esempi per insegnare pattern e strutture all'AI.

### 34 - Q
Che cos'è il chain-of-thought prompting?
### 34 - A
Una tecnica che porta il modello a mostrare il ragionamento in passaggi intermedi.

### 35 - Q
Che cos'è un prompt template?
### 35 - A
Una struttura standardizzata per compiti ricorrenti.

### 36 - Q
Quale frase può attivare il ragionamento step-by-step?
### 36 - A
"Let's think step by step".

---

## Versione sintetica finale

### 37 - Q
Qual è la chiave di lettura del modulo AI e AI Security?
### 37 - A
L'AI accelera il lavoro, ma i dati, il modello, la governance e il controllo umano sono i veri fattori di sicurezza.
