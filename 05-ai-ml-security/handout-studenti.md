# Handout per studenti - AI e AI Security

## 1. Introduzione
L'intelligenza artificiale è ormai parte integrante dei processi di analisi, automazione e supporto decisionale. In campo di sicurezza, AI e ML sono utilizzati per analizzare log, classificare malware, rilevare anomalie, identificare phishing e supportare le indagini digitali. Tuttavia, i sistemi AI introducono anche nuove forme di rischio: dati compromessi, prompt injection, leakage di informazioni riservate, bias e mancanza di trasparenza.

Il loro valore non è nel sostituire il professionista, ma nel potenziare l'analista con scale, velocità e correlazioni non replicabili in modo manuale.

---

## 2. Fondamenti: AI, ML, Deep Learning e LLM

### AI
AI indica il campo che studia sistemi capaci di eseguire attività associate all'intelligenza umana, come classificazione, ragionamento, riconoscimento di pattern e supporto decisionale.

### Machine Learning
Il Machine Learning impara dai dati: costruisce modelli in grado di fare previsioni o classificare eventi a partire da esempi passati.

### Deep Learning
Il Deep Learning usa reti neurali con molteplici livelli per estrarre rappresentazioni complesse da immagini, testo, audio e segnali.

### Large Language Models (LLM)
Gli LLM processano il linguaggio naturale e sono usati per riassumere, classificare, trasformare e generare testo. Sono utili per analisi di email, log, attività sospette e incident report.

---

## 3. Ciclo di vita di un modello
Il modello non nasce “per magia”: nasce da un processo strutturato.

1. Raccolta dati
2. Pulizia e preprocessing
3. Feature engineering
4. Addestramento
5. Validazione
6. Test
7. Deployment
8. Monitoraggio e retraining

### Concetti chiave
- Overfitting: il modello impara troppo bene i dati di addestramento e perde capacità di generalizzazione.
- Validation set: sottoinsieme di dati usato per verificare se il modello generalizza bene.
- Precision: fra le predizioni positive, quante sono corrette?
- Recall: quante istanze positive vengono effettivamente identificate?
- Accuracy: percentuale complessiva di predizioni corrette, ma può essere fuorviante in dataset sbilanciati.

---

## 4. Dati, provenance e sicurezza
L'origine dei dati è una variabile critica della sicurezza AI.

### Data provenance
La provenance dei dati risponde a tre domande:
- da dove provengono i dati?
- quando sono stati raccolti?
- sono stati modificati dopo la raccolta?

### Perché è importante
Se i dati sono contaminati, distorti o provengono da fonti non controllate, il modello eredita quel rischio. In ambienti di sicurezza, ciò può trasformarsi in bias, output fuorvianti e leakage di informazioni sensibili.

### ML-BOM
L'equivalente AI di un SBOM è un inventario documentato di:
- sorgenti dati,
- licenze,
- tipi di PII,
- decisioni di filtering,
- limiti della pipeline di addestramento.

---

## 5. AI nel DFIR
L'AI può supportare il lavoro di digital forensics in molte aree:

### Pattern recognition e anomaly detection
- login anomali
- accessi multipli da posizioni diverse
- comportamenti non standard di utenti e applicazioni

### Communication analysis
- classificazione di phishing
- analisi di chat e social media
- sentiment analysis
- rilevamento di minacce basate su linguaggio

### Timeline reconstruction
L'AI correlates log, file system, firewall, application logs per ricostruire la cronologia degli eventi e ridurre il lavoro manuale.

### Image, video e malware
- CNN per deepfake detection e immagini forensi
- classificazione di file sospetti
- analisi di comportamento del malware

### Vantaggio pratico
L'AI accelera triage, correlazione e sintesi, riducendo il tempo necessario agli analisti per individuare i segnali giusti.

---

## 6. Limiti dell'AI in DFIR
L'AI non sostituisce l'analista. Ha limiti critici:

- non determinismo: lo stesso input può dare output diversi
- probabilità, non regole certe
- bias e distorsioni nei dati
- explainability limitata
- rischio di falsi positivi e falsi negativi
- impossibilità di sostituire il giudizio umano e la validazione forense

In ambito forense e legale, la richiesta di trasparenza e verificabilità è fondamentale.

---

## 7. AI Security: minacce ai modelli

### Prompt Injection
L'input dell'utente cerca di sovrascrivere le istruzioni di sistema o le regole applicative.

### Data Poisoning
I dati di training vengono manipolati per far sviluppare al modello comportamenti distorti.

### Model Theft
Un attaccante replica il modello interrogando l'API o le sue uscite, senza possedere i pesi originali.

### Privacy Leakage
Il modello rivela informazioni sensibili presenti nei dati di training.

### Model Drift
La performance del modello peggiora con il tempo perché l'ambiente o i dati cambiano.

---

## 8. AI-enhanced attacks
L'AI non viene usata solo a difesa: viene anche usata dagli attaccanti.

### Malware generativo
Generazione automatica di codice malevolo o di script persistenti.

### Deepfake
Voce e volto sintetici usati per ingannare utenti e creare ingegneria sociale.

### Phishing AI-enhanced
Email fluide, personalizzate e convincenti, generate in massa con tono realistico.

### Social engineering potenziato
Messaggi di supporto, messaggistica e richieste urgenti preparate con precisione targetizzata.

---

## 9. AI come strumento difensivo
L'AI aiuta anche le organizzazioni a difendersi:

- analisi di log e anomalie;
- triage e classificazione degli alert;
- phishing detection;
- sintesi di incident report;
- supporto alla threat hunting;
- correlazione di eventi e evidenze.

L'AI è quindi un acceleratore della sicurezza operativa, non una sostituzione della competenza umana.

---

## 10. Sicurezza dei modelli e governance
Per utilizzare l'AI in modo sicuro bisogna applicare i principi della sicurezza classica e della governance AI.

### Controlli essenziali
- autenticazione forte
- RBAC
- MFA
- logging e audit trail
- rate limiting
- network isolation
- secret management
- monitoraggio delle performance e del comportamento

### Governance
- documentazione dei dati e del modello
- revisioni periodiche
- policy di accesso
- responsabilità professionale
- valutazione di rischio e compliance

### Standard utili
- ISO/IEC 27090
- NIST AI RMF
- OWASP LLM Top 10

---

## 11. Conclusione
AI e ML hanno un potenziale enorme per la sicurezza, il DFIR e la ricerca di evidenze. Tuttavia, la loro adozione non è innocua: richiede competenze, governance, auditing e supervisione umana. L'obiettivo non è usare AI senza criterio, ma usarla con la stessa rigorosità applicata a qualunque altro sistema critico.

---

## 12. Checklist di sicurezza per l'AI
Prima di deployare un sistema AI, verificare:
- [ ] Chi può accedere al modello?
- [ ] I dati sono eticamente e legalmente legittimi?
- [ ] È presente una documentazione di provenance?
- [ ] I modelli sono monitorati nel tempo?
- [ ] Esiste una procedura di review umano?
- [ ] Le risposte del modello sono tracciabili e verificabili?
- [ ] Ci sono controlli di privacy e minimizzazione dati?
