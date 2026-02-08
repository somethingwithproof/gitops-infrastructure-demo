# ArgoCD Bootstrap Module
resource "kubernetes_namespace" "argocd" {
  metadata {
    name   = var.argocd_namespace
    labels = { "app.kubernetes.io/managed-by" = "terraform" }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    yamlencode({
      server = {
        service = { type = "ClusterIP" }
        certificate = {
          enabled = true
        }
        ingress = {
          enabled = false
        }
      }
      configs = {
        repositories = {
          gitops-demo = {
            url  = var.git_repo_url
            type = "git"
          }
        }
        params = {
          "server.insecure" = "false"
        }
      }
      applicationSet = { enabled = true }
    })
  ]
  wait = true
}

resource "kubernetes_manifest" "app_of_apps" {
  depends_on = [helm_release.argocd]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "app-of-apps"
      namespace = var.argocd_namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.git_repo_url
        targetRevision = var.target_revision
        path           = "argocd/apps"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.argocd_namespace
      }
      syncPolicy = {
        automated = { prune = true, selfHeal = true }
      }
    }
  }
}
