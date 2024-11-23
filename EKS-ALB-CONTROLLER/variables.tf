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

variable "environment" {
  type        = string
  description = "Environment Name"
  default     = "dev"
}

variable "bucket_versioning" {
  type        = bool
  description = "Bucket versioning"
  default     = false
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster Name"
  default     = "fabric"
}

variable "cost_tag" {
  type        = string
  description = "AWS cost tag for reporting"
  default     = "Fabric"
}

variable "vanta_owner_email" {
  type        = string
  description = "email address for vanta notifications"
  default     = "FabricTeam@digite.com"
}

# variable "vanta_user_data" {
#   type        = bool
#   description = "Vanta contains user data"
#   default     = true
# }

# variable "vanta_user_data_stored" {
#   type        = string
#   description = "Vanta stored user data"
#   default     = "User Official Emails and Company Confidential Projects Data"
# }

variable "vanta_non_prod" {
  type        = bool
  description = "Toggle mark env as non prod for vanta"
  default     = true
}

variable "alb_service_account_name" {
  type        = string
  description = "name of the service account for ALB"
  default     = "aws-load-balancer-controller"
}

variable "alb_ingress_policy_name" {
  type        = string
  description = "IAM Policy for AWS Load Balancer Controller"
  default     = "FabricAWSLoadBalancerControllerIAMPolicy"
}

variable "accountId" {
  type    = string
  default = "127311923021"
}

variable "subOrgAccountId" {
  type    = string
  default = "406059358747"
}

variable "alblogs_s3_prefix" {
  type        = list(string)
  description = "List of s3 prefixes for all the albs in which their log files will be created"
  default     = ["alb", "nifi-alb", "nifiregistry-alb", "auth-alb", "internal-alb", "ups-internal-alb", "oauth", "srv", "retro"]
}