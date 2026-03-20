#!/bin/bash
# install-k3s.sh
# Run on Proxmox host (will SSH to nodes)

echo "=== Installing k3s Kubernetes ==="

CONTROL_IP="192.168.1.31"
WORKER1_IP="192.168.1.32"
WORKER_GPU_IP="192.168.1.33"

echo "Waiting for nodes to be ready..."
sleep 30

# Install control plane
echo "Installing control plane..."
ssh ubuntu@$CONTROL_IP << 'EOF'
curl -sfL https://get.k3s.io | sh -s - \
    --write-kubeconfig-mode 644 \
    --disable traefik \
    --flannel-backend none \
    --disable-network-policy \
    --node-ip=192.168.1.31
EOF

# Get token
TOKEN=$(ssh ubuntu@$CONTROL_IP "sudo cat /var/lib/rancher/k3s/server/node-token")
echo "Token: $TOKEN"

# Install worker nodes
echo "Installing worker nodes..."
ssh ubuntu@$WORKER1_IP "curl -sfL https://get.k3s.io | K3S_URL=https://$CONTROL_IP:6443 K3S_TOKEN=$TOKEN sh -"
ssh ubuntu@$WORKER_GPU_IP "curl -sfL https://get.k3s.io | K3S_URL=https://$CONTROL_IP:6443 K3S_TOKEN=$TOKEN sh -"

echo "✅ k3s installed successfully"
echo ""
echo "Check cluster status:"
ssh ubuntu@$CONTROL_IP "sudo kubectl get nodes"