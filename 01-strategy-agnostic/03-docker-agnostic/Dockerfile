# Stage 1: Builder - installa dipendenze in un virtualenv dedicato
FROM python:3.12-alpine AS builder

WORKDIR /app

ENV VENV_PATH=/opt/venv
RUN python -m venv "$VENV_PATH"
ENV PATH="$VENV_PATH/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
	&& pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Stage 2: Runtime - contiene solo runtime Python, venv e codice applicativo
FROM python:3.12-alpine AS runtime

# Utente non-root per ridurre la superficie d'attacco a runtime
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

ENV VENV_PATH=/opt/venv
ENV PATH="$VENV_PATH/bin:$PATH"

COPY --from=builder "$VENV_PATH" "$VENV_PATH"
COPY --from=builder /app/app.py /app/app.py

USER appuser

EXPOSE 8080
CMD ["python", "app.py"]