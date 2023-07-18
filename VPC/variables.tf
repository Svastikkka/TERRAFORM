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
  default     = "Fabric"
}

variable "cluster_name" {
  type        = string
  description = "name for the EKS cluster we're deploying"
  default     = "fabric"
}

# variable "vpc_name" {
#   type        = string
#   description = "Name tag for VPC"
#   default = "vpc"
# }

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block range"
  default     = "10.13.0.0/16"
}
variable "public_subnets_cidr" {
  type        = list(string)
  description = "public subnets cidr blocks range"
  default     = ["10.13.2.0/24", "10.13.4.0/24", "10.13.6.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "private subnets cidr blocks range"
  default     = ["10.13.1.0/24", "10.13.3.0/24", "10.13.5.0/24"]
}

variable "environment" {
  type        = string
  description = "the environment this cluster belongs"
  default     = "dev"
}

variable "ingress_rules" {
  type        = list(map(string))
  description = "VPC Default Security Group Ingress Rules"
  default = [
    {
      cidr_blocks = "52.44.24.254/32"
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Workspace-NAT1"
    },
    {
      cidr_blocks = "54.235.89.147/32"
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Workspace-NAT2"
    },
    {
      cidr_blocks = "10.0.0.0/16"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "EFS mount from fabric VPC"
    },

    {
      cidr_blocks = "54.235.42.147/32"
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "DevOps Services Cluster CIDRS"
    },
    {
      cidr_blocks = "54.152.198.97/32"
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "DevOps Services Cluster CIDRS"
    },
    {
      cidr_blocks = "18.212.88.112/32"
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "DevOps Services Cluster CIDRS"
    },
    {
      cidr_blocks = "10.41.0.0/16",
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "cato vpn"
    },
    {
      cidr_blocks = "140.82.201.129/32",
      from_port   = 28980
      to_port     = 28980
      protocol    = "tcp"
      description = "CATO-Public"
    },
    {
      cidr_blocks = "140.82.201.129/32"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "cato vpn allow for nifi uat VM"
    },
  ]
}