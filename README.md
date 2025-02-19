# Kubernetes Webhook Demo

## Overview
This repository contains a demo implementation of a Kubernetes admission webhook that validates pod creation by ensuring required labels are present. The webhook serves as a gatekeeper for pod creation requests, demonstrating how to enforce organizational policies in a Kubernetes cluster.

## Features
- **Pod validation webhook**
- **TLS certificate generation**
- **Kubernetes deployment configurations**
- **Example test cases**

## Prerequisites
* Go 1.24 or higher
* Docker
* Access to a Kubernetes cluster (EKS)
* `kubectl` configured
* cert-manager controller

## [Install via helm](chart/README.md)

## Quick Start (Manual)
### 1. Clone the repository
```bash
git clone https://github.com/rogertob/eks-webhook-demo.git
cd eks-webhook-demo
```

### 2. Create the certificate issuer and certificate
```bash
kubectl apply -f k8s/cert/
```
### 3. Create the ValidatingWebhookConfiguration object
```bash
kubectl apply -f k8s/webhook/
```

### 4. Patch the ValidatingWebhookConfiguration with the correct CA bundle 
```bash
CA_BUNDLE=$(kubectl get secret webhook-tls -n default -o jsonpath='{.data.ca\.crt}')
kubectl patch validatingwebhookconfiguration pod-policy-webhook --type='json' -p='[{"op": "replace", "path": "/webhooks/0/clientConfig/caBundle", "value": "'"${CA_BUNDLE}"'"}]'
```
    
### 5. Deploy webhook
```bash
kubectl apply -f k8s/deployment/
```

    
## Testing
### Create test pods using provided examples:
#### Valid pod (with required label)
```bash
kubectl apply -f k8s/test/valid.yaml
```
#### Invalid pod (missing required label)
```bash
kubectl apply -f k8s/test/invalid.yaml
```
#### Expected output
```
Error from server: error when creating "k8s/test/invalid.yaml": admission webhook "pod-policy.example.com" denied the request: Pod missing required 'environment' label
```
## Clean up
```bash
./scripts/cleanup.sh
```

---
**Note**: This webhook demo is intended for educational purposes. For production use, please ensure proper security measures and high availability configurations are implemented.