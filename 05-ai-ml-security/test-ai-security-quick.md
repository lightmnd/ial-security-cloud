# Test rapido - AI e AI Security

## Istruzioni
Questo test è pensato per verificare rapidamente la comprensione dei contenuti principali dei due README del modulo:
- [01-ai-fondamenti-dfir/README.md](01-ai-fondamenti-dfir/README.md)
- [02-ai-security-threats-governance/README.md](02-ai-security-threats-governance/README.md)

Rispondi in modo sintetico ma corretto.

---

## Sezione 1 - Fondamenti AI e DFIR

### 1. Che differenza c'è tra AI, ML e Deep Learning?
Risposta: ________

### 2. Che cosa rappresenta un LLM?
Risposta: ________

### 3. Qual è il primo passo del ciclo di vita di un modello ML?
Risposta: ________

### 4. Che cosa significa overfitting?
Risposta: ________

### 5. A cosa serve un validation set?
Risposta: ________

### 6. Quali metriche sono importanti per valutare un modello?
Risposta: ________

### 7. Che cosa significa provenance dei dati?
Risposta: ________

### 8. Che cos'è un model card?
Risposta: ________

### 9. In DFIR, quale attività AI aiuta a fare in modo efficace?
Risposta: ________

### 10. Perché l'AI non sostituisce completamente l'analista umano?
Risposta: ________

---

## Sezione 2 - AI Security

### 11. Che cos'è il prompt injection?
Risposta: ________

### 12. Che cos'è il data poisoning?
Risposta: ________

### 13. Qual è la differenza tra system prompt e user prompt?
Risposta: ________

### 14. Che cos'è il model drift?
Risposta: ________

### 15. Quale rischio deriva dal privacy leakage?
Risposta: ________

### 16. Che cosa significa model theft?
Risposta: ________

### 17. Quali sono alcune minacce AI-enhanced che possono coinvolgere attaccanti?
Risposta: ________

### 18. Quale vantaggio offre l'AI in un SOC o in una risposta agli incidenti?
Risposta: ________

### 19. Quali controlli di sicurezza sono essenziali per proteggere un modello AI?
Risposta: ________

### 20. Che ruolo ha la governance AI?
Risposta: ________

---

## Sezione 3 - Esempi pratici

### 21. Qual è l'obiettivo di un prompt di triage per email phishing?
Risposta: ________

### 22. In che modo il monitoring del modello può essere considerato una funzione di sicurezza?
Risposta: ________

### 23. Perché è importante usare RBAC e MFA in un ambiente con AI?
Risposta: ________

### 24. Che cosa può aiutare un LLM in una fase di investigation?
Risposta: ________

### 25. Qual è il rischio principale di usare AI senza documentazione e governance adeguata?
Risposta: ________

---

## Sezione 4 - Domande a risposta multipla

### 26. Quale tra queste affermazioni è corretta?
A. AI e ML sono la stessa cosa
B. AI è il campo generale, ML è una tecnica per apprendere dai dati
C. LLM non è una forma di AI
D. AI non può essere usata in sicurezza
Risposta: ________

### 27. Quale tra queste è una minaccia specifica dell'AI?
A. Firewall block
B. Prompt injection
C. DNS poisoning
D. Port scanning
Risposta: ________

### 28. Quale tra queste è una pratica di sicurezza utile?
A. Lasciare tutti i prompt accessibili a chiunque
B. Usare RBAC e MFA
C. Non monitorare i modelli in produzione
D. Non validare i dati di training
Risposta: ________

### 29. Quale tra questi elementi è utile in DFIR?
A. Timeline reconstruction
B. Nessuna correlazione tra eventi
C. Eliminazione automatica dei log
D. Blocco totale delle evidenze
Risposta: ________

### 30. Quale dei seguenti è un esempio di AI-enhanced attack?
A. Deepfake
B. Backup incrementale
C. VLAN segmentation
D. DNS load balancing
Risposta: ________

---

## Verifica finale
Scrivi in 3 righe la tua idea centrale sul rapporto tra AI e sicurezza:

Risposta: ________________________________

---

## Risposte rapide (solo per docente)
1. AI = campo generale; ML = apprendimento dai dati; DL = reti neurali profonde.
2. LLM = Large Language Model.
3. Raccolta dati.
4. Il modello impara troppo bene il training set e perde generalizzazione.
5. Per verificare la capacità del modello di generalizzare.
6. Accuracy, precision, recall, F1-score.
7. Provenance = origine, data e modifica dei dati.
8. Documento che descrive modello, dati, limiti e uso previsto.
9. Timeline, anomaly detection, comunicazioni, malware, log analysis.
10. Perché richiede supervisione umana, validazione e trasparenza.
11. Manipolazione del prompt per bypassare regole o istruzioni.
12. Manipolazione dei dati di training per distorcere il comportamento del modello.
13. System prompt definisce regole permanenti; user prompt è la richiesta dell’utente.
14. Peggioramento delle prestazioni nel tempo, es. cambiamento del contesto o del traffico.
15. Rivelazione di informazioni sensibili presenti nei dati di addestramento.
16. Clonare o replica il modello tramite query o output.
17. Deepfake, AI-enhanced phishing, malware generativo, social engineering.
18. Analisi di log, threat hunting, triage, riassunti, correlazioni.
19. Autenticazione forte, RBAC, MFA, logging, monitoraggio, network isolation.
20. Garantisce responsabilità, controllo, compliance e sicurezza lungo tutto il ciclo di vita dell’AI.
21. Classificare un messaggio come phishing o meno e identificare segnali sospetti.
22. Perché rileva output anomali, drift e comportamento anomalo del modello in produzione.
23. Per limitare accessi non autorizzati e ridurre il rischio di abuso del modello.
24. Riassumere log, suggerire query, correlare eventi, supportare l’investigazione.
25. Uso non governato dell’AI, con rischio di dati, output e decisioni non verificabili.
26. B.
27. B.
28. B.
29. A.
30. A.
