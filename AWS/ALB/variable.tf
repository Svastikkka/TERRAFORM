# Configure the AWS Provider
variable "region" {
    type = string
    default = "us-east-2"
}
variable "availabilityZone1" {
    type = string
    default = "us-east-2a"
}
variable "availabilityZone2" {
    type = string
    default = "us-east-2b"
}
variable "app_instance_count" {
    default = 1
}
variable "app_ec2_device_names" {
  default = [
    "/dev/sdd"
  ]
}
variable "db_instance_count" {
    default = 1
}
variable "db_ec2_device_names" {
  default = [
    "/dev/sdd"
  ]
}

variable "app_ebs_volume_size" {
   default = 8
}
variable "db_ebs_volume_size" {
   default = 8
}
variable "app_root_volume_size" {
   default = 8
}
variable "db_root_volume_size" {
   default = 30
}
variable "app_root_volume_type"{
    default = "gp2"
}
variable "db_root_volume_type"{
    default = "gp2"
}
variable "app_ebs_volume_type"{
    default = "gp2"
}
variable "db_ebs_volume_type"{
    default = "gp2"
}
variable "ami" {
    type=map
    default = {
        "us-east-2-ubuntu"  = "ami-00399ec92321828f5"
        "us-east-2-windows" = "ami-0b697c4ae566cad55"
    }
}
variable "instance_type" {
    type = map
    default = {
        "micro"  = "t2.micro"
    }
}
variable "instanceTenancy" {
    type = string
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    type = string
    default = "10.0.0.0/16"
}
variable "subnetCIDRblock1" {
    type = string
    default = "10.0.1.0/24"
}
variable "subnetCIDRblock2" {
    type = string
    default = "10.0.2.0/24"
}
variable "destinationCIDRblock" {
    type = string
    default = "0.0.0.0/0"
}
variable "mapPublicIP" {
    default = true
}