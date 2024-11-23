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