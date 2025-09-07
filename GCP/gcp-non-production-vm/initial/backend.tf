terraform {
  backend "s3" {
    bucket         = "voicing-infrastructure"
    key            = "gcp-non-production-vm/initial/terraform.tfstate"
    region         = "us-east-1"
    // dynamodb_table = "terraform-locks"  # We can for locking
    encrypt        = false
  }
}
