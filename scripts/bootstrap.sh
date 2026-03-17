#!/usr/bin/env bash
# Bootstrap script - installs all required tools
# Usage: chmod +x scripts/bootstrap.sh && ./scripts/bootstrap.sh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log()     { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()      { echo -e "${GREEN}[OK]${NC}    $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

echo ""
echo "================================================"
echo "  Linux Infrastructure Automation Platform"
echo "  Bootstrap Script"
echo "================================================"
echo ""

# Check if running as root
[[ $EUID -eq 0 ]] && error "Do not run as root. Run as normal user with sudo access."

# Install Terraform
install_terraform() {
  if command -v terraform &>/dev/null; then
    ok "Terraform already installed: $(terraform version -json | python3 -c 'import sys,json; print(json.load(sys.stdin)["terraform_version"])')"
    return
  fi

  log "Installing Terraform..."
  wget -qO- https://apt.releases.hashicorp.com/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update -qq
  sudo apt-get install -y terraform
  ok "Terraform installed successfully"
}

# Install Ansible
install_ansible() {
  if command -v ansible &>/dev/null; then
    ok "Ansible already installed: $(ansible --version | head -1)"
    return
  fi

  log "Installing Ansible..."
  sudo apt-get update -qq
  sudo apt-get install -y ansible python3-pip
  pip3 install boto3 botocore
  ok "Ansible installed successfully"
}

# Install Ansible collections
install_collections() {
  log "Installing Ansible Galaxy collections..."
  ansible-galaxy collection install \
    amazon.aws \
    community.general \
    ansible.posix \
    --ignore-errors
  ok "Ansible collections installed"
}

# Generate SSH key
generate_ssh_key() {
  KEY_PATH="$HOME/.ssh/infra-automation"
  if [ -f "$KEY_PATH" ]; then
    ok "SSH key already exists at $KEY_PATH"
    return
  fi

  log "Generating SSH key pair..."
  ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -C "infra-automation"
  ok "SSH key created at $KEY_PATH"
  log "Public key: $(cat ${KEY_PATH}.pub)"
}

# Print summary
print_summary() {
  echo ""
  echo "================================================"
  echo "  Bootstrap Complete!"
  echo "================================================"
  echo ""
  echo "  Next steps:"
  echo "  1. Configure AWS credentials: aws configure"
  echo "  2. Deploy infrastructure:     cd terraform/environments/dev"
  echo "                                terraform init"
  echo "                                terraform apply"
  echo "  3. Configure servers:         cd ansible"
  echo "                                ansible-playbook -i inventory/hosts.yml playbooks/site.yml"
  echo ""
}

# Run all functions
install_terraform
install_ansible
install_collections
generate_ssh_key
print_summary
