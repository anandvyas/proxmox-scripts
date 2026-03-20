#!/bin/bash
# check-prerequisites.sh
# Run on Proxmox host

echo "=== Checking Proxmox Setup ==="

# Check Proxmox version
pveversion

# Check available storage
echo -e "\n=== Available Storage ==="
pvesm status

# Check network bridge
echo -e "\n=== Network Bridge ==="
ip link show vmbr0

# Check CPU cores available
echo -e "\n=== CPU Cores ==="
lscpu | grep "^CPU(s):"

# Check RAM available
echo -e "\n=== Memory ==="
free -h

# Check if GPU is present
if lspci | grep -i nvidia > /dev/null; then
    echo -e "\n✅ NVIDIA GPU detected"
else
    echo -e "\n⚠️ No NVIDIA GPU detected"
fi

echo -e "\n=== Proxmox is ready for Kubernetes ==="