# CLAUDE.md

Production-grade GitOps reference implementation demonstrating ArgoCD, Argo Rollouts, and Kubernetes progressive delivery patterns.

## Stack
- Terraform >= 1.6
- Kubernetes >= 1.28
- ArgoCD 2.9+, Argo Rollouts 1.6+

## Quick Validation

```bash
cd terraform/environments/dev
terraform fmt -check -recursive
terraform validate
terraform plan

# Cluster access
aws eks update-kubeconfig --name gitops-demo-dev --region us-west-2
kubectl get nodes
```

## Architecture Patterns
- App of Apps pattern for ArgoCD application management
- Canary deployments with Prometheus-based automated analysis
- Kyverno policy enforcement (labels, resource limits, privileged containers)
- External Secrets Operator integration with AWS Secrets Manager
- Multi-environment promotion pipeline (dev → staging → prod)
