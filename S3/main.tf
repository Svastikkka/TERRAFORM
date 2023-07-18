
resource "aws_s3_bucket" "fabric_iac" {
  bucket = "fabric-iac"

  tags = {
    Name                  = "fabric-iac"
    Cost                  = "Fabric"
    Environment           = "dev"
    VantaContainsUserData = false
    VantaOwner            = "st.engg@digite.com"
    VantaNonProd          = true
    VantaDescription      = "Storing IaC tfstate files"
  }
}

resource "aws_s3_bucket_acl" "fabric_iac_acl" {
  bucket = aws_s3_bucket.fabric_iac.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "fabric_iac_versioning" {
  bucket = aws_s3_bucket.fabric_iac.id
  versioning_configuration {
    status = "Enabled"
  }
}