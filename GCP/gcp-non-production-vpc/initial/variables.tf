variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "network" {
  type    = string
  default = "default"
}

variable "mode" {
  type    = bool
  default = false
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "custom-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "custom-subnet"
}

variable "subnet_ip_range" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "tags" {
  description = "Give Tags to you GCP VPC"
  type        = list(string)
}
