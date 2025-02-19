#!/bin/bash
set -e

echo "Starting cleanup of Kubernetes Webhook Demo resources..."

# Delete test resources (pods) if they exist
echo "Deleting test pods..."
kubectl delete -f k8s/test/ || echo "No test pods to delete."

# Delete the ValidatingWebhookConfiguration
echo "Deleting webhook configuration..."
kubectl delete -f k8s/webhook/ || echo "No webhook configuration found."

# Delete the Deployment (and associated Service)
echo "Deleting webhook deployment..."
kubectl delete -f k8s/deployment/ || echo "No deployment found."

# Delete certificate and issuer resources
echo "Deleting certificate resources..."
kubectl delete -f k8s/cert/ || echo "No certificate resources found."

# Optionally delete the TLS secret if you no longer need it
echo "Deleting TLS secret (if exists)..."
kubectl delete secret webhook-tls -n default || echo "TLS secret not found."

echo "Cleanup completed."
