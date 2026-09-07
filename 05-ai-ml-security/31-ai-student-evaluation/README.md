# Valutazione Finale - Modulo AI, ML, LLMs e AI Security

**Durata:** 30-45 minuti  
**Formato:** quiz + mini caso pratico + riflessione

## Obiettivo
Verificare se gli studenti hanno acquisito i concetti chiave del modulo, con particolare attenzione a:
- AI/ML foundations
- LLM e RAG
- AI Security
- governance e sicurezza dati

## Sezione A - Quiz conoscitivo (10-15 min)

### Domande a risposta multipla

1. Qual è la differenza principale tra AI e Machine Learning?
   - A. AI è un sottoinsieme di ML
   - B. ML è una branca dell’AI che impara da dati
   - C. Non ci sono differenze
   - D. AI riguarda solo software, ML solo hardware

2. Quale tra questi è un classico rischio AI Security?
   - A. Password troppo corta
   - B. Prompt injection
   - C. Firewall non configurato
   - D. CPU sottodimensionata

3. Cosa rappresenta RAG?
   - A. Redundant Access Gateway
   - B. Retrieval-Augmented Generation
   - C. Risk Assessment Group
   - D. Remote Access Gateway

4. Qual è il vantaggio principale di RAG?
   - A. Riduce il costo del cloud
   - B. Aggiunge contesto aziendale al modello
   - C. Aggiunge automaticamente sicurezza firewall
   - D. Sostituisce il database

5. Quale pratica è corretta per proteggere dati sensibili in un sistema AI?
   - A. Loggare tutte le richieste senza filtri
   - B. Usare IAM minimizzato e cifratura
   - C. Consentire accesso pubblico a tutti i documenti
   - D. Non salvare log di accesso

6. Cosa misura la validazione di un modello?
   - A. La velocità del computer
   - B. La qualità delle previsioni su dati non visti
   - C. Il numero di utenti totali
   - D. Lo spazio di storage disponibile

7. Quale pratica riduce il rischio di leakage di dati?
   - A. Loggare tutti i prompt e le risposte in chiaro
   - B. Applicare data minimization e access control
   - C. Abilitare tutte le API pubbliche
   - D. Ignorare i controlli di accesso

8. Perché il monitoring è importante in AI production?
   - A. Per evitare errori di sintassi
   - B. Per rilevare drift, errori e comportamenti anomali
   - C. Per proteggere il server da attacchi DDoS
   - D. Per aumentare il numero di token

## Sezione B - Caso pratico (15 min)
### Scenario
Un’azienda usa un assistente AI per rispondere alle domande dei dipendenti su policy interne, documenti HR e procedure di sicurezza.

### Problemi da analizzare
- I documenti sono salvati in un bucket S3
- Il modello riceve eventuali documenti senza controllo di accesso
- Le chat sono archiviate in log senza filtraggio
- L’assistente può essere interrogato con prompt decisamente aggressivi

### Domande
1. Quali rischi emergono?
2. Quali controlli dovresti implementare subito?
3. Come useresti IAM, log e governance per ridurre il rischio?
4. Come cambierebbe il design se il sistema usasse un LLM esterno?

### Risposta attesa (sintesi)
- applicare IAM minimizzato
- cifrare i documenti
- restringere accessi al bucket
- filtrare prompt e output sensibili
- memorizzare solo logs sanitizzati
- usare audit trail e review umano per casi critici

## Sezione C - Mini riflessione finale (10 min)
### Domande aperte
1. Dove pensi che l’AI possa creare maggior valore in un contesto cloud moderno?
2. Qual è il rischio più sottovalutato in un progetto AI?
3. In che modo la sicurezza deve essere considerata fin dal design, non come fase finale?

## Griglia di valutazione
| Area | Punti | Criteri |
|---|---:|---|
| Concetti base AI/ML | 25 | Comprensione di AI, ML, DL, LLM, RAG |
| AI Security | 30 | Riconoscimento di minacce e best practice |
| Governance e dati | 25 | Privacy, IAM, logging, minimizzazione |
| Caso pratico | 20 | Capacità di analizzare un sistema reale |

## Criterio di superamento
- 60/100: sufficiente
- 75/100: buono
- 85/100: ottimo
- 90+/100: eccellente

## Debrief docente
Valutare se lo studente:
- distingue correttamente concetti di AI e ML
- riesce a collegare sicurezza e cloud
- sa identificare rischi di AI Security
- sa proporre contro-misure pratiche e governative
