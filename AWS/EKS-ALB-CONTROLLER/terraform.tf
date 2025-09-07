terraform {
  backend "s3" {
    bucket = "fabric-iac"
    key    = "alb/terraform.tfstate"
    region = "us-east-1"
  }
}