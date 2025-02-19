# Webhook Demo Helm Chart

## Overview
This Helm chart deploys a Kubernetes admission webhook demo that validates pod creation by ensuring required labels are present. The webhook, written in Go, is containerized and secured with TLS certificates managed by cert-manager. It demonstrates how to enforce policies and automate certificate management in a Kubernetes cluster.

## Features
- **Pod Validation Webhook:** Validates pod creation requests for required labels.
- **Automated TLS Management:** Uses cert-manager to generate and renew TLS certificates.
- **Templated Kubernetes Resources:** Includes Deployment, Service, ValidatingWebhookConfiguration, Certificate, and ClusterIssuer.
- **Customizable via Helm:** Easily override settings such as image repository, tag, and webhook configuration.

## Prerequisites
- Kubernetes 1.25+
- Helm 3+
- cert-manager installed in the cluster
- Access to a container registry (e.g., AWS ECR) for the Docker image

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/rogertob/eks-webhook-demo.git
cd eks-webhook-demo/chart
```

### 2. Deploy the Chart
Install the chart with Helm:
```bash
helm install webhook-demo ./
```

## Testing
Deploy test pods to verify the webhook behavior:
- **Valid Pod:** Should be accepted if it includes the required label.
- **Invalid Pod:** Should be rejected with an error indicating the missing label.

Example commands:
```bash
kubectl apply -f ../k8s/test/valid.yaml
kubectl apply -f ../k8s/test/invalid.yaml
```

## Uninstallation
To remove all resources installed by this chart:
```bash
helm uninstall webhook-demo
```

## Additional cleanup
```bash
./../scripts/cleanup.sh
```