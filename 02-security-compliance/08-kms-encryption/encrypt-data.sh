#!/bin/bash
# Lezione 8 – Crittografia con AWS KMS
# Prerequisiti: AWS CLI configurato, variabile REGION e KEY_ALIAS impostata

set -euo pipefail

REGION="${AWS_REGION:-eu-west-1}"
KEY_ALIAS="alias/gestionale-master-key"
PLAINTEXT_FILE="/tmp/secret-gestionale.txt"
ENCRYPTED_FILE="/tmp/secret-gestionale.enc"
DECRYPTED_FILE="/tmp/secret-gestionale.dec"

echo "🔑 Step 1 – Creazione chiave KMS Customer Managed Key (CMK)"
KEY_ID=$(aws kms create-key \
  --description "Chiave master per il sistema gestionale" \
  --key-usage ENCRYPT_DECRYPT \
  --region "$REGION" \
  --query "KeyMetadata.KeyId" \
  --output text)

echo "   KeyId creata: $KEY_ID"

echo "📛 Step 2 – Assegnazione alias leggibile"
aws kms create-alias \
  --alias-name "$KEY_ALIAS" \
  --target-key-id "$KEY_ID" \
  --region "$REGION"

echo "🔄 Step 3 – Abilitazione rotazione automatica annuale"
aws kms enable-key-rotation \
  --key-id "$KEY_ID" \
  --region "$REGION"

echo "🔒 Step 4 – Cifratura di un dato sensibile"
echo "Dati riservati del gestionale: CF=RSSMRA80A01H501Z" > "$PLAINTEXT_FILE"
aws kms encrypt \
  --key-id "$KEY_ALIAS" \
  --plaintext "fileb://$PLAINTEXT_FILE" \
  --output text \
  --query CiphertextBlob \
  --region "$REGION" | base64 --decode > "$ENCRYPTED_FILE"

echo "   File cifrato: $ENCRYPTED_FILE"

echo "🔓 Step 5 – Decifratura e verifica"
aws kms decrypt \
  --ciphertext-blob "fileb://$ENCRYPTED_FILE" \
  --output text \
  --query Plaintext \
  --region "$REGION" | base64 --decode > "$DECRYPTED_FILE"

echo "   File decifrato: $(cat $DECRYPTED_FILE)"

echo ""
echo "🧹 Cleanup – Pianificazione eliminazione chiave (minimo 7 giorni)"
echo "   Esegui manualmente quando non più necessaria:"
echo "   aws kms schedule-key-deletion --key-id $KEY_ID --pending-window-in-days 7 --region $REGION"
