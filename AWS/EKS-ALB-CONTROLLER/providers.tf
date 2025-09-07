terraform {
  required_version = "=1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.2"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}

# Provider definition
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
  token      = var.session_token
}

data "aws_eks_cluster" "fabric-cluster" {
  name = "${var.eks_cluster_name}-${var.environment}-v1"
}

data "aws_eks_cluster_auth" "fabric-cluster-auth" {
  name = "${var.eks_cluster_name}-${var.environment}-v1"
}

# Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.fabric-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.fabric-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.fabric-cluster-auth.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.fabric-cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.fabric-cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.fabric-cluster-auth.token
  }
}
