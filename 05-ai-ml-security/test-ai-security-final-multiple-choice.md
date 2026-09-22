# Test finale a risposta multipla - AI e AI Security

## Istruzioni
- Leggi con attenzione ogni domanda.
- Per ciascun item scegli una sola risposta corretta tra A, B, C e D.
- Le domande coprono l'intero modulo: fondamenti di AI/ML/LLM, sicurezza dei modelli, DFIR, prompt engineering e governance.
- Dopo le domande, completa il breve caso pratico finale con una risposta sintetica ma motivata.
- Non sono presenti le soluzioni in questo file.

---

## Sezione 1 - Fondamenti di AI, ML, DL e LLM

### 1. Quale affermazione descrive correttamente il rapporto tra AI, ML e Deep Learning?
A. AI è un sottoinsieme del ML, che a sua volta è un sottoinsieme del Deep Learning.
B. ML e Deep Learning sono sinonimi e non rientrano nell'AI.
C. AI è il campo generale; ML è un approccio basato sui dati; Deep Learning è un sottoinsieme del ML.
D. Deep Learning è una tecnica usata solo in cybersecurity e non in altri domini.

### 2. Che cos'è un LLM?
A. Un modello addestrato solo su log di sicurezza.
B. Un modello di linguaggio addestrato su grandi quantità di testo per comprendere e generare linguaggio.
C. Un sistema di cifratura per proteggere i dataset.
D. Un database ottimizzato per prompt lunghi.

### 3. Quale sequenza rappresenta in modo corretto il ciclo di vita essenziale di un modello ML?
A. Deployment, training, raccolta dati, auditing.
B. Raccolta dati, preprocessing, addestramento, validazione, deployment, monitoraggio.
C. Raccolta dati, backup, cifratura, decommissioning.
D. Prompting, retrieval, tokenizzazione, fine-tuning.

### 4. Qual è il ruolo del training set?
A. Serve solo per l'audit finale del modello.
B. Contiene i dati usati per addestrare il modello.
C. Contiene esclusivamente attacchi reali già confermati.
D. È il sottoinsieme usato solo dopo il deployment.

### 5. A che cosa serve il validation set?
A. A verificare le prestazioni del modello su dati non usati direttamente nell'addestramento.
B. A sostituire completamente il training set.
C. A memorizzare i pesi del modello già addestrato.
D. A rendere impossibile l'overfitting.

### 6. Quale tra queste è una metrica tipica di valutazione di un modello di classificazione?
A. Precision.
B. Throughput di rete.
C. VLAN tagging.
D. TTL.

---

## Sezione 2 - Dati, documentazione e qualità del modello

### 7. Che cosa si intende per provenance dei dati?
A. Il numero di token che un modello può processare.
B. La tracciabilità dell'origine, raccolta e trasformazioni subite dai dati.
C. La velocità di inferenza del modello.
D. Il tipo di GPU usata nell'addestramento.

### 8. Che cos'è un model card?
A. Una chiave hardware per autenticarsi al modello.
B. Un file che contiene solo i pesi del modello.
C. Un documento che descrive modello, dati, prestazioni, limiti e uso previsto.
D. Una tecnica per ridurre il costo computazionale.

### 9. In ambito AI, un ML-BOM è soprattutto:
A. un inventario documentato di componenti, dataset e dipendenze della pipeline AI.
B. un malware che colpisce i modelli generativi.
C. una metrica per valutare l'accuracy.
D. un metodo per aumentare la context window.

### 10. Quale affermazione descrive meglio l'overfitting?
A. Il modello generalizza meglio dopo ogni errore casuale.
B. Il modello si adatta troppo ai dati di training e perde capacità di generalizzazione.
C. Il modello usa pochi dati e quindi non apprende nulla.
D. Il modello riduce la precisione numerica dei pesi.

### 11. Che cos'è la quantizzazione?
A. Una tecnica che riduce la precisione numerica dei pesi per diminuire memoria e costi computazionali.
B. Un processo di labeling manuale dei dati sensibili.
C. Una forma di model theft.
D. Un framework per la chain of custody.

### 12. Quale affermazione sul federated learning è corretta?
A. Centralizza tutti i dati grezzi su un unico server per migliorare la privacy.
B. Addestra modelli solo su dati sintetici.
C. Permette di addestrare il modello su nodi distribuiti condividendo aggiornamenti del modello invece dei dati grezzi.
D. Elimina la necessità di monitoraggio e governance.

---

## Sezione 3 - Modelli pre-addestrati, tuning e affidabilità operativa

### 13. Che cos'è il fine-tuning?
A. L'uso di un firewall davanti a un chatbot.
B. Il riaddestramento o adattamento di un modello pre-addestrato su dati più specifici.
C. La cancellazione dei pesi iniziali del modello.
D. Una tecnica di data poisoning.

### 14. Che cosa indica il model drift?
A. Il degrado delle prestazioni nel tempo quando cambiano dati, ambiente o comportamento degli utenti.
B. La perdita fisica di un server che ospita il modello.
C. La cifratura dei log di inferenza.
D. L'aumento volontario della temperature.

### 15. Perché il monitoraggio di un modello in produzione è importante anche per la sicurezza?
A. Perché sostituisce la revisione umana delle decisioni.
B. Perché aiuta a rilevare drift, output anomali, abusi o segnali di attacco.
C. Perché consente di evitare completamente il logging.
D. Perché impedisce ogni errore di classificazione.

### 16. Quale scenario descrive meglio il rischio di privacy leakage?
A. Il modello restituisce dati sensibili presenti nei dati di training o nel contesto disponibile.
B. Il modello viene spento durante una manutenzione.
C. Il dataset viene compresso prima del training.
D. Il SOC salva i log in un archivio cifrato.

### 17. Quale affermazione descrive correttamente il model theft o model extraction?
A. L'attaccante ruba un laptop del team data science.
B. L'attaccante ricostruisce il comportamento del modello tramite query ripetute e osservazione degli output.
C. L'attaccante disattiva l'MFA dell'account docente.
D. L'attaccante cancella il validation set.

### 18. Quale pratica supporta meglio la privacy-preserving AI?
A. Inviare sempre tutti i dati grezzi a servizi esterni senza filtri.
B. Evitare qualsiasi forma di logging.
C. Applicare minimizzazione dei dati, controllo degli accessi e tecniche che riducono l'esposizione delle informazioni sensibili.
D. Aumentare la temperature per mascherare i dati.

---

## Sezione 4 - AI nel DFIR e nella sicurezza operativa

### 19. In quale attività DFIR l'AI può essere utile in modo coerente con il modulo?
A. Correlazione di log e identificazione di pattern sospetti.
B. Sostituzione automatica del verbale forense firmato.
C. Eliminazione delle evidenze duplicate senza revisione.
D. Emissione autonoma di sanzioni disciplinari.

### 20. Che cos'è la timeline reconstruction?
A. La generazione di un dataset sintetico per addestrare un LLM.
B. La ricostruzione cronologica degli eventi di un incidente a partire da fonti diverse.
C. La sostituzione dei timestamp con identificativi casuali.
D. L'analisi della sola posta elettronica senza log.

### 21. Che cos'è l'anomaly detection?
A. L'identificazione di comportamenti che si discostano da un modello di normalità.
B. La cifratura automatica di tutti i log.
C. La rimozione dei falsi positivi tramite policy HR.
D. Il blocco di qualunque evento raro senza analisi.

### 22. Che cosa si intende per explainability?
A. La capacità di comprimere il modello in meno megabyte.
B. La capacità di comprendere e spiegare perché il modello ha prodotto un certo risultato.
C. L'obbligo di pubblicare i pesi del modello online.
D. La possibilità di usare solo modelli open source.

### 23. Perché la chain of custody è importante quando si usa l'AI in un contesto forense?
A. Per garantire integrità, tracciabilità e validità procedurale delle evidenze.
B. Per aumentare il numero di esempi few-shot.
C. Per evitare di documentare le trasformazioni effettuate.
D. Per rendere l'output del modello legalmente infallibile.

### 24. Quale limite rende necessaria la revisione umana degli output AI in DFIR?
A. Gli output AI possono contenere errori, semplificazioni o interpretazioni non pienamente contestualizzate.
B. I modelli AI non possono processare testo.
C. Gli analisti umani non possono leggere log.
D. Il monitoraggio sostituisce sempre la validazione.

---

## Sezione 5 - Prompt security e minacce ai sistemi AI

### 25. Che cos'è il prompt injection?
A. Una tecnica di ottimizzazione della latenza.
B. Un attacco che prova a manipolare il modello per ignorare o sovrascrivere istruzioni previste.
C. Un metodo di backup dei prompt di sistema.
D. Una pratica di explainability.

### 26. Quale affermazione distingue correttamente system, developer e user prompt?
A. Il system prompt definisce regole generali; il developer prompt specifica comportamenti applicativi; il user prompt contiene la richiesta dell'utente.
B. Tutti e tre hanno sempre lo stesso livello di priorità.
C. Il user prompt ha sempre priorità assoluta sul system prompt.
D. Il developer prompt è usato solo nei dataset di training.

### 27. Che cosa descrive l'instruction hierarchy?
A. L'ordine di priorità tra istruzioni di sistema, di sviluppo e dell'utente.
B. Il numero massimo di livelli di una rete neurale.
C. L'architettura dei backup del SOC.
D. Il processo di anonimizzazione dei dati.

### 28. Che cos'è il data poisoning?
A. La modifica malevola dei dati di addestramento per alterare il comportamento del modello.
B. L'uso di dati cifrati nei backup.
C. La riduzione dei privilegi degli utenti.
D. La classificazione automatica delle email phishing.

### 29. Quale tra questi è un esempio di attacco AI-enhanced?
A. MFA basata su token hardware.
B. Deepfake usato per rendere più credibile una campagna di social engineering.
C. Segmentazione di rete con VLAN.
D. Firma digitale di un documento.

### 30. Quale contromisura riduce meglio il rischio di prompt injection?
A. Trattare input utente e istruzioni di sistema come equivalenti.
B. Separare dati e istruzioni, validare input/output e applicare least privilege.
C. Disattivare ogni forma di logging.
D. Aumentare sempre la context window.

---

## Sezione 6 - Prompt engineering, configurazione e governance

### 31. Che cosa controlla il parametro temperature?
A. La casualità della generazione del testo.
B. Il numero di account abilitati all'MFA.
C. La capacità del validation set.
D. La provenienza dei dati.

### 32. Che cosa controlla il parametro top-p?
A. Il costo mensile del servizio AI.
B. Il numero di prompt contemporanei.
C. La selezione dei token in base a una soglia di probabilità cumulata.
D. L'ordine gerarchico tra system e user prompt.

### 33. Che cos'è la context window?
A. La quantità massima di contesto che il modello può considerare in una singola interazione.
B. Il numero di utenti con ruolo amministrativo.
C. Il tempo di retention dei log.
D. La grandezza del training set minimo richiesto.

### 34. Quale affermazione sul prompting è corretta?
A. Zero-shot usa molti esempi, few-shot nessuno.
B. Few-shot fornisce alcuni esempi per mostrare pattern e formato desiderati.
C. Zero-shot richiede sempre un model card aggiornato.
D. Few-shot serve solo per attività di cifratura.

### 35. Quale controllo di accesso è più coerente con il principio del least privilege in un sistema AI?
A. RBAC.
B. Accesso condiviso con un unico account.
C. Accesso anonimo per semplificare i test.
D. Nessuna autenticazione se il modello è interno.

### 36. Quale abbinamento tra framework o standard e finalità è corretto?
A. AI RMF e ISO/IEC 27090 aiutano a strutturare gestione del rischio e controlli di sicurezza per sistemi AI.
B. AI RMF elimina la necessità di governance aziendale.
C. ISO/IEC 27090 serve solo a misurare la temperature.
D. AI RMF è una metrica di accuratezza per classificatori.

### 37. Quale affermazione sullo zero-shot prompting è corretta?
A. Usa zero esempi e si basa sulle istruzioni e sulla conoscenza pre-addestrata del modello.
B. Richiede sempre almeno cinque esempi completi.
C. Serve solo a testare la latenza del modello.
D. È una tecnica valida solo per dataset numerici.

### 38. Che cosa rende il phishing AI-enhanced particolarmente pericoloso?
A. Il fatto che possa disattivare automaticamente l'MFA del destinatario.
B. La capacità di generare messaggi più credibili, personalizzati e scalabili.
C. L'obbligo di usare soltanto allegati eseguibili.
D. Il fatto che non lasci alcuna traccia nei log.

### 39. Quale controllo riduce meglio il rischio di accessi non autorizzati amministrativi a un sistema AI?
A. Aumentare il numero di prompt few-shot.
B. Usare MFA sugli account con accesso al modello e ai dati sensibili.
C. Condividere un unico account tra tutti gli analisti.
D. Disattivare il logging per proteggere la privacy.

### 40. Perché logging e audit trail sono importanti in un sistema AI?
A. Per ricostruire chi ha fatto cosa, quando e con quali dati o output.
B. Per aumentare automaticamente l'accuracy del modello.
C. Per sostituire del tutto il monitoraggio del modello.
D. Per evitare la necessità di definire ruoli e responsabilità.

---

## Caso pratico finale - Riflessione applicativa

Un SOC utilizza un assistente basato su LLM per analizzare email sospette, log e alert. Il sistema può accedere a dati interni, suggerire priorità agli analisti e proporre azioni di contenimento.

Rispondi in modo sintetico alle richieste seguenti:

1. Indica **tre rischi di sicurezza o privacy** rilevanti nello scenario.
2. Indica **tre controlli tecnici** adatti a ridurre tali rischi.
3. Indica **due controlli organizzativi o di governance**.
4. Spiega **due motivi** per cui la revisione umana resta necessaria.
5. Fornisci **un esempio di prompt injection** plausibile nello scenario.
6. Fornisci **un esempio di problema di provenance dei dati o di privacy leakage**.
