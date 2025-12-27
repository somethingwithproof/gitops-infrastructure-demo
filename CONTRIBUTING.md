# Contributing

Contributions welcome! Please follow these guidelines:

## Development Setup

```bash
# Clone the repository
git clone https://github.com/thomasvincent/gitops-infrastructure-demo.git
cd gitops-infrastructure-demo

# Install pre-commit hooks
pre-commit install
```

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance

## Testing

```bash
# Terraform
cd terraform/environments/dev
terraform init -backend=false
terraform validate

# Helm
helm lint helm/sample-app
helm template sample-app helm/sample-app
```
