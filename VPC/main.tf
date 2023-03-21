module "vpc" {
  source                        = "terraform-aws-modules/vpc/aws"
  version                       = "3.4.0"
  name                          = "fabric-dev-vpc"
  cidr                          = "176.24.0.0/16"
  azs                           = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets               = ["176.24.1.0/24", "176.24.3.0/24", "176.24.5.0/24"]
  public_subnets                = ["176.24.2.0/24", "176.24.4.0/24", "176.24.6.0/24"]
  enable_nat_gateway            = true
  single_nat_gateway            = true
  enable_dns_hostnames          = true

  public_subnet_tags = {
    "kubernetes.io/cluster/fabric-dev" = "shared"
    "kubernetes.io/role/elb"           = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/fabric-dev" = "shared"
    "kubernetes.io/role/internal-elb"  = "1"
  }

  tags = {
    "kubernetes.io/cluster/fabric-dev" = "shared"
    Environment                        = "DEV"
    Cost                               = "Fabric"
  }

}

module "vpc-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"
  create  = true

  name        = "fabric-dev-security-group"
  description = "Security group for Fabric VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
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
      description = "EFS mount from Fabric VPC"
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
      from_port        = 28980
      to_port          = 28980
      protocol         = "tcp"
      description      = "CATO-Public"
    },
    {
      cidr_blocks = "140.82.201.129/32"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      description      = "cato vpn allow for nifi uat VM"
    },
  ]
  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Ingress with Self"
    }
  ] 
  egress_with_cidr_blocks = [{
    cidr_blocks = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }]
}
