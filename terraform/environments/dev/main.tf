# Development Environment
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }

  backend "s3" {
    bucket         = "gitops-demo-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "gitops-demo"
      ManagedBy   = "terraform"
    }
  }
}

locals {
  cluster_name = "gitops-demo-${var.environment}"
}

module "vpc" {
  source       = "../../modules/vpc"
  cluster_name = local.cluster_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

module "eks" {
  source          = "../../modules/eks"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  node_groups     = var.node_groups
}

module "argocd" {
  source           = "../../modules/argocd"
  depends_on       = [module.eks]
  cluster_name     = local.cluster_name
  argocd_namespace = "argocd"
  argocd_version   = var.argocd_version
  git_repo_url     = var.git_repo_url
  target_revision  = var.target_revision
}
