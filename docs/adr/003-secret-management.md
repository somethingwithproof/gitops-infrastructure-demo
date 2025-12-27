# ADR 003: External Secrets Operator for Secret Management

## Status

Accepted

## Context

Kubernetes Secrets are base64 encoded (not encrypted). We need secure secret management that:
- Doesn't store secrets in Git
- Integrates with AWS Secrets Manager
- Supports rotation
- Auditable

## Options Considered

1. **Sealed Secrets** - Encrypted in Git, decrypted in cluster
2. **External Secrets Operator** - Syncs from external secret stores
3. **HashiCorp Vault** - Full-featured secret management
4. **AWS Secrets Manager CSI Driver** - Direct mount

## Decision

We chose **External Secrets Operator (ESO)** because:

### Architecture
```
AWS Secrets Manager → External Secrets Operator → Kubernetes Secret → Pod
```

### Benefits
- Secrets never stored in Git
- Automatic sync/rotation
- IRSA for AWS authentication (no static credentials)
- Works with existing AWS Secrets Manager
- Lower operational overhead than Vault

### Example
```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: app-secrets
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: app-secrets
  data:
  - secretKey: database-password
    remoteRef:
      key: production/database
      property: password
```

## Consequences

- All secrets managed in AWS Secrets Manager
- ESO deployed via ArgoCD
- IRSA configured for ESO service account
- 1-hour refresh interval for rotation
