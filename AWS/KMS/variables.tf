variable "access_key" {
  type        = string
  description = "value of AWS access key"
}
#export TF_VAR_access_key=""

variable "secret_key" {
  type        = string
  description = "value of AWS secret key"
}
#export TF_VAR_secret_key=""

variable "session_token" {
  type        = string
  description = "AWS MFA session token value"
}
#export TF_VAR_session_token=""

variable "region" {
  type        = string
  description = "value of region"
  default     = "us-east-1"
}

variable "cost_tag" {
  type        = string
  description = "Cost tag for reporting"
  default     = "Fabric"
}

variable "environment" {
  type        = string
  description = "Environment name for instance"
  default     = "dev"
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster Name"
  default     = "fabric"
}

# variable "vanta_email" {
#   type        = string
#   description = "email id for vanta alerts"
#   default     = "st.engg@digite.com"
# }

# variable "vanta_non_prod" {
#   type        = bool
#   description = "toggle mark as non production for Vanta"
#   default     = true
# }

# variable "vanta_description" {
#   type        = string
#   description = "A description about the AWS Resource for vanta"
#   default     = "Bastion Host"
# }

variable "remote_backend" {
  type    = string
  default = "fabric-iac"
}

variable "iam_user_arn_list" {
  type        = list(string)
  description = "List of IAM user or role ARNs that will have administrator access of the kms key"
  default     = ["arn:aws:iam::406059358747:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Admin_Restricted_04835747ed2394fc", "arn:aws:iam::406059358747:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_f19c4fdc17ea2ad6"]
}

variable "key_spec" {
  type        = string
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair"
  default     = "SYMMETRIC_DEFAULT"
}

variable "is_kmskey_enabled" {
  type        = bool
  description = "Specifies whether the key is enabled or not. Defaults to true"
  default     = true
}

variable "kms_key_name" {
  type        = string
  description = "Name of the AWS KMS key to be created for vault auto-unseal"
  default     = "fabric-dev-kubevault-kms-key"
}

variable "kms_key_description" {
  type        = string
  description = "Description about the kms key resource"
  default     = "Used for vault auto-unseal using AWS KMS"
}

variable "is_key_rotation_enabled" {
  type        = bool
  description = "Specifies whether the key rotation should be enabled or not. Defaults to false"
  default     = false
}

variable "kms_key_policy_name" {
  type        = string
  description = "IAM Policy name for AWS KMS key access"
  default     = "FabricDevKMSAccessIAMPolicy"
}

variable "vault_namespace" {
  type        = string
  description = "Namespace where the vault is deployed"
  default     = "vault"
}

variable "vault_service_account_name" {
  type        = string
  description = "name of the vault service account"
  default     = "vault"
}

variable "sub_org_account_id" {
  type    = string
  default = "406059358747"
}
