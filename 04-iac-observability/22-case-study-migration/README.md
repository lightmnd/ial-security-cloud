# 📘 Lezione 22 – Case Study: Migrazione Cloud

**📅 Data:** Mercoledì 14/09/2025  
**🗂️ Modulo:** Modulo 4 – IaC & Osservabilità  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Applicare il framework 7Rs per analizzare una migrazione cloud
- Analizzare il case study della PA italiana
- Costruire un piano di migrazione per fasi
- Valutare i vincoli di compliance AgID e CAD

## 📚 Concetti Chiave

### I 7Rs della Migrazione Cloud

| R | Nome | Descrizione | Complessità | Beneficio |
|---|------|-------------|-------------|-----------|
| 1 | **Rehost** | Lift & Shift — sposta la VM su cloud senza modifiche | Bassa | Basso |
| 2 | **Replatform** | Piccole ottimizzazioni (es. db su RDS) | Media | Medio |
| 3 | **Refactor** | Riscrittura per cloud-native (microservizi, Lambda) | Alta | Alto |
| 4 | **Repurchase** | Passa a SaaS (es. Salesforce, ServiceNow) | Media | Medio |
| 5 | **Retain** | Mantieni on-premise (troppo complesso/costoso migrare) | — | — |
| 6 | **Retire** | Elimina applicazioni obsolete | Bassa | Alto (riduzione costi) |
| 7 | **Relocate** | Sposta VMware su VMware Cloud on AWS | Bassa | Medio |

## 🛠️ Hands-on: Analisi Case Study Comune di Castellabate

Vedi il file `migration-matrix.md` per l'analisi completa.

```bash
cat 04-iac-observability/22-case-study-migration/migration-matrix.md
```

### Esercizio: Classificare le Applicazioni

Per ogni applicazione del Comune, completa l'analisi:

```
Applicazione: [nome]
Strategia 7R scelta: [R scelto]
Motivazione: [perché]
Rischi: [elenco]
Timeline stimata: [mesi]
Costo stimato: [fascia]
```

### 🧹 Cleanup
Nessuna risorsa cloud creata in questo lab teorico.

## ✅ Checkpoint
- [ ] Conosco i 7Rs e so quando applicarli
- [ ] Ho analizzato il case study del Comune
- [ ] Ho compilato la migration matrix
- [ ] Comprendo i vincoli AgID e CAD per la PA

## 📖 Approfondimenti
- [AWS Migration Strategy](https://aws.amazon.com/cloud-migration/how-to-migrate/)
- [AgID Cloud Enablement](https://cloud.italia.it/)
- [AWS CAF (Cloud Adoption Framework)](https://aws.amazon.com/cloud/adoption-framework/)
