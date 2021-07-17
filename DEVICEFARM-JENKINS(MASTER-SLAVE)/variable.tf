# Configure the AWS Provider
variable "region" {
    type = string
    default = "us-east-2"
}

variable "access_key"{
	type = string
	description = "value of access key"	
}

variable "secret_key"{
	type = string
	description = "value of secret key"	
}


#----------------------------------VPC CONFIGURATION-----------------------------#
variable "vpcCIDRblock" {
    type = string
    default = "10.0.0.0/16"
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

#----------------------------------SUBNET CONFIGURATION-----------------------------#

variable "availabilityZone" {
    type = string
    default = "us-east-2a"
}
variable "subnetCIDRblock" {
    type = string
    default = "10.0.1.0/24"
}
variable "mapPublicIP" {
    default = true
}
#----------------------------------EC2 CONFIGURATION------------------------------#
variable "app_db_ami" {
    type = string
	default = "ami-00399ec92321828f5"
}
variable "app_db_count" {
    default = 1
}
variable "app_db_instance_type"{
	default = "t2.micro"
}


variable "desknow_roundcube_ami" {
    type = string
	default = "ami-00399ec92321828f5"
}
variable "desknow_roundcube_count" {
    default = 1
}
variable "desknow_roundcube_instance_type"{
	default = "t2.micro"
}


variable "slave_ami" {
    type = string
	default = "ami-00399ec92321828f5"
}
variable "slave_count" {
    default = 1
}
variable "slave_instance_type"{
	default = "t2.micro"
}


variable "master_ami" {
    type = string
	default = "ami-00399ec92321828f5"
}
variable "master_count" {
    default = 1
}
variable "master_instance_type"{
	default = "t2.micro"
}
