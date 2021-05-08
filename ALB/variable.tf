# Configure the AWS Provider
variable "region" {
    default = "us-east-2"
}
variable "availabilityZone1" {
     default = "us-east-2a"
}
variable "availabilityZone2" {
     default = "us-east-2b"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "subnetCIDRblock1" {
    default = "10.0.1.0/24"
}
variable "subnetCIDRblock2" {
    default = "10.0.2.0/24"
}
variable "subnetCIDRblock3" {
    default = "10.0.3.0/24"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "mapPublicIP" {
    default = true
}