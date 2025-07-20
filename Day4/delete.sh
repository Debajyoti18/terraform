#!/bin/bash

# === Required: values from launch script ===
INSTANCE_ID="i-xxxxxxxxxxxxxxxxx"       # <-- Put your EC2 instance ID here
KEY_NAME="my-key-1753002222"            # <-- Put the same key name used during launch
KEY_FILE="$KEY_NAME.pem"
REGION="eu-north-1"
# ===========================================

echo "[!] Terminating instance $INSTANCE_ID..."
aws ec2 terminate-instances \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION" > /dev/null

echo "[+] Waiting for termination to complete..."
aws ec2 wait instance-terminated \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION"

echo "[✓] Instance terminated."

echo "[!] Deleting key pair from AWS..."
aws ec2 delete-key-pair \
  --key-name "$KEY_NAME" \
  --region "$REGION"

echo "[✓] Key pair deleted in AWS."

if [ -f "$KEY_FILE" ]; then
  echo "[!] Removing local key file $KEY_FILE..."
  rm -f "$KEY_FILE"
  echo "[✓] Local key file deleted."
else
  echo "[!] Local key file not found: $KEY_FILE"
fi

echo "[✔️] Cleanup complete."
