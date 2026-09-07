# Lezione 29 - AI Security: Governance, Secure Deployment e Best Practices

**Durata:** 60 minuti  
**Obiettivo:** definire come costruire, distribuire e governare soluzioni AI in modo sicuro nel contesto cloud, con attenzione alla responsabilità, alla tracciabilità e al controllo del rischio.

## 1. Obiettivi della lezione (10 min)
- Governare il ciclo di vita del modello AI
- Integrare sicurezza nel design del sistema
- Definire responsabilità e controlli di sicurezza
- Creare un framework pratico per deployment robusto

## 2. AI Governance: cosa gestire (15 min)
Un framework di governance AI include:
- ownership e responsabilità
- classificazione dei modelli
- valutazione del rischio
- revisioni e approvazioni
- policy di accesso e retention
- log e auditability

## 3. Secure AI deployment (15 min)
### Sicurezza del deployment
- isolare runtime e rete
- ridurre privilegi degli identity
- usare secret manager e workload identity
- validare immagini e dipendenze software
- introdurre test di sicurezza prima di deploy

### Sicurezza del modello
- registrare versioni con metadata e approvazione
- monitorare drift e qualità dell’output
- mettere in place rollback e canary deployment
- tenere traccia di dati e feature usate in inferenza

## 4. Guardrails e contesto applicativo (10 min)
Guardrails aiutano a evitare comportamenti pericolosi del modello:
- prompt validation
- output filtering
- allowlist/denylist
- controllo di categorie sensibili
- fallback human-in-the-loop

## 5. KPI di sicurezza AI (5 min)
- numero di prompt blocchi
- tasso di accessi non autorizzati
- leak di dati sensibili
- incident response time
- numero di deployment con review

## 6. Hands-on (5 min)
Definisci una checklist di sicurezza per un servizio AI in produzione. Esempio di checklist minima:

```yaml
security_checks:
  - identity_and_access: true
  - secrets_management: true
  - input_validation: true
  - output_review: true
  - logging_and_audit: true
  - data_classification: true
  - model_versioning: true
  - rollback_plan: true
```

## Checkpoint finale
- [ ] Comprendo governance AI e responsabilità aziendali
- [ ] So come realizzare deployment AI sicuro
- [ ] Conosco i guardrails essenziali
- [ ] Ho preparato una checklist di sicurezza AI

## Risorse utili
- NIST AI RMF
- OWASP LLM Security
- CIS AI governance guidance
- TryHackMe AI Security path
