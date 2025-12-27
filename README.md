# GitOps Infrastructure Demo

[![Terraform](https://img.shields.io/badge/Terraform-1.6+-623CE4?logo=terraform)](https://terraform.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28+-326CE5?logo=kubernetes)](https://kubernetes.io)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-2.9+-EF7B4D?logo=argo)](https://argoproj.github.io/cd)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Production-ready GitOps reference architecture demonstrating modern Kubernetes deployment patterns using ArgoCD, Helm, and Terraform.

## What This Demonstrates

- **GitOps Workflow**: Git as single source of truth for infrastructure and application state
- **Progressive Delivery**: Canary deployments, blue-green strategies, automated rollbacks
- **Infrastructure as Code**: Terraform modules for EKS cluster provisioning
- **Helm Chart Management**: Reusable, parameterized application deployments
- **Multi-Environment**: Dev → Staging → Production promotion patterns
- **Security Best Practices**: RBAC, network policies, secret management

## Repository Structure

```
├── terraform/                 # Infrastructure provisioning
│   ├── modules/
│   │   ├── eks/              # EKS cluster module
│   │   ├── vpc/              # VPC networking
│   │   └── argocd/           # ArgoCD bootstrap
│   └── environments/
│       ├── dev/
│       ├── staging/
│       └── production/
├── argocd/                   # ArgoCD application definitions
│   ├── apps/                 # Application manifests
│   ├── projects/             # ArgoCD projects
│   └── applicationsets/      # Dynamic app generation
├── helm/                     # Helm charts
│   └── sample-app/           # Example application chart
└── .github/
    └── workflows/            # CI/CD pipelines
```

## Quick Start

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.6
- kubectl >= 1.28
- Helm >= 3.13

### 1. Provision Infrastructure

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### 2. Configure kubectl

```bash
aws eks update-kubeconfig --name gitops-demo-dev --region us-west-2
```

### 3. Access ArgoCD

```bash
# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## GitOps Workflow

1. **Developer** pushes code changes to application repository
2. **CI Pipeline** builds container image, pushes to registry, updates Helm values
3. **ArgoCD** detects drift between Git state and cluster state
4. **ArgoCD** automatically (or manually) syncs changes to cluster
5. **Monitoring** validates deployment health, triggers rollback if needed

## Security Features

- **RBAC**: Fine-grained access control for ArgoCD projects
- **Network Policies**: Namespace isolation and traffic control
- **External Secrets**: Integration with AWS Secrets Manager
- **Image Scanning**: Trivy integration in CI pipeline

## Author

**Thomas Vincent**
- GitHub: [@thomasvincent](https://github.com/thomasvincent)
- LinkedIn: [thomasvincent](https://linkedin.com/in/thomasvincent)

## License

MIT License - see [LICENSE](LICENSE) for details.
