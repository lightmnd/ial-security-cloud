# Lezione 25 - AI Foundations & Machine Learning Basics

**Durata:** 60 minuti  
**Obiettivo:** introdurre i concetti fondamentali di AI, ML e data-driven decision making, con attenzione all'uso in ambienti cloud e alla sicurezza dei dati.

## 1. Obiettivi della lezione (10 min)
- Distinguere AI, ML, Deep Learning e Data Science
- Comprendere il ciclo di vita di un modello ML
- Riconoscere dove l'AI viene usata in sistemi cloud reali
- Valutare rischi iniziali: bias, dati sensibili, trasparenza

## 2. Fondamenti: AI vs ML vs DL (15 min)

### AI
AI è il campo che studia sistemi in grado di simulare capacità cognitive: classificazione, pianificazione, riconoscimento, raccomandazione.

### Machine Learning
ML costruisce modelli da dati storici per fare previsioni o classificare eventi.

### Deep Learning
DL usa reti neurali con molti strati per apprendere rappresentazioni complesse da immagini, testo e segnali.

### Esempi applicativi nel cloud
- predizione di anomalie in log e metriche
- classificazione di email e contenuti
- analisi di accessi e attività sospette
- raccomandazioni in commerce e supporto clienti

## 3. Pipeline ML semplice (10 min)
1. Raccolta dati
2. Pulizia e trasformazione
3. Addestramento
4. Valutazione
5. Deployment
6. Monitoraggio

### Concetti chiave
- train/validation/test split
- overfitting e underfitting
- precision, recall, F1-score, accuracy
- feature engineering

## 4. Cloud e AI: dove prende forma l'implementazione (10 min)
In ambienti cloud, i modelli vengono spesso eseguiti tramite:
- servizi di inferenza serverless
- contenedori
- GPU/acceleratori
- pipeline di data ingestion e monitoring

Esempi:
- S3 come sorgente dati
- Lambda/ECS/EKS come runtime applicativo
- CloudWatch per monitoraggio
- IAM per minimizzazione dei privilegi

## 5. Rischi e sicurezza iniziali (10 min)
- dati sensibili non adeguatamente protetti
- modello addestrato su dataset distorti
- output non verificato in processi critici
- accessi non minimizzati alle API di inferenza

## 6. Hands-on (5 min)
Crea un piccolo script Python per distinguere dataset e utilizzare una semplice regressione lineare con scikit-learn.

### Esempio minimo
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install scikit-learn pandas matplotlib
```

```python
from sklearn.datasets import make_regression
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split

X, y = make_regression(n_samples=200, n_features=2, noise=10, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = LinearRegression()
model.fit(X_train, y_train)
score = model.score(X_test, y_test)
print(f"R2 score: {score:.3f}")
```

## Checkpoint finale
- [ ] Distinguo AI, ML e DL
- [ ] Comprendo il ciclo di un modello
- [ ] So dove l'AI viene usata in cloud
- [ ] Ho eseguito un primo esempio pratico

## Risorse utili
- scikit-learn documentation
- AWS AI/ML overview
- Microsoft Learn AI fundamentals
