data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = var.remote_backend
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}

# Create Policy and IAM role needed for vault to access KMS key
data "aws_iam_policy_document" "kms-key-access-policy-doc" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "iam:GetRole",
      "iam:GetInstanceProfile",
      "iam:GetUser"
    ]
    resources = [
      "arn:aws:iam::${var.sub_org_account_id}:user/*",
      "arn:aws:iam::${var.sub_org_account_id}:role/*",
      "arn:aws:iam::${var.sub_org_account_id}:instance-profile/*"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "kms-key-access-policy" {
  name        = var.kms_key_policy_name
  description = "Policy for accessing KMS key"
  policy      = data.aws_iam_policy_document.kms-key-access-policy-doc.json
  tags = {
    Name        = "${var.eks_cluster_name}-${var.environment}-kms-access-policy"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "kms-vault-iam-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${data.terraform_remote_state.eks.outputs.cluster_oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.vault_namespace}:${var.vault_service_account_name}"]
    }

    principals {
      identifiers = [data.terraform_remote_state.eks.outputs.cluster_oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "kms-vault-service-account-iam-role" {
  assume_role_policy = data.aws_iam_policy_document.kms-vault-iam-assume-role-policy.json
  name               = "${var.eks_cluster_name}-${var.environment}-kms-vault-service-account-role"
  tags = {
    Name        = "${var.eks_cluster_name}-${var.environment}-kms-vault-service-account-role"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "kms-access-policy-attachment" {
  role       = aws_iam_role.kms-vault-service-account-iam-role.name
  policy_arn = aws_iam_policy.kms-key-access-policy.arn
}

# Create KMS Key for vault
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = var.iam_user_arn_list
    }
  }

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = var.iam_user_arn_list
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.kms-vault-service-account-iam-role.arn]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.kms-vault-service-account-iam-role.arn]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

resource "aws_kms_key" "kms_key" {
  description              = var.kms_key_description
  customer_master_key_spec = var.key_spec
  is_enabled               = var.is_kmskey_enabled
  enable_key_rotation      = var.is_key_rotation_enabled

  tags = {
    Name        = var.kms_key_name
    Cost        = var.cost_tag
    Environment = var.environment
  }

  policy = data.aws_iam_policy_document.kms_key_policy.json
}

resource "aws_kms_alias" "kms_key_alias" {
  target_key_id = aws_kms_key.kms_key.key_id
  name          = "alias/${var.kms_key_name}"
}
