#!/bin/bash
# install-calico.sh
# Run on control plane node

echo "=== Installing Calico CNI ==="

ssh ubuntu@192.168.1.31 << 'EOF'
# Install Calico
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26/manifests/calico.yaml

# Wait for Calico to be ready
sleep 30

# Verify
kubectl get pods -n kube-system | grep calico
EOF

echo "✅ Calico installed"