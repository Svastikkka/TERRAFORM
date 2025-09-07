terraform {
  backend "s3" {
    bucket = "fabric-iac"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}