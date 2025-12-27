variable "cluster_name" {
  type = string
}

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "argocd_version" {
  type    = string
  default = "5.51.6"
}

variable "git_repo_url" {
  type = string
}

variable "target_revision" {
  type    = string
  default = "main"
}
