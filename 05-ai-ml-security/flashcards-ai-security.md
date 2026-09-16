# Flashcards - AI e AI Security

## Obiettivo
Questo file raccoglie flashcards per i temi più importanti e più spesso richiesti nel test completo. Sono pensate per ripasso rapido, revisione finale e studio attivo.

---

## Flashcard 1
Domanda: Che cosa significa provenance dei dati?
Risposta: La provenance dei dati indica da dove proviene un dato, quando è stato raccolto e se è stato modificato dopo la raccolta. È fondamentale per capire affidabilità, conformità e rischio di dati di addestramento.

## Flashcard 2
Domanda: Qual è il corpus pubblico più usato per addestrare modelli moderni?
Risposta: Common Crawl.

## Flashcard 3
Domanda: Che cosa è un ML-BOM?
Risposta: È l'equivalente AI di un SBOM: un inventario dei dataset, delle licenze, delle categorie di dati sensibili e delle decisioni di filtering applicate.

## Flashcard 4
Domanda: Che cos'è un'epoch?
Risposta: È una passata completa dell'intero dataset durante l'addestramento del modello.

## Flashcard 5
Domanda: Che cos'è l'overfitting?
Risposta: È il fenomeno per cui il modello impara troppo bene i dati di addestramento e perde capacità di generalizzazione.

## Flashcard 6
Domanda: Che cos'è il quantization?
Risposta: È una tecnica di ottimizzazione post-training che riduce la precisione numerica dei pesi del modello per ridurre memoria e costo computazionale.

## Flashcard 7
Domanda: Che cosa è il federated learning?
Risposta: È un approccio in cui il modello viene addestrato su dispositivi decentralizzati, senza trasferire i dati grezzi al server centrale, ma solo i pesi aggiornati.

## Flashcard 8
Domanda: Che cos'è un pre-trained model?
Risposta: È un modello già addestrato su un grande dataset generico, poi utilizzato come base per specializzazioni successive.

## Flashcard 9
Domanda: Che cos'è il fine-tuning?
Risposta: È il processo di continuare l'addestramento di un modello pre-addestrato su un dataset più piccolo e specifico a un compito.

## Flashcard 10
Domanda: Che cos'è un model card?
Risposta: È un documento di accompagnamento che descrive il modello, i dati usati, i limiti, le prestazioni e gli usi previsti.

## Flashcard 11
Domanda: Come si chiamano i numeri che compongono i pesi di un modello?
Risposta: I pesi del modello, spesso rappresentati come miliardi di valori floating-point.

## Flashcard 12
Domanda: Quale rete neurale è ampiamente usata in image e video forensics?
Risposta: La CNN, ovvero Convolutional Neural Network.

## Flashcard 13
Domanda: Che cos'è il sentiment analysis?
Risposta: È l'analisi del tono emotivo o della polarità di un testo, utile su chat e social media.

## Flashcard 14
Domanda: Quali dati vengono spesso correlati per ricostruire una timeline di incidente?
Risposta: Log, filesystem timestamps, firewall logs e application logs.

## Flashcard 15
Domanda: Che cos'è la dynamic analysis di un programma?
Risposta: È l'analisi del comportamento di un programma in esecuzione, ad esempio osservando le API call, per capire se è maligno.

## Flashcard 16
Domanda: Qual è il framework MITRE dedicato alle minacce ai sistemi AI?
Risposta: ATLAS.

## Flashcard 17
Domanda: Che cos'è il prompt injection?
Risposta: È la manipolazione del prompt per sovrascrivere o bypassare le istruzioni originali del modello.

## Flashcard 18
Domanda: Che cos'è il data poisoning?
Risposta: È l'attacco che modifica i dati di training per far produrre al modello output errati o distorti.

## Flashcard 19
Domanda: Che cos'è il model theft?
Risposta: È la clonazione di un modello attraverso query ripetute e osservazione dei risultati, senza averne accesso diretto ai pesi.

## Flashcard 20
Domanda: Che cos'è il model drift?
Risposta: È il degrado delle prestazioni del modello nel tempo quando il contesto o i dati cambiavano.

## Flashcard 21
Domanda: Che cosa sono i deepfake?
Risposta: Sono contenuti sintetici, spesso audio o video, che replicano il volto o la voce di una persona in modo realistico.

## Flashcard 22
Domanda: Perché il phishing AI-enhanced è più pericoloso?
Risposta: Perché l'AI genera email fluenti, personalizzate e molto credibili, rendendo il contenuto più difficile da distinguere da comunicazioni legittime.

## Flashcard 23
Domanda: Quale parametro dell'LLM riduce la casualità e rende il comportamento più vicino al determinismo?
Risposta: Temperature.

## Flashcard 24
Domanda: Che cos'è il top-p?
Risposta: È un parametro che limita la scelta dei token considerati dal modello in base a una massa probabilistica cumulata.

## Flashcard 25
Domanda: Che cos'è la context window?
Risposta: È la massima memoria di contesto di un modello LLM, misurata in token.

## Flashcard 26
Domanda: Quale pilastro del prompt engineering definisce la struttura della risposta?
Risposta: Output format.

## Flashcard 27
Domanda: Quale pilastro del prompt engineering impone regole o limitazioni?
Risposta: Constraints.

## Flashcard 28
Domanda: Quale pilastro del prompt engineering fornisce il contesto necessario?
Risposta: Context.

## Flashcard 29
Domanda: Quale pilastro del prompt engineering definisce l'azione da svolgere?
Risposta: Instruction.

## Flashcard 30
Domanda: Che cos'è il system prompt?
Risposta: È il prompt definito dal developer, persistente e costante tra le sessioni, che impone regole e comportamento dell'applicazione.

## Flashcard 31
Domanda: Che cos'è l'instruction hierarchy?
Risposta: È l'ordine di priorità tra istruzioni di sistema e richieste dell'utente. Le regole di sistema dovrebbero avere priorità.

## Flashcard 32
Domanda: Che cos'è il chain-of-thought prompting?
Risposta: È la tecnica che chiede al modello di scomporre il problema in passaggi intermedi e ragionamenti intermedi.

## Flashcard 33
Domanda: Che cos'è lo zero-shot prompting?
Risposta: È la tecnica che fornisce zero esempi e si basa interamente sulla capacità pre-addestrata del modello.

## Flashcard 34
Domanda: Che cosa sono i prompt templates?
Risposta: Sono strutture standardizzate di prompt riutilizzabili per compiti ricorrenti.

## Flashcard 35
Domanda: Quale frase semplice può attivare il ragionamento step-by-step?
Risposta: "Let's think step by step".

## Flashcard 36
Domanda: Che cos'è il Daubert test?
Risposta: È il test legale statunitense che valuta se una testimonianza scientifica o esperta è ammissibile in tribunale.

## Flashcard 37
Domanda: Che cosa sono i black box models?
Risposta: Sono modelli la cui logica interna è difficile da interpretare o spiegare.

## Flashcard 38
Domanda: Quale tecnologia è stata criticata per bias contro gruppi minoritari?
Risposta: La facial recognition.

## Flashcard 39
Domanda: Che cos'è il federated learning in ambito privacy?
Risposta: È l'approccio che permette di addestrare un modello senza trasferire i dati sensibili al server centrale.

## Flashcard 40
Domanda: Secondo IBM, quanti giorni in più l'AI aiuta a identificare e contenere una violazione?
Risposta: Circa 108 giorni in più rispetto ai team senza AI.

## Flashcard 41
Domanda: Quale prodotto Microsoft è citato come esempio di analisi basata su AI?
Risposta: Microsoft Defender for Endpoint.

## Flashcard 42
Domanda: In che senso l'AI può aiutare nell'investigation?
Risposta: Alimentando un LLM con log grezzi per aiutarlo a spiegare cosa è successo in un incidente e a suggerire query o correlazioni.

## Flashcard 43
Domanda: Quale percentuale di iniziative generative AI è attualmente considerata sicura secondo IBM?
Risposta: Solo il 24%.

## Flashcard 44
Domanda: Quale modello di accesso è consigliato per limitare chi può usare un sistema AI?
Risposta: RBAC (Role-Based Access Control).

## Flashcard 45
Domanda: Quale standard ISO fornisce indicazioni su minacce specifiche ai sistemi AI?
Risposta: ISO/IEC 27090.

## Flashcard 46
Domanda: Perché in DFIR l'AI non può sostituire completamente l'analista umano?
Risposta: Perché richiede verifiche, responsabilità, trasparenza, validazione umana e catena di custodia.

## Flashcard 47
Domanda: Perché la governance dei dati è cruciale nell'AI?
Risposta: Perché i dati di addestramento definiscono la qualità, la legittimità e la sicurezza del modello, oltre a implicazioni di privacy e conformità.

## Flashcard 48
Domanda: Qual è il rischio principale del prompt injection?
Risposta: Il modello può ignorare le regole di sicurezza e rivelare informazioni non autorizzate o compiere azioni non consentite.

## Flashcard 49
Domanda: Come si riduce il rischio di privacy leakage?
Risposta: Minimizzando i dati sensibili, con governance rigorosa, controllo degli accessi, monitoraggio e tecniche di privacy-preserving AI.

## Flashcard 50
Domanda: Qual è il ruolo dell'audit trail e della chain of custody in ambito forense con AI?
Risposta: Garantiscono tracciabilità, integrità e validità procedurale delle evidenze, anche quando sono supportate da strumenti AI.

---

## Flashcards a tema hot

### AI + DFIR
Domanda: In cosa l'AI aiuta il DFIR?
Risposta: Nella correlazione di eventi, nella classificazione di file e email, nel rilevamento di anomalie, nella ricostruzione della timeline e nel supporto alle indagini.

### Prompt Security
Domanda: Perché la gerarchia delle istruzioni è importante?
Risposta: Perché le istruzioni di sistema devono avere priorità sulle richieste dell'utente, per evitare override di regole e leakage di secret.

### AI Security Governance
Domanda: Quali controlli minimizzano il rischio?
Risposta: RBAC, MFA, logging, monitoraggio, validation dei dati, network isolation e revisione umana.

### LLM basics
Domanda: Che cosa sono i token?
Risposta: Sono le unità che un LLM usa per processare il testo. Vengono convertite in ID numerici per il modello.

### Security model lifecycle
Domanda: Perché il monitoring di un modello è anche una funzione di sicurezza?
Risposta: Perché rileva drift, comportamenti anomali e deterioramento delle prestazioni che possono essere indicatori di attacco o di degrado del sistema.

---

## Suggerimento di studio
Per usare bene queste flashcards:
- studia 10 per sessione;
- prova a rispondere prima senza guardare;
- verifica le risposte e poi ripeti;
- concentra l'attenzione sui temi che appaiono più frequentemente nei test e nelle discussioni.
