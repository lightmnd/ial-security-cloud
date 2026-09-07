# Lezione 28 - AI Security: Dati Sensibili e Privacy

**Durata:** 60 minuti  
**Obiettivo:** affrontare la gestione dei dati sensibili negli AI system, il rischio di leak, la privacy e le tecniche per minimizzare la superficie di esposizione.

## 1. Obiettivi della lezione (10 min)
- Identificare dati sensibili in flussi AI
- Capire perché AI aumenta il rischio di leakage
- Applicare principi di minimizzazione e protezione dei dati
- Conoscere regole di accesso e logging sicuri

## 2. Dati sensibili in AI (10 min)
I sistemi AI spesso elaborano:
- documenti aziendali riservati
- dati personali
- log di accessi e autorizzazioni
- conversazioni utente
- immagini e file multimediali

Se non protetti, possono essere recuperati o estratti accidentalmente dal modello o dai log.

## 3. Rischi principali di leakage (20 min)
### Leakage di prompt e risposte
Il modello può riportare informazioni sensibili presenti nel contesto o nelle query.

### Memorization
Modelli addestrati su dataset contenenti dati personali possono riemetterli in output.

### Cross-context contamination
Documenti o chat provenienti da altri utenti possono contaminare la risposta se il contesto non è separato correttamente.

## 4. Best practice per i dati (10 min)
- classificare i dati in base a sensibilità
- usare cifratura a riposo e in transito
- limitare l'accesso tramite IAM e RBAC
- separare dataset di sviluppo e produzione
- mantenere audit trail completo delle chiamate

## 5. Privacy by design per AI (5 min)
- minimizzazione dei dati raccolti
- anonimizzazione dove possibile
- policy di retention e scadenza
- pseudonimizzazione per contesti di test
- revisione dei dataset prima dell'addestramento

## 6. Hands-on (5 min)
Esempio di classificazione semplificata dei dati sensibili in un dataset di messaggi.

```python
SENSITIVE_KEYWORDS = ['cf', 'iban', 'password', 'token', 'ssn']

messages = [
    'Il token di accesso è scaduto.',
    'Ho aggiornato il report di vendita.',
    'Il cliente ha riportato un problema con lIBAN di pagamento.'
]

for msg in messages:
    found = [k for k in SENSITIVE_KEYWORDS if k.lower() in msg.lower()]
    print(msg, '-> sensibile' if found else '-> non sensibile', found)
```

## Checkpoint finale
- [ ] Identifico dati sensibili nel contesto AI
- [ ] Riconosco i rischi di leakage e memorization
- [ ] So come applicare minimizzazione e cifratura
- [ ] Ho eseguito una classificazione semplice dei dati

## Risorse utili
- GDPR e privacy engineering
- NIST Privacy Framework
- Cloud data protection best practices
