# Proxmox Homelab Scripts

## Directory Structure

| Directory | Purpose |
|-----------|---------|
| `01-proxmox-setup/` | Proxmox host preparation, drivers, network config |
| `02-vms/` | VM creation scripts (pfSense, etc.) |
| `03-containers/` | LXC container creation scripts |
| `04-docker-services/` | Docker deployment scripts |
| `05-ai-workloads/` | Ollama, models, AI-specific setup |
| `06-monitoring/` | Health checks, verification scripts |
| `07-backups/` | Backup automation scripts |
| `logs/` | Execution logs |
| `configs/` | Configuration templates |
| `bin/` | Executable utilities |

## Usage

Run scripts in order:
```bash
cd /root/scripts
./01-proxmox-setup/host-prep.sh
./02-vms/pfsense-create.sh
# etc...