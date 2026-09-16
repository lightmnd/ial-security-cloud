# Programma del corso - AI e AI Security

## Obiettivo didattico
Questo modulo è pensato come percorso integrato di 2 lezioni da 2 ore, con l'obiettivo di far acquisire agli studenti:
- i fondamenti di AI, ML e LLM;
- il ruolo dell'AI nel DFIR e nella sicurezza operativa;
- le vulnerabilità specifiche dei sistemi AI;
- i principi di governance, privacy e controllo di accesso.

---

## Struttura complessiva

### Lezione 1 - AI, ML, LLM e AI nel DFIR
Durata: 120 minuti

### Lezione 2 - AI Security: minacce, difese e governance
Durata: 120 minuti

---

## Lezione 1 - AI, ML, LLM e AI nel DFIR

### Obiettivi
- distinguere AI, ML, deep learning e LLM;
- comprendere il ciclo di vita di un modello;
- analizzare i dati come componente critico della sicurezza;
- capire come l'AI supporta il lavoro in DFIR;
- valutare limiti, bias e trasparenza.

### Agenda oraria

#### 0-15 min: Introduzione e framing
Slide 1 - Perché l'AI è rilevante per la sicurezza
- AI come acceleratore di analisi e automazione
- problemi di grandi volumi di dati e evidenze
- il ruolo di AI in DFIR e SOC

Attività:
- breve discussione su come gli analisti gestiscono grandi dataset
- mappa concettuale: AI vs ML vs DL vs LLM

#### 15-35 min: Fondamenti AI, ML, DL e LLM
Slide 2 - AI, ML, deep learning e LLM
- definizioni
- casi d'uso reali
- differenze di modello e applicazione

Slide 3 - Il ciclo di vita del modello ML
- raccolta dati
- cleaning e preprocessing
- addestramento
- validazione
- deploy
- monitoraggio

#### 35-60 min: Dati, provenance e rischio
Slide 4 - Dati come asset critico
- origine dei dataset
- data provenance
- ML-BOM
- dati sensibili e PII

Discussione:
- da dove vengono i dati usati per addestrare un modello?
- perché il rischio di sicurezza nasce prima ancora della predizione?

#### 60-80 min: Overfitting, validation e metriche
Slide 5 - Qualità dei modelli e valutazione
- epoch
- overfitting
- validation set
- precision, recall, accuracy, F1

Esercizio:
- leggere un caso con dataset squilibrato e discutere metriche

#### 80-100 min: AI nel DFIR
Slide 6 - AI in Digital Forensics e Incident Response
- anomaly detection
- communication analysis
- timeline reconstruction
- malware classification
- deepfake detection

Es. pratico:
- analisi di log e definizione di pattern sospetti

#### 100-115 min: Limiti e responsabilità
Slide 7 - AI non è una scorciatoia alla competenza
- non determinismo
- bias
- explainability
- chain of custody e validità probatoria

#### 115-120 min: Chiusura e check rapido
- 5 domande veloci
- recap dei concetti chiave
- introduzione alla seconda lezione

---

## Lezione 2 - AI Security: minacce, difese e governance

### Obiettivi
- riconoscere le principali minacce ai sistemi AI;
- distinguere attacchi specifici dell'AI da minacce classiche;
- comprendere come si usano gli LLM e l'AI in ambito difensivo;
- applicare principi di governance, controllo d'accesso e privacy.

### Agenda oraria

#### 0-15 min: Ripasso e collegamento con la lezione precedente
Slide 1 - Dalla teoria all'operazione
- dove il modello raccoglie dati e quali rischi comporta
- perché la sicurezza AI è un problema di pipeline e governance

#### 15-45 min: Vettori di attacco AI
Slide 2 - Minacce ai modelli
- prompt injection
- data poisoning
- model theft
- privacy leakage
- model drift

Esercizio:
- analisi di prompt e confronto tra prompt legittimo e prompt maligno

#### 45-70 min: AI-enhanced attacks
Slide 3 - L'AI per gli attacker
- malware generativo
- deepfake
- phishing AI-enhanced
- social engineering automatizzato

Discussione:
- quali segnali umani vengono bypassati in un attacco AI-assisted?

#### 70-95 min: AI in difesa
Slide 4 - AI in SOC e DFIR
- anomaly detection
- log analysis
- phishing triage
- incident summarisation
- threat hunting

Esercizio:
- classifica email e log usando criteri di sicurezza

#### 95-110 min: Sicurezza dei modelli e governance
Slide 5 - Controlli di sicurezza e best practice
- RBAC e MFA
- logging e audit trail
- model monitoring
- secret management
- privacy-preserving AI
- AI RMF e ISO/IEC 27090

#### 110-120 min: Valutazione e chiusura
- mini quiz finale
- riflessione sulle responsabilità professionali
- recap finale

---

## Materiali e risorse consigliate
- documentazione dell'AI security e dei modelli LLM
- report IBM Cost of a Data Breach
- materiali OWASP per LLM e AI security
- standard ISO/IEC 27090 e NIST AI RMF

---

## Output attesi
Gli studenti dovranno essere in grado di:
- descrivere il ciclo di vita di un modello ML;
- identificare i principali rischi dei sistemi AI;
- spiegare in che modo l'AI viene usata in DFIR e sicurezza;
- riconoscere i limiti dell'AI e la necessità del controllo umano;
- applicare pratiche di governance e sicurezza a scenari reali.
