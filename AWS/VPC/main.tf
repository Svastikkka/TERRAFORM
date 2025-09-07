module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "3.19.0"
  name                 = "${var.cluster_name}-${var.environment}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets      = var.private_subnets_cidr
  public_subnets       = var.public_subnets_cidr
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}-${var.eks_cluster_deployment_version}" = "shared"
    "kubernetes.io/role/elb"                                       = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}-${var.eks_cluster_deployment_version}" = "shared"
    "kubernetes.io/role/internal-elb"                              = "1"
    "karpenter.sh/discovery"                                       = "${var.cluster_name}-${var.environment}-${var.eks_cluster_deployment_version}"
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}-${var.eks_cluster_deployment_version}" = "shared"
    Environment                                                    = var.environment
    Cost                                                           = var.cost_tag
  }

}

module "vpc-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  create  = true

  name        = "${var.cluster_name}-${var.environment}-security-group"
  description = "Security group for Fabric VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = var.ingress_rules
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
  tags = {
    Name        = "${var.cluster_name}-security-group"
    Environment = var.environment
    Cost        = var.cost_tag
    "karpenter.sh/discovery"  = "${var.cluster_name}-${var.environment}-${var.eks_cluster_deployment_version}"
  }
}
