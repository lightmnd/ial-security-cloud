# Sostenibilità: uso di immagine base leggera (Alpine)
FROM python:3.9-alpine

# Qualità: definizione di un utente non-root per la sicurezza
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

WORKDIR /app
COPY src/ .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080
CMD ["python", "app.py"]