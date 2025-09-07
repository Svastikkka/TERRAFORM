terraform {
  required_version = "=1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
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