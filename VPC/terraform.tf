terraform {
  backend "s3" {
    bucket = "fabric-iacv2"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}