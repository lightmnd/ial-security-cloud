# Test finale a risposta multipla - AI e AI Security

## Istruzioni

Scegli una sola risposta corretta tra A, B, C e D. Il test copre fondamenti AI/ML/LLM, sicurezza dei modelli, DFIR, prompt engineering e governance. Completa anche il caso pratico finale. Le soluzioni non sono incluse in questo file.

## Sezione 1 - Fondamenti e ciclo di vita

### 1. Quale rapporto descrive correttamente AI, ML e Deep Learning?
A. AI è il campo generale; ML è basato sui dati; Deep Learning è un sottoinsieme del ML.
B. AI è un sottoinsieme del ML.
C. ML e Deep Learning sono sinonimi.
D. Deep Learning riguarda solo la cybersecurity.

### 2. Che cos'è un LLM?
A. Un database di log.
B. Un modello di linguaggio addestrato su grandi quantità di testo.
C. Un sistema di cifratura.
D. Un firewall per chatbot.

### 3. Qual è una sequenza corretta del ciclo di vita ML?
A. Deployment, training, raccolta dati.
B. Raccolta dati, preprocessing, training, validazione, deployment, monitoraggio.
C. Prompting, backup, cifratura.
D. Audit, decommissioning, training.

### 4. A cosa serve il training set?
A. Ad addestrare il modello.
B. Solo all'audit finale.
C. Solo al monitoraggio.
D. A sostituire il model card.

### 5. A cosa serve il validation set?
A. A verificare le prestazioni su dati non usati direttamente per l'addestramento.
B. A memorizzare i pesi.
C. A eliminare ogni rischio di overfitting.
D. A cifrare il dataset.

### 6. Quale è una metrica di classificazione?
A. Precision.
B. VLAN tagging.
C. TTL.
D. Throughput di rete.

### 7. Che cos'è la provenance dei dati?
A. La velocità di inferenza.
B. La tracciabilità di origine, raccolta e trasformazioni dei dati.
C. La dimensione della context window.
D. Il tipo di GPU.

### 8. Che cos'è un model card?
A. Un documento su modello, dati, prestazioni, limiti e uso previsto.
B. Un file contenente solo i pesi.
C. Una chiave hardware.
D. Una tecnica di quantizzazione.

### 9. Che cos'è un ML-BOM?
A. Un inventario di componenti, dataset e dipendenze della pipeline AI.
B. Un malware per LLM.
C. Una metrica di accuracy.
D. Un metodo di prompting.

### 10. Che cos'è l'overfitting?
A. Il modello generalizza sempre meglio.
B. Il modello si adatta troppo al training set e generalizza male.
C. Il modello non riceve dati.
D. Il modello riduce la precisione dei pesi.

## Sezione 2 - Modelli, dati e affidabilità

### 11. Che cos'è la quantizzazione?
A. Riduce la precisione numerica dei pesi per diminuire memoria e costi.
B. È un attacco al training set.
C. È un audit forense.
D. È una forma di RBAC.

### 12. Che cos'è il federated learning?
A. Centralizza tutti i dati grezzi.
B. Usa solo dati sintetici.
C. Addestra su nodi distribuiti condividendo aggiornamenti, non dati grezzi.
D. Elimina il monitoraggio.

### 13. Che cos'è il fine-tuning?
A. Un firewall per chatbot.
B. L'adattamento di un modello pre-addestrato a dati più specifici.
C. La cancellazione dei pesi.
D. Un attacco di poisoning.

### 14. Che cosa indica il model drift?
A. Il degrado delle prestazioni quando cambiano dati o ambiente.
B. La perdita fisica di un server.
C. La cifratura dei log.
D. L'aumento della temperature.

### 15. Perché monitorare un modello in produzione?
A. Per sostituire l'analista.
B. Per rilevare drift, output anomali, abusi e possibili attacchi.
C. Per evitare il logging.
D. Per impedire ogni errore.

### 16. Che cos'è il privacy leakage?
A. La restituzione non autorizzata di dati sensibili presenti nel training o nel contesto.
B. Lo spegnimento del modello.
C. La compressione del dataset.
D. Il salvataggio cifrato dei log.

### 17. Che cos'è il model theft o extraction?
A. Il furto di un laptop.
B. La ricostruzione del comportamento tramite query e osservazione degli output.
C. La disattivazione dell'MFA.
D. La cancellazione del validation set.

### 18. Quale pratica supporta la privacy-preserving AI?
A. Inviare tutti i dati grezzi a servizi esterni.
B. Evitare ogni logging.
C. Minimizzare i dati e applicare controllo degli accessi.
D. Aumentare la temperature.

## Sezione 3 - AI nel DFIR

### 19. In quale attività DFIR può aiutare l'AI?
A. Correlazione di log e identificazione di pattern sospetti.
B. Firma automatica del verbale forense.
C. Eliminazione non revisionata delle evidenze.
D. Emissione autonoma di sanzioni.

### 20. Che cos'è la timeline reconstruction?
A. La generazione di dati sintetici.
B. La ricostruzione cronologica degli eventi da fonti diverse.
C. La sostituzione dei timestamp.
D. L'analisi della sola posta elettronica.

### 21. Che cos'è l'anomaly detection?
A. L'identificazione di comportamenti che si discostano dalla normalità.
B. La cifratura dei log.
C. La rimozione amministrativa dei falsi positivi.
D. Il blocco di ogni evento raro.

### 22. Che cosa significa explainability?
A. Comprimere il modello.
B. Comprendere e spiegare perché il modello ha prodotto un risultato.
C. Pubblicare i pesi.
D. Usare solo modelli open source.

### 23. Perché è importante la chain of custody?
A. Per garantire integrità, tracciabilità e validità delle evidenze.
B. Per aumentare gli esempi few-shot.
C. Per evitare la documentazione.
D. Per rendere l'AI infallibile.

### 24. Perché serve la revisione umana in DFIR?
A. Gli output possono contenere errori o interpretazioni non contestualizzate.
B. I modelli non elaborano testo.
C. Gli analisti non leggono log.
D. Il monitoraggio sostituisce la validazione.

## Sezione 4 - Minacce AI e prompt security

### 25. Che cos'è il prompt injection?
A. Un'ottimizzazione della latenza.
B. Un attacco che manipola o sovrascrive le istruzioni previste.
C. Un backup del system prompt.
D. Una tecnica di explainability.

### 26. Quale distinzione tra prompt è corretta?
A. System definisce regole, developer il comportamento applicativo, user la richiesta dell'utente.
B. Hanno sempre la stessa priorità.
C. User ha sempre priorità assoluta.
D. Developer prompt è usato solo nel training.

### 27. Che cos'è l'instruction hierarchy?
A. L'ordine di priorità tra istruzioni di sistema, sviluppo e utente.
B. Il numero di livelli della rete.
C. L'architettura dei backup.
D. Un processo di anonimizzazione.

### 28. Che cos'è il data poisoning?
A. La modifica malevola dei dati di training.
B. L'uso di backup cifrati.
C. La riduzione dei privilegi.
D. Il triage delle email.

### 29. Quale è un attacco AI-enhanced?
A. MFA hardware.
B. Deepfake usato nel social engineering.
C. VLAN.
D. Firma digitale.

### 30. Quale contromisura riduce il prompt injection?
A. Trattare input e istruzioni come equivalenti.
B. Separare dati e istruzioni, validare input/output e applicare least privilege.
C. Disattivare il logging.
D. Aumentare sempre la context window.

## Sezione 5 - Prompt engineering e governance

### 31. Che cosa controlla la temperature?
A. La casualità della generazione.
B. Il numero di account MFA.
C. Il validation set.
D. La provenance.

### 32. Che cosa controlla il top-p?
A. Il costo del servizio.
B. Il numero di prompt.
C. La selezione dei token in base alla probabilità cumulata.
D. La gerarchia delle istruzioni.

### 33. Che cos'è la context window?
A. La quantità massima di contesto considerabile dal modello.
B. Il numero di amministratori.
C. La retention dei log.
D. La dimensione minima del training set.

### 34. Quale affermazione è corretta?
A. Zero-shot usa molti esempi.
B. Few-shot fornisce alcuni esempi per mostrare pattern e formato.
C. Zero-shot richiede sempre un model card.
D. Few-shot serve solo alla cifratura.

### 35. Quale controllo applica meglio il least privilege?
A. RBAC.
B. Account condiviso.
C. Accesso anonimo.
D. Nessuna autenticazione.

### 36. Quale abbinamento è corretto?
A. AI RMF e ISO/IEC 27090 aiutano a strutturare gestione del rischio e sicurezza AI.
B. AI RMF elimina la governance.
C. ISO/IEC 27090 misura la temperature.
D. AI RMF è una metrica di accuracy.

### 37. Che cos'è lo zero-shot prompting?
A. Un prompt senza esempi, basato su istruzioni e conoscenza pre-addestrata.
B. Un prompt con almeno cinque esempi.
C. Un test di latenza.
D. Una tecnica solo numerica.

### 38. Perché il phishing AI-enhanced è pericoloso?
A. Disattiva automaticamente l'MFA.
B. Genera messaggi credibili, personalizzati e scalabili.
C. Richiede sempre allegati eseguibili.
D. Non lascia tracce nei log.

### 39. Quale controllo riduce gli accessi amministrativi non autorizzati?
A. Più esempi few-shot.
B. MFA sugli account con accesso a modello e dati sensibili.
C. Account condiviso.
D. Disattivazione del logging.

### 40. Perché logging e audit trail sono importanti?
A. Ricostruiscono chi ha fatto cosa, quando e con quali dati o output.
B. Aumentano automaticamente l'accuracy.
C. Sostituiscono il monitoraggio.
D. Eliminano ruoli e responsabilità.

## Caso pratico finale

Un SOC usa un LLM per analizzare email, log e alert, con accesso a dati interni e possibilità di suggerire azioni di contenimento. Indica tre rischi, tre controlli tecnici, due controlli organizzativi, due motivi per la revisione umana, un esempio di prompt injection e un problema di provenance o privacy leakage.
