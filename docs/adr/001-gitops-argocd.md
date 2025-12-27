# ADR 001: Use ArgoCD for GitOps

## Status

Accepted

## Context

We need a GitOps controller to manage Kubernetes deployments declaratively. Options considered:

1. **ArgoCD** - CNCF graduated project, strong UI, App of Apps pattern
2. **Flux v2** - CNCF graduated project, GitOps Toolkit, Helm controller
3. **Jenkins X** - CI/CD focused, GitOps capabilities
4. **Spinnaker** - Multi-cloud, complex setup

## Decision

We chose **ArgoCD** for the following reasons:

### Pros
- Intuitive web UI for debugging sync issues
- ApplicationSets for multi-environment generation
- Strong RBAC model with SSO integration
- Excellent Helm and Kustomize support
- Active community and CNCF backing
- Argo Rollouts integration for progressive delivery

### Cons
- Pull-based only (not push)
- UI can mask underlying complexity
- Resource overhead for controller

## Consequences

- All deployments managed via Git commits
- ArgoCD installed in dedicated `argocd` namespace
- App of Apps pattern for application management
- Developers can view (not modify) via UI
- Platform team manages ArgoCD configuration

## Alternatives Considered

### Flux v2
- Better for pure CLI workflows
- Less visual debugging capability
- Would require additional tooling for UI

### Spinnaker
- Overkill for our scale
- Complex operational overhead
- Better suited for multi-cloud enterprise
