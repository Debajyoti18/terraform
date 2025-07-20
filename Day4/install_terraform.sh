
#!/bin/bash
echo "[+] Updating packages..."
sudo apt-get update -y

echo "[+] Installing required tools..."
sudo apt-get install -y gnupg software-properties-common curl unzip

echo "[+] Installing Terraform..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update -y
sudo apt install terraform -y

echo "[+] Setting up Terraform project..."
mkdir ~/my-terraform-project
cd ~/my-terraform-project

cat <<EOT > main.tf
provider "aws" {
  region = "$REGION"
}
EOT

echo "[+] Initializing Terraform..."
terraform init
EOF

chmod +x "$REMOTE_SCRIPT"

echo "[+] Copying install script to instance..."
scp -o StrictHostKeyChecking=no -i "$KEY_FILE" "$REMOTE_SCRIPT" "$USER@$PUBLIC_IP:/home/$USER/"

echo "[+] Running remote setup script via SSH..."
ssh -o StrictHostKeyChecking=no -i "$KEY_FILE" "$USER@$PUBLIC_IP" "bash /home/$USER/$REMOTE_SCRIPT"

echo "[✓] Terraform installation and project setup complete on EC2 instance."
