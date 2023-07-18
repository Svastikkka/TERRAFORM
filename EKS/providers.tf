provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
  token = var.session_token
}

locals {
  cluster_name = try(module.eks-cluster.cluster_name, null)
}

data "aws_eks_cluster_auth" "fabric-cluster" {
  depends_on = [
    module.eks-cluster.eks_managed_node_groups
  ]
  name = "${var.eks_cluster_name}-${var.environment}"
}

provider "kubernetes" {
  host = module.eks-cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks-cluster.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.fabric-cluster.token
}

provider "helm" {
  kubernetes {
    host = module.eks-cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token = data.aws_eks_cluster_auth.fabric-cluster.token
  }
}
