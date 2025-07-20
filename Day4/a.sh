#!/bin/bash

# ====== CONFIG ======
KEY_NAME="my-key-$(date +%s)"
KEY_FILE="$KEY_NAME.pem"
AMI_ID="ami-01637463b2cbe7cb6"  # Amazon Linux 2 (update if needed)
INSTANCE_TYPE="t3.micro"
SECURITY_GROUP_ID="sg-079845c72325583a2"  # Allow SSH (port 22)
SUBNET_ID="subnet-0d52abe9608ee8111"      # Public Subnet ID
REGION="eu-north-1"
USER="ubuntu"
REMOTE_SCRIPT="install_terraform.sh"
# =====================

echo "[+] Creating key pair..."
aws ec2 create-key-pair \
  --key-name "$KEY_NAME" \
  --region $REGION \
  --query 'KeyMaterial' \
  --output text > "$KEY_FILE"

chmod 400 "$KEY_FILE"
echo "[+] Key pair saved to $KEY_FILE"

echo "[+] Launching EC2 Instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SECURITY_GROUP_ID \
  --subnet-id $SUBNET_ID \
  --associate-public-ip-address \
  --region $REGION \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "[+] Waiting for instance to be running..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION

PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --region $REGION \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "[+] Instance running at $PUBLIC_IP"

echo "[+] Giving instance some time to boot SSH..."
sleep 30

echo "[+] Creating remote install script..."