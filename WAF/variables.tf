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
  description = "AWS cost tag for reporting"
  default     = "Testing"
}

variable "web_acl_name" {
  type    = string
  default = "Testing-UAT"
}
variable "web_acl_scope" {
  type    = string
  default = "REGIONAL"
}
variable "rule_name1" {
  type    = string
  default = "UAT-Rate-Limit"
}
variable "rule_name2" {
  type    = string
  default = "Allowed-Apps"
}
variable "alb" {
  type    = string
  default = "testing-alb-uat"  # ALB NAME
}

variable "vpn_ipsets_name" {
  type = string
  description = "name for the vpn sets used for WAF rule"
  default = "testing-uat-vpn-ipset"
}

variable "vpn_ipsets" {
  type = list(string)
  default = ["52.44.24.253/32", "54.235.89.33/32", "3.95.3.34/32", "3.221.93.236/32", "140.82.201.119/32", "44.195.179.85/32","35.171.87.178/32","15.207.118.167/32","3.108.174.44/32", "44.194.182.229/32", "34.231.193.48/32"]  # Rundom CIDRs Values r changed
}

variable "vanta_user_data" {
  type = bool
  default = false
}

variable "vanta_owner_email" {
  type = string
  default = "manshu.15jics727@jietjodhpur.ac.in"
}

variable "vanta_non_prod" {
  type = string
  default = true
}

variable "environment" {
  type = string
  default = "dev"
}

variable "waf_rate_limit" {
  type = number
  default = 1000
}

variable "auth_rule_name" {
  type = string
  default = "Auth-Fabric-UAT"
}

variable "auth_alb" {
  type    = string
  default = "testing-fabric-alb" # ALB NAME
}
