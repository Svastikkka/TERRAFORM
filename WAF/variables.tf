variable "access_key" {
  type        = string
  description = "value of AWS access key"
}

variable "secret_key" {
  type        = string
  description = "value of AWS secret key"
}

variable "session_token" {
  type        = string
  description = "AWS MFA session token value"
}

variable "region" {
  type        = string
  description = "value of region"
  default     = "us-east-1"
}

variable "cost_tag" {
  type        = string
  description = "AWS cost tag for reporting"
  default     = "Fabric"
}

variable "web_acl_name" {
  type    = string
  default = "fabric"
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
  default = "fabric-sso"
}

variable "vpn_ipsets_name" {
  type = string
  description = "name for the vpn sets used for WAF rule"
  default = "fabric-vpn-ipset"
}

variable "vpn_ipsets" {
  type = list(string)
  default = ["52.44.24.254/32", "54.235.89.147/32", "3.95.3.34/32", "3.221.93.236/32", "140.82.201.129/32", "44.195.179.85/32","35.171.87.178/32","15.207.188.167/32","3.108.174.44/32", "44.194.182.209/32", "34.231.193.48/32"]
}

variable "vanta_user_data" {
  type = bool
  default = false
}

variable "vanta_owner_email" {
  type = string
  default = "FabricTeam@digite.com "
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