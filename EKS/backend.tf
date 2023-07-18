terraform {
  backend "s3" {
    bucket = "fabric-iacv2"
    key = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}