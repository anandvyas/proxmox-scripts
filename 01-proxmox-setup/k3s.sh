#!/bin/bash
# install-k3s-corrected.sh
# Run on Proxmox host

echo "=== Installing k3s Kubernetes ==="

CONTROL_IP="192.168.1.31"
WORKER1_IP="192.168.1.32"
WORKER_GPU_IP="192.168.1.33"

# Wait for nodes to be ready
echo "Waiting for nodes to be ready..."
sleep 30

# Install control plane (without flannel since we'll use Calico)
echo "Installing control plane..."
ssh ubuntu@$CONTROL_IP << 'EOF'
curl -sfL https://get.k3s.io | sh -s - \
    --write-kubeconfig-mode 644 \
    --disable traefik \
    --flannel-backend none \
    --disable-network-policy \
    --node-ip=192.168.1.31
EOF

# Wait for control plane to be ready
sleep 10

# Get the token
echo "Getting join token..."
TOKEN=$(ssh ubuntu@$CONTROL_IP "sudo cat /var/lib/rancher/k3s/server/node-token")
echo "Token obtained"

# Install worker nodes with correct token
echo "Installing worker node 1..."
ssh ubuntu@$WORKER1_IP "curl -sfL https://get.k3s.io | K3S_URL=https://$CONTROL_IP:6443 K3S_TOKEN=$TOKEN sh -"

echo "Installing GPU worker node..."
ssh ubuntu@$WORKER_GPU_IP "curl -sfL https://get.k3s.io | K3S_URL=https://$CONTROL_IP:6443 K3S_TOKEN=$TOKEN sh -"

echo "✅ k3s installed successfully"
echo ""
echo "Check cluster status:"
ssh ubuntu@$CONTROL_IP "sudo kubectl get nodes"