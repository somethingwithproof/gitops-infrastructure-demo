# ADR 002: Progressive Delivery with Argo Rollouts

## Status

Accepted

## Context

Production deployments need gradual rollout to minimize blast radius of bad deployments. Options:

1. **Kubernetes native rolling updates** - Simple but all-or-nothing
2. **Argo Rollouts** - Canary, blue-green, analysis
3. **Flagger** - Istio/Linkerd integration
4. **Custom scripts** - Manual traffic shifting

## Decision

We chose **Argo Rollouts** for:

### Canary Strategy
```yaml
strategy:
  canary:
    steps:
    - setWeight: 10
    - pause: {duration: 5m}
    - analysis:
        templates:
        - templateName: success-rate
    - setWeight: 50
    - pause: {duration: 5m}
    - analysis:
        templates:
        - templateName: success-rate
```

### Benefits
- Native ArgoCD integration
- Prometheus-based analysis
- Automatic rollback on failure
- No service mesh required

## Consequences

- Replace Deployment with Rollout resource
- Define AnalysisTemplates for health checks
- Production deployments take longer (by design)
- Requires Prometheus for metrics

## Metrics for Analysis

| Metric | Threshold | Action |
|--------|-----------|--------|
| HTTP 5xx rate | > 1% | Rollback |
| P99 latency | > 500ms | Pause |
| Pod restarts | > 0 | Rollback |
