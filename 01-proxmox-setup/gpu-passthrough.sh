#!/bin/bash
# setup-gpu-passthrough.sh
# Run on Proxmox host

echo "=== Configuring GPU Passthrough for Worker Node ==="

# Get NVIDIA GPU PCI address
GPU_PCI=$(lspci | grep -i nvidia | head -1 | awk '{print $1}')

if [ -z "$GPU_PCI" ]; then
    echo "No NVIDIA GPU detected. Skipping GPU passthrough."
    exit 0
fi

echo "GPU found at PCI: $GPU_PCI"

# Add to VM config
echo "Adding GPU to k8s-worker-gpu VM..."
cat >> /etc/pve/qemu-server/103.conf << EOF

# NVIDIA GPU Passthrough
hostpci0: $GPU_PCI,pcie=1,x-vga=0
EOF

echo "✅ GPU passthrough configured"
echo "Reboot required for changes to take effect."