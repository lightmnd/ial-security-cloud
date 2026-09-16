# Prompt pronti per aula - varianti di prompting

## Obiettivo
Questa sezione mostra come può variare la struttura di un prompt per ottenere risultati diversi, in base all'obiettivo didattico e alla complessità del compito.

---

## 1. Zero-shot
### Esempio
```text
Classifica questo messaggio come phishing o benigno.
Messaggio: "Urgent update required: verify your account now."
```

### Quando usarlo
- compito semplice;
- modello già abbastanza forte;
- non serve esempio concreto.

### Obiettivo didattico
Mostrare che il modello può rispondere anche senza esempio, basandosi sulla conoscenza pre-addestrata.

---

## 2. One-shot
### Esempio
```text
Esempio:
"Password reset request from support" -> PHISHING

Ora classifica questo messaggio:
"Your account has been suspended, click here to restore access."
```

### Quando usarlo
- serve un esempio di formato;
- serve dare un tono o un pattern di output.

### Obiettivo didattico
Mostrare come un solo esempio aumenti precisione e uniformità della risposta.

---

## 3. Few-shot
### Esempio
```text
Classifica gli eventi di sicurezza come NORMAL, SUSPICIOUS o ATTACK.

- "User admin logged in from 192.168.1.10" -> NORMAL
- "Failed login attempt for root from 203.0.113.42" -> SUSPICIOUS
- "5 failed logins for bob in 10 seconds" -> ATTACK

Ora classifica:
"User guest logged in from 10.0.0.5 at 03:47"
```

### Quando usarlo
- compito con pattern non banali;
- serve guidare il modello su più scenari.

### Obiettivo didattico
Dimostrare che più esempi aiutano a riconoscere regole implicite e casi edge.

---

## 4. Chain-of-thought
### Esempio
```text
Analizza questo evento di sicurezza e spiega il tuo ragionamento passo per passo.
Evento: un utente ha scaricato un file "invoice.pdf.exe" da un'email sospetta.
```

### Quando usarlo
- si richiede ragionamento;
- bisogna spiegare una conclusione;
- il compito è multi-step.

### Obiettivo didattico
Mostrare come l'AI possa scomporre un problema in passaggi logici e arrivare a una conclusione ben motivata.

---

## 5. Prompt template
### Esempio
```text
Valuta questo log per [TIPO_DI_ANALISI].
Contesto: [SCENARIO]
Log: [LOG]
Output richiesto:
1. Eventi rilevati
2. Indicatori di compromissione
3. Rischio stimato
4. Azioni consigliate
```

### Quando usarlo
- attività ricorrenti;
- standardizzazione del lavoro di team;
- sistemi ripetibili.

### Obiettivo didattico
Mostrare come il prompt può essere normalizzato e riutilizzato senza reinventare la struttura ogni volta.

---

## 6. Prompt per il mini-lab finale
### Esempio 1 - PDF
```text
Trasforma il seguente testo in un PDF formale e ben organizzato per un corso di AI Security.
Deve avere titolo, sezioni, domande e risposte, sintesi finale e una sezione con le parole chiave.

Testo:
[incollare qui il test]
```

### Esempio 2 - Flashcards
```text
A partire dal testo seguente, crea flashcards in formato domanda-risposta.
Le flashcards devono essere 20-30, concise, chiare e organizzate per argomento.
Argomenti da enfatizzare: provenance, prompt injection, model drift, privacy leakage, overfitting, governance, AI in DFIR, RBAC, temperature, top-p.

Testo:
[incollare qui il test]
```

### Esempio 3 - Sintesi per studente
```text
Riassumi il testo in un breve documento di studio, massimo 800 parole, con sezioni:
- fondamenti AI
- AI security
- DFIR
- governance
- concetti chiave
```

---

## 7. Come usare queste varianti in aula
1. mostrare un prompt zero-shot e verbalizzare il risultato;
2. aggiungere un esempio e confrontare il risultato con one-shot;
3. mostrare few-shot con tre esempi e discutere la qualità della risposta;
4. provare chain-of-thought su un caso di analisi log;
5. usare prompt template per standardizzare i lavori di gruppo.

---

## 8. Obiettivo delle esercitazioni
Gli studenti devono capire che:
- zero-shot è utile ma meno preciso;
- one-shot impone un formato;
- few-shot aumenta il pattern recognition;
- chain-of-thought aiuta il ragionamento;
- template rende il lavoro ripetibile e più professionale.

---

## 9. Mini riflessione finale
Domanda per la classe:
"In quale situazione conviene usare zero-shot, in quale one-shot, in quale few-shot e in quale template?"

Risposta attesa:
- zero-shot: compiti semplici e ben noti;
- one-shot: format o stile da standardizzare;
- few-shot: pattern complessi o output specifici;
- template: attività ricorrenti e team-based.
