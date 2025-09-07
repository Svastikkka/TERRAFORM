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

variable "db_instance_name" {
  type    = string
  default = "demo-vm"
}

variable "tier" {
  description = "Machine tier for Cloud SQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable "ipv4_enabled" {
  description = "Enable public IPv4 for the Cloud SQL instance"
  type        = bool
  default     = true
}

variable "activation_policy" {
  description = "Whether the instance should always be active or on-demand"
  type        = string
  default     = "ALWAYS" # Options: ALWAYS, NEVER, ON_DEMAND
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "Disk type for the database. Options: PD_SSD or PD_HDD"
  type        = string
  default     = "PD_SSD"
}

variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "POSTGRES_15"
}

variable "db_name" {
  description = "Default database name"
  type        = string
  default     = "appdb"
}

variable "db_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "pgadmin"
}

variable "db_password" {
  description = "Password for default PostgreSQL user"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Give Tags to you GCP vm"
  type        = list(string)
}
