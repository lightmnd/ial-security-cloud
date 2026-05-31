# Sostenibilità: uso di immagine base leggera (Alpine)
FROM python:3.9-alpine

# Qualità: definizione di un utente non-root per la sicurezza
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Installa le dipendenze come root (pip scrive in system Python, non /home/appuser)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia il codice applicativo
COPY app.py .

# Passa all'utente non-root solo per l'esecuzione
USER appuser

EXPOSE 8080
CMD ["python", "app.py"]