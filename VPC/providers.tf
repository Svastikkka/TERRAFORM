terraform {
  required_version = "=1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.49.0"
    }
  }
}

# Provider definition
provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.session_token
}