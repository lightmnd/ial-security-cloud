# Mini laboratorio finale - Test in PDF e flashcards con Gemini

## Obiettivo
Questo mini laboratorio trasforma il test finale in un'attività creativa e pratica. Gli studenti copieranno le domande e le risposte del test, le incolleranno su Gemini Free e chiederanno all'AI di:
1. generare un PDF esportabile e ben formattato;
2. creare un layout visivamente ordinato e leggibile;
3. produrre flashcards sugli argomenti hot emersi nel test.

L'obiettivo non è solo rispondere alle domande, ma sintetizzare il contenuto in un materiale riutilizzabile per revisione e ripasso.

---

## Flow del laboratorio

### Fase 1 - Preparazione del testo
Gli studenti aprono il file:
- [test-ai-security.md](test-ai-security.md)
- oppure [test-ai-security-quick.md](test-ai-security-quick.md)

Poi copiano il testo completo delle domande e delle relative risposte guida o delle proprie risposte.

### Fase 2 - Ingresso in Gemini
Incollano nel prompt del modello una struttura del tipo:

```text
Trasforma il testo seguente in un PDF formale e ben strutturato per studenti di sicurezza informatica e AI Security.

Requisiti:
- layout elegante e professionale
- intestazione con titolo del corso
- sezione per domande e risposte
- margini chiari e testo leggibile
- usare un linguaggio tecnico ma chiaro
- includere una sintesi finale delle aree più importanti
- creare una sezione dedicata alle parole chiave

Testo:
[incollare qui le domande e le risposte]
```

### Fase 3 - Richiesta di PDF
Successivamente chiedono al modello:

```text
Genera un PDF esportabile, pronto da condividere e stampare. Il documento deve avere:
- titolo chiaro
- sezioni ordinate
- una copertina iniziale
- domande e risposte organizzate per argomento
- una tabella riassuntiva delle aree hot
```

### Fase 4 - Flashcards
Poi chiedono anche:

```text
A partire dalle stesse domande, crea flashcards in formato Q&A.

Requisiti:
- 20-30 flashcards
- domande brevi e dirette
- risposte concise ma complete
- enfatizzare i concetti chiave: provenance, prompt injection, model drift, overfitting, privacy leakage, deepfake, AI-enhanced phishing, RBAC, governance AI, context window, temperature, top-p, instruction hierarchy, model card.
- organizza le flashcards per argomento
```

### Fase 5 - Revisione finale
Gli studenti verificano:
- la qualità del PDF
- la leggibilità del layout
- la coerenza delle flashcards
- se gli argomenti più critici sono stati evidenziati

---

## Prompt completo consigliato

```text
Trasforma il testo seguente in un PDF accademico e ben formattato per un corso di AI Security.

Obiettivo:
- creare un documento professionale e leggibile
- organizzare per sezioni tematiche
- usare linguaggio tecnico ma accessibile
- evidenziare gli argomenti più importanti per l'esame

Successivamente, genera anche una sezione di flashcards con domande e risposte concise.

Testo:
[incollare qui il contenuto completo del test]
```

---

## Argomenti hot da far emergere nelle flashcards
Gli studenti devono chiedere che le flashcards mettano in evidenza almeno questi temi:
- provenance dei dati
- overfitting e validation set
- prompt injection
- model drift
- privacy leakage
- deepfake e AI-enhanced phishing
- governance e access control
- RBAC e MFA
- model card
- instruction hierarchy
- temperature, top-p e context window
- AI nel DFIR
- chain of custody e explainability

---

## Output atteso
Alla fine del laboratorio, ogni studente dovrebbe avere:
- un PDF esportabile dal modello;
- una mini raccolta di flashcards;
- una sintesi delle aree hot del corso;
- un materiale riutilizzabile per ripasso e revisione finale.

---

## Criteri di valutazione del mini laboratorio
- correttezza dei contenuti del PDF
- coerenza tra domande, risposte e argomenti trattati
- qualità della struttura visiva del documento
- qualità delle flashcards
- capacità di evidenziare i temi più importanti del modulo

---

## Valutazione rapida per docente
- [ ] PDF generato correttamente
- [ ] Flashcards prodotte
- [ ] temi principali evidenziati
- [ ] materiale esportabile e leggibile
- [ ] testo finale coerente con il corso

---

## Nota didattica
Questo mini laboratorio è pensato come attività finale di sintesi: aiuta gli studenti a trasformare il test in un output pratico, visivo e riutilizzabile, migliorando il consolidamento delle conoscenze e la preparazione all’esame.
