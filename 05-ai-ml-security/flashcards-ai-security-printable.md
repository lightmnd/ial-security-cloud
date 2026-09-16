# Flashcards AI e AI Security - Versione stampabile

## Istruzioni
- stampa su fogli A4 in orizzontale o verticale;
- taglia le carte lungo le linee;
- usa il lato Q e il lato A separati;
- per ripasso rapido, mescola le carte e prova a rispondere prima di leggere la soluzione.

---

## 01 - Q
Che cosa significa provenance dei dati?

## 01 - A
La provenance dei dati indica da dove proviene un dato, quando è stato raccolto e se è stato modificato dopo la raccolta.

---

## 02 - Q
Qual è il corpus pubblico più usato per addestrare i moderni modelli LLM?

## 02 - A
Common Crawl.

---

## 03 - Q
Che cos'è un ML-BOM?

## 03 - A
Un inventario documentato di dataset, licenze, dati sensibili e decisioni di filtering applicate ai dati di training.

---

## 04 - Q
Che cos'è un'epoch?

## 04 - A
Una passata completa dell'intero dataset durante l'addestramento del modello.

---

## 05 - Q
Che cos'è l'overfitting?

## 05 - A
Il modello impara troppo bene il dataset di training e perde capacità di generalizzazione.

---

## 06 - Q
Che cos'è la quantizzazione?

## 06 - A
Una tecnica che riduce la precisione numerica dei pesi per ridurre memoria e costi computazionali.

---

## 07 - Q
Che cos'è il federated learning?

## 07 - A
Un approccio in cui i dispositivi locali addestrano il modello e inviano solo i pesi aggiornati, non i dati grezzi.

---

## 08 - Q
Che cos'è un pre-trained model?

## 08 - A
Un modello già addestrato su un ampio dataset generale, usato come base per specializzazioni future.

---

## 09 - Q
Che cos'è il fine-tuning?

## 09 - A
Il processo di continuare l'addestramento di un modello pre-addestrato su un dataset più piccolo e specifico.

---

## 10 - Q
Che cos'è un model card?

## 10 - A
Un documento che descrive modello, dati, limiti, metriche e uso previsto.

---

## 11 - Q
Che cosa indica "model drift"?

## 11 - A
Il degrado delle prestazioni nel tempo quando i dati o il contesto cambiano.

---

## 12 - Q
Che cos'è il prompt injection?

## 12 - A
La manipolazione del prompt per sovrascrivere regole o istruzioni del sistema.

---

## 13 - Q
Che cos'è la data poisoning?

## 13 - A
La manipolazione dei dati di training per generare output distorti o scorretto potenzialmente maligni.

---

## 14 - Q
Che cos'è il model theft?

## 14 - A
La clonazione di un modello tramite query ripetute e osservazione delle risposte.

---

## 15 - Q
Che cos'è la privacy leakage?

## 15 - A
La possibilità che un modello riveli informazioni sensibili presenti nei dati di training.

---

## 16 - Q
Che cosa è il system prompt?

## 16 - A
Un prompt definito dal developer, persistente e costante tra le sessioni.

---

## 17 - Q
Che cos'è l'instruction hierarchy?

## 17 - A
L'ordine di priorità tra istruzioni di sistema e richieste dell'utente.

---

## 18 - Q
Che cosa sono i deepfake?

## 18 - A
Contenuti audio o video sintetici che imitano la voce o il volto di una persona reali.

---

## 19 - Q
Che cos'è il phishing AI-enhanced?

## 19 - A
Un phishing generato o reso più potente da modelli AI, con messaggi personalizzati e molto credibili.

---

## 20 - Q
Che cos'è la temperature in un LLM?

## 20 - A
Un parametro che controlla la casualità della generazione del testo; valori bassi rendono il modello più deterministico.

---

## 21 - Q
Che cos'è il top-p?

## 21 - A
Un parametro che limita la scelta dei token considerati in base alla probabilità cumulata.

---

## 22 - Q
Che cos'è la context window?

## 22 - A
La massima quantità di contesto token che un modello può considerare in un'interazione.

---

## 23 - Q
Che cos'è il chain-of-thought prompting?

## 23 - A
Una tecnica che chiede al modello di ragionare in passaggi intermedi prima di rispondere.

---

## 24 - Q
Che cos'è lo zero-shot prompting?

## 24 - A
Una tecnica che usa zero esempi e si appoggia alla conoscenza pre-addestrata del modello.

---

## 25 - Q
A cosa serve il prompt template?

## 25 - A
A standardizzare prompt ricorrenti e riutilizzabili per attività ripetitive.

---

## 26 - Q
Che cos'è il validation set?

## 26 - A
Un sottoinsieme di dati tenuto fuori dall'addestramento per verificare la capacità del modello di generalizzare.

---

## 27 - Q
Perché in DFIR l'AI non sostituisce l'analista umano?

## 27 - A
Perché necessita di validazione, spiegazione, responsabilità ed evidenza forense verificabile.

---

## 28 - Q
Quale modello di controllo accessi è consigliato per sistemi AI?

## 28 - A
RBAC, ovvero Role-Based Access Control, preferibilmente combinato con MFA.

---

## 29 - Q
Quale standard ISO aiuta a gestire minacce AI-specifiche?

## 29 - A
ISO/IEC 27090.

---

## 30 - Q
Che cos'è il sentiment analysis?

## 30 - A
L'analisi del tono emotivo di un testo, utile per chat e social media, soprattutto in DFIR.

---

## 31 - Q
Che cosa si intende per explainability?

## 31 - A
La capacità di capire e spiegare il motivo per cui un modello ha prodotto un certo risultato.

---

## 32 - Q
Che ruolo ha il monitoring del modello in sicurezza?

## 32 - A
Permette di rilevare drift, output anomali e comportamenti sospetti in produzione.

---

## 33 - Q
Che cos'è il Daubert test?

## 33 - A
Il test legale statunitense per verificare se un risultato scientifico o perito è ammissibile in tribunale.

---

## 34 - Q
Che cos'è l'audit trail?

## 34 - A
Una traccia di tutte le azioni e le trasformazioni effettuate su un dato o su un risultato algoritmico.

---

## 35 - Q
Che cosa indica "AI basics"?

## 35 - A
I concetti fondamentali di AI, ML, DL e LLM, oltre ai principi di base del ciclo di vita del modello.

---

## 36 - Q
Che cosa indica "AI security"?

## 36 - A
L'insieme delle minacce specifiche ai modelli e ai sistemi AI, e delle contromisure necessarie per difenderli.

---

## 37 - Q
Che cosa indica "DFIR"?

## 37 - A
Digital Forensics and Incident Response, cioè analisi forense digitale e risposta agli incidenti.

---

## 38 - Q
Che cosa indica "governance" in AI Security?

## 38 - A
Il quadro di responsabilità, policy, audit, controllo degli accessi e documentazione del ciclo di vita dell'AI.

---

## 39 - Q
Perché i dati di training sono critici per la sicurezza?

## 39 - A
Perché influenzano direttamente il comportamento del modello e possono introdurre bias, dati sensibili e output fuorvianti.

---

## 40 - Q
Qual è la differenza tra AI, ML, DL e LLM?

## 40 - A
AI è il campo generale; ML è un metodo basato sui dati; DL usa reti neurali profonde; LLM sono modelli di linguaggio su larga scala.
