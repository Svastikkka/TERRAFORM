data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "fabric-iac"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
#S3 Bucket for ALB
resource "aws_s3_bucket" "alb_logs_bucket" {
  acl    = "private"
  bucket = "${var.eks_cluster_name}-${var.environment}-eks-logs"

  versioning {
    enabled = var.bucket_versioning
  }

  tags = {
    Name                  = "${var.eks_cluster_name}-${var.environment}-eks-logs"
    Cost                  = var.cost_tag
    Environment           = var.environment
    VantaContainsUserData = false
    VantaOwner            = var.vanta_owner_email
    VantaNonProd          = var.vanta_non_prod
    VantaDescription      = "Ingress ALB logs storage"
  }
}

locals {
  alblogs_s3_prefix_list = [for prefix in var.alblogs_s3_prefix : "arn:aws:s3:::${var.eks_cluster_name}-${var.environment}-eks-logs/${prefix}/AWSLogs/${var.subOrgAccountId}/*"]
}

data aws_iam_policy_document "alb_ingress_s3_logs_policy" {

  statement {
    effect =  "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${var.accountId}:root"]
    }
    actions = [ "s3:PutObject" ]
    resources = local.alblogs_s3_prefix_list
  }

  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = ["s3:PutObject"]
    resources = local.alblogs_s3_prefix_list
    condition  {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.eks_cluster_name}-${var.environment}-eks-logs"]
  }
}

resource "aws_s3_bucket_policy" "alb_logs_bucket_policy" {
  bucket = aws_s3_bucket.alb_logs_bucket.id

  policy = data.aws_iam_policy_document.alb_ingress_s3_logs_policy.json

  depends_on = [
    aws_s3_bucket.alb_logs_bucket
  ]
}

resource "aws_s3_bucket_public_access_block" "logs_bucket_public_access_block" {

  bucket = aws_s3_bucket.alb_logs_bucket.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true

  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true

  # Block new public bucket policies
  block_public_policy = true

  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.alb_logs_bucket
  ]
}

## ALB Ingress ##
resource "aws_iam_policy" "alb-ingress-policy" {
  name        = var.alb_ingress_policy_name
  description = "Policy for the ALB Ingress"

  policy     = file("alb/iam-policy.json")
  # depends_on = [module.eks-cluster]
}

data "aws_iam_policy_document" "alb-ingress-iam-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:${var.alb_service_account_name}"]
    }

    principals {
      identifiers = [data.terraform_remote_state.eks.outputs.cluster_oidc_provider_arn]
      type        = "Federated"
    }
  }
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "alb-service-account-iam-role" {
  assume_role_policy = data.aws_iam_policy_document.alb-ingress-iam-assume-role-policy.json
  name               = "${var.eks_cluster_name}-${var.environment}-alb-ingress-controller-service-account-role"
}

resource "aws_iam_role_policy_attachment" "alb-ingress-policy-attachment" {
  role       = aws_iam_role.alb-service-account-iam-role.name
  policy_arn = aws_iam_policy.alb-ingress-policy.arn
}

resource "kubernetes_secret" "alb-ingress-service-account-secret" {
  metadata {
    name      = var.alb_service_account_name
    namespace = "kube-system"

    annotations = {
      "kubernetes.io/service-account.name" = "aws-load-balancer-controller"
    }
  }
  type = "kubernetes.io/service-account-token"

  depends_on = [ kubernetes_service_account.alb-ingress-service-account ]
}

resource "kubernetes_service_account" "alb-ingress-service-account" {
  metadata {
    name      = var.alb_service_account_name
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = var.alb_service_account_name
    }
    annotations = {
      # This annotation is only used when running on EKS which can use IAM roles for service accounts.
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb-service-account-iam-role.arn
    }
  }
  secret {
    name = "aws-load-balancer-controller"
  }
}
