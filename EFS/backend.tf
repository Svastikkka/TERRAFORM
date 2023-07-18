terraform {
  backend "s3" {
    bucket = "fabric-iac"
    key = "efs/terraform.tfstate"
    region = "us-east-1"
  }
}