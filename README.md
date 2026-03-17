# Linux Infrastructure Automation Platform

Automated infrastructure provisioning and configuration management platform using Terraform and Ansible, reducing manual provisioning tasks by approximately 80%.

## What This Project Does
- Provisions cloud infrastructure automatically using Terraform
- Configures and hardens Linux servers using Ansible
- Reduces manual provisioning from 60 steps to 2 commands
- Supports multiple environments (dev and prod)

## Technologies Used
- Terraform
- Ansible
- Linux
- Bash

## Project Structure
```
project1-infra-automation/
├── terraform/
│   ├── modules/
│   │   ├── vpc/        # Network configuration
│   │   ├── compute/    # Server configuration
│   │   └── security/   # Security groups
│   └── environments/
│       ├── dev/        # Development environment
│       └── prod/       # Production environment
├── ansible/
│   ├── roles/
│   │   ├── common/     # Base server configuration
│   │   └── hardening/  # Security hardening
│   └── playbooks/      # Orchestration playbooks
└── scripts/
    └── bootstrap.sh    # One command setup script
```

## How to Use

### Step 1 - Provision Infrastructure
```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### Step 2 - Configure Servers
```bash
cd ansible
ansible-playbook -i inventory/hosts.yml playbooks/site.yml
```

## Results
| Metric | Before | After |
|--------|--------|-------|
| Provisioning time | 4 hours manual | 18 minutes automated |
| Manual steps | 60 steps | 2 commands |
| Tasks automated | 0% | 80% |
