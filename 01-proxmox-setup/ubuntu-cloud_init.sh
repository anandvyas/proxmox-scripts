#!/bin/bash
# create-ubuntu-template.sh
# Run on Proxmox host

echo "=== Creating Ubuntu 22.04 Template ==="

# Download Ubuntu Cloud Image
cd /var/lib/vz/template/iso
wget -O ubuntu-22.04-server-cloudimg-amd64.img \
    https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img

# Create VM template
qm create 9000 \
    --name ubuntu-22.04-template \
    --memory 2048 \
    --cores 2 \
    --net0 virtio,bridge=vmbr0 \
    --scsihw virtio-scsi-pci \
    --ostype l26 \
    --agent 1

# Import disk
qm importdisk 9000 ubuntu-22.04-server-cloudimg-amd64.img local-lvm
qm set 9000 --scsi0 local-lvm:vm-9000-disk-0

# Add cloud-init drive
qm set 9000 --ide2 local-lvm:cloudinit

# Set boot order
qm set 9000 --boot order=scsi0

# Convert to template
qm template 9000

echo "✅ Template created successfully"
echo "Template ID: 9000"