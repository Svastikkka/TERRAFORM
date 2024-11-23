terraform {
  backend "s3" {
    bucket = "fabric-iac"
    key = "waf/terraform.tfstate"
    region = "us-east-1"
  }
}