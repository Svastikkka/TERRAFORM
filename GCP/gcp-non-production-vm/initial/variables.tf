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

variable "instance_name" {
  type    = string
  default = "demo-vm"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "disk_image" {
  type    = string
  default = "debian-cloud/debian-11"
}

variable "disk_size" {
  type    = number
  default = "100"
}

variable "startup_script_path" {
  description = "Path to a local startup script"
  type        = string
}

variable "tags" {
  description = "Give Tags to you GCP vm"
  type        = list(string)
}
