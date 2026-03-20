#!/bin/bash
# create-k8s-nodes.sh
# Run on Proxmox host

echo "=== Creating Kubernetes Nodes ==="

# Variables
TEMPLATE_ID=9000
GATEWAY=192.168.1.1

# Control Plane Node
echo "Creating Control Plane Node..."
qm clone $TEMPLATE_ID 101 --name k8s-control-1 --full
qm set 101 \
    --cores 4 \
    --memory 8192 \
    --ipconfig0 ip=192.168.1.31/24,gw=$GATEWAY \
    --ciuser ubuntu \
    --cipassword your-secure-password \
    --sshkeys ~/.ssh/id_rsa.pub

# Worker Node 1 (General workloads)
echo "Creating Worker Node 1..."
qm clone $TEMPLATE_ID 102 --name k8s-worker-1 --full
qm set 102 \
    --cores 6 \
    --memory 16384 \
    --ipconfig0 ip=192.168.1.32/24,gw=$GATEWAY \
    --ciuser ubuntu \
    --sshkeys ~/.ssh/id_rsa.pub

# Worker Node 2 (GPU workloads)
echo "Creating Worker Node 2 (GPU)..."
qm clone $TEMPLATE_ID 103 --name k8s-worker-gpu --full
qm set 103 \
    --cores 6 \
    --memory 16384 \
    --ipconfig0 ip=192.168.1.33/24,gw=$GATEWAY \
    --ciuser ubuntu \
    --sshkeys ~/.ssh/id_rsa.pub

# Start all nodes
echo "Starting nodes..."
qm start 101
qm start 102
qm start 103

echo "✅ Kubernetes nodes created"
echo ""
echo "Nodes:"
echo "  Control Plane: 192.168.1.31"
echo "  Worker 1: 192.168.1.32"
echo "  Worker GPU: 192.168.1.33"