# Modulo 05 - AI e AI Security

## Durata
- 2 lezioni da 2 ore
- totale: 4 ore

## Obiettivo del modulo
Questo modulo introduce gli studenti a due dimensioni centrali della sicurezza moderna:

1. l'AI e il machine learning come strumenti per l'analisi, la correlazione e il supporto alle decisioni;
2. la sicurezza dei sistemi AI, con attenzione a dati, modelli, prompt, governance e applicazioni nel campo DFIR.

Il percorso è progettato per studenti con background in cloud, sicurezza, infrastrutture e analisi dei rischi. L'AI viene sempre collegata a:
- IAM e least privilege;
- gestione dei dati sensibili;
- logging, audit e monitoraggio;
- asset isolation e rete;
- governance e responsabilità professionale.

---

## Struttura del modulo

### Lezione 1 - AI, ML, LLM e AI nel DFIR (2 ore)
Focus:
- AI, ML, Deep Learning e LLM
- ciclo di vita del modello
- dati, provenance, overfitting e validation
- pre-trained models, fine-tuning e model card
- applicazioni dell'AI in Digital Forensics e Incident Response
- etica, bias, trasparenza e responsabilità

Materiale:
- [01-ai-fondamenti-dfir/README.md](01-ai-fondamenti-dfir/README.md)

### Lezione 2 - AI Security: minacce, difese e governance (2 ore)
Focus:
- prompt injection e system prompt hijacking
- data poisoning, model theft, privacy leakage, model drift
- AI-enhanced phishing, deepfake e malware generativo
- AI in sicurezza operativa e DFIR
- best practice e governance per modelli e deployment
- RBAC, MFA, monitoraggio, AI RMF, ISO/IEC 27090

Materiale:
- [02-ai-security-threats-governance/README.md](02-ai-security-threats-governance/README.md)

---

## Esercizi pratici previsti
- classificazione di dati e log con supporto AI/ML;
- analisi di prompt e valutazione di possibili override di regole di sicurezza;
- confronto tra comportamenti deterministici e non deterministici;
- esperimenti su prompt injection e prompt engineering;
- esercitazione di triage di email phishing potenzialmente AI-enhanced;
- analisi di un caso DFIR con timeline e correlazione di eventi.

---

## Strumenti e ambienti consigliati
- Python 3.x
- Jupyter Notebook o VS Code
- librerie: scikit-learn, pandas, matplotlib
- ambiente browser per prompt testing (se previsto dal corso)
- strumenti per log e timeline (es. Elasticsearch, SIEM o strumenti open source)

---

## Test finale del modulo
Il test di verifica unificato è disponibile qui:
- [test-ai-security.md](test-ai-security.md)

---

## Risultati attesi
Al termine del modulo gli studenti saranno in grado di:
- distinguere AI, ML, deep learning e LLM;
- comprendere il ciclo di vita di un modello e il ruolo dei dati;
- riconoscere le principali minacce ai sistemi AI;
- spiegare il ruolo dell'AI in DFIR, SOC e security operations;
- applicare principi di governance, sicurezza, privacy e responsabilità professionale in scenari reali.
