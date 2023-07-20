# Terraform block for configuring the backend
terraform {
  # S3 backend configuration for storing the Terraform state
  backend "s3" {
    # The name of the S3 bucket where the Terraform state will be stored
    bucket = "fabric-iac"

    # The key (path) within the S3 bucket where the Terraform state will be stored
    key = "eks/terraform.tfstate"

    # The AWS region where the S3 bucket is located
    region = "us-east-1"
  }
}