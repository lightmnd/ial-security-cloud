#!/bin/bash

# Esci immediatamente se un comando fallisce (opzionale, ma utile se i passaggi successivi dipendono dai precedenti)
# set -e 

echo "🛠️ Inizializzazione Ambiente di Sviluppo..."
echo "--------------------------------------------"

# Array dei tool da verificare (compatibile anche con la vecchia Bash 3.2 di macOS)
TOOLS=("aws" "terraform" "docker" "kubectl")
MISSING_TOOLS=0

for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "❌ $tool non trovato."
        MISSING_TOOLS=$((MISSING_TOOLS + 1))
    else
        echo "🔹 $tool: OK"
    fi
done

echo "--------------------------------------------"

# Se mancano tool, avvisiamo l'utente invece di dire che è tutto ok
if [ $MISSING_TOOLS -gt 0 ]; then
    echo "⚠️  Attenzione: $MISSING_TOOLS strumento/i mancante/i. Installali prima di procedere."
    # exit 1 # Scommenta se vuoi bloccare categoricamente lo script qui
fi

# Creazione cartelle di lavoro locali
echo "📁 Creazione directory del workspace..."
mkdir -p workspace/terraform workspace/docker workspace/k8s

echo "🎉 Setup completato! Ora puoi procedere con il Modulo 1."