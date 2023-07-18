data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "fabric-iacv2"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
data "aws_iam_roles" "fargate_profile_roles" {
  name_regex = "fargate-profile-.*"
}

module "eks-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.12.0"
  cluster_name    = "${var.eks_cluster_name}-${var.environment}"
  cluster_version = var.eks_cluster_version
  subnet_ids      = flatten([data.terraform_remote_state.db.outputs.private_subnets])
  # cluster_enabled_log_types     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  # cluster_log_retention_in_days = var.cluster_log_retention_days
  create_cloudwatch_log_group = false
  tags = {
    Name        = var.eks_cluster_name
    Environment = var.environment
    "karpenter.sh/discovery"  = "fabric-dev"
  }

  vpc_id = data.terraform_remote_state.db.outputs.vpc_id

  cluster_endpoint_public_access_cidrs = var.cluster_allowed_cidrs
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_security_group_id            = data.terraform_remote_state.db.outputs.security_group_id

  # aws-auth configmap
  create_kms_key            = false
  cluster_encryption_config = {}
  # create_aws_auth_configmap = true
  # manage_aws_auth_configmap = true
  # aws_auth_fargate_profile_pod_execution_role_arns = [for role in data.aws_iam_roles.fargate_profile_roles.arns : role]
  # aws_auth_roles = var.aws_kube_roles_mapping
  # aws_auth_users = var.aws_kube_users_mapping
}

module "fargate-profile" {
  source       = "terraform-aws-modules/eks/aws//modules/fargate-profile"
  version      = "19.12.0"
  cluster_name = module.eks-cluster.cluster_name
  create_iam_role = false
  iam_role_arn    = aws_iam_role.fargate_role.arn

  subnet_ids   = flatten([data.terraform_remote_state.db.outputs.private_subnets])


  for_each  = { for profile in var.fargate_profiles_list : profile.name => profile }
  name      = each.value.name
  selectors = each.value.selectors

  tags = {
    Name        = var.eks_cluster_name
    Environment = var.environment
  }
}

module "fabric-services" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "19.12.0"

  name            = "${var.eks_cluster_name}-services"
  cluster_name    = module.eks-cluster.cluster_name
  cluster_version = module.eks-cluster.cluster_version
  create_iam_role = false
  iam_role_arn    = aws_iam_role.nodegroup_role.arn

  subnet_ids = flatten([data.terraform_remote_state.db.outputs.private_subnets])

  cluster_primary_security_group_id = module.eks-cluster.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks-cluster.cluster_security_group_id]

  min_size     = 1
  max_size     = 2
  desired_size = 1

  instance_types     = ["t3.large"]
  capacity_type      = "ON_DEMAND"
  labels = {
    NodeGroups = "${var.eks_cluster_name}-services"
  }

  tags = {
    Name        = var.eks_cluster_name
    Environment = var.environment
    "karpenter.sh/discovery"  = "fabric-dev"
  }
}

module "fabric-apps" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "19.12.0"

  name            = "${var.eks_cluster_name}-apps"
  cluster_name    = module.eks-cluster.cluster_name
  cluster_version = module.eks-cluster.cluster_version

  create_iam_role = false
  iam_role_arn    = aws_iam_role.nodegroup_role.arn

  subnet_ids = flatten([data.terraform_remote_state.db.outputs.private_subnets])

  cluster_primary_security_group_id = module.eks-cluster.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks-cluster.cluster_security_group_id]

  min_size     = 1
  max_size     = 2
  desired_size = 1

  instance_types     = ["t3.large"]
  capacity_type      = "ON_DEMAND"
  labels = {
    NodeGroups = "${var.eks_cluster_name}-apps"
  }

  tags = {
    Name        = var.eks_cluster_name
    Environment = var.environment
  }
}

# Create Namespace in EKS cluster.

resource "kubernetes_namespace" "fabric-namespaces" {
  count = length(var.kubernetes_namespaces)
  metadata {
    annotations = {
      name = element(var.kubernetes_namespaces, count.index)
    }
    labels = {
      Environment = var.environment
    }
    name = element(var.kubernetes_namespaces, count.index)
  }
  depends_on = [module.eks-cluster]
}

# Aws eks addons
resource "aws_eks_addon" "addons" {
  count             = length(var.addons)
  addon_name        = var.addons[count.index].name
  addon_version     = var.addons[count.index].version
  cluster_name      = module.eks-cluster.cluster_name
  resolve_conflicts = var.addons[count.index].conflict
  depends_on        = [module.eks-cluster, module.fabric-services]

  tags = {
    Name        = var.addons[count.index].tag_name
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "ebs-iam-trust-policy" {

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks-cluster.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.kube_namespace}:ebs-csi-controller-sa"]
    }
    principals {
      identifiers = [module.eks-cluster.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "ebs-iam-role" {
  assume_role_policy = data.aws_iam_policy_document.ebs-iam-trust-policy.json
  name               = "${var.eks_cluster_name}-ebs-service-account-role"
}

resource "aws_iam_role_policy_attachment" "ebs-iam-role-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs-iam-role.name
}

resource "kubernetes_storage_class" "eks-efs-storage-class" {
  metadata {
    name = "eks-efs-storage-class"
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "eks-ebs-storage-class" {
  metadata {
    name = "eks-ebs-storage-class"
  }
  parameters = {
    type = "gp3"
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_service_account" "ebs-service-account" {
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = var.kube_namespace
    labels = {
      "app.kubernetes.io/name" = "ebs-csi-controller-sa"
    }
    annotations = {
      # This annotation is only used when running on EKS which can use IAM roles for service accounts.
      "eks.amazonaws.com/role-arn" = aws_iam_role.ebs-iam-role.arn
    }
  }
  depends_on = [
    aws_iam_role_policy_attachment.ebs-iam-role-policy-attachment
  ]
}

# Kapentor
data "aws_iam_policy_document" "karpentor-controller-iam-trust-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks-cluster.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }
    principals {
      identifiers = [module.eks-cluster.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

data "aws_iam_policy_document" "karpentor-iam-trust-policy" {
  version = "2012-10-17"
  statement {
    sid    = "EKSNodeAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "KarpenterInstanceNodeRole" {
  assume_role_policy = data.aws_iam_policy_document.karpentor-iam-trust-policy.json
  name               = "KarpenterInstanceNodeRole"
}

resource "aws_iam_instance_profile" "KarpenterInstanceNodeProfile" {
  name = "KarpenterInstanceNodeRole"
  role = aws_iam_role.KarpenterInstanceNodeRole.name
}

resource "aws_iam_role_policy_attachment" "karpentor-iam-role-policy-attachment" {
  count = length(var.KarpenterInstanceNodeRole)
  policy_arn = var.KarpenterInstanceNodeRole[count.index]
  role       = aws_iam_role.KarpenterInstanceNodeRole.name
}

resource "aws_iam_role" "KarpenterControllerRole" {
  assume_role_policy = data.aws_iam_policy_document.karpentor-controller-iam-trust-policy.json
  name               = "KarpenterControllerRole"
}

resource "aws_iam_role_policy" "KarpenterControllerRole-iam-role-policy-attachment" {
  policy = file("${path.module}/controller-policy.json")
  role   = aws_iam_role.KarpenterControllerRole.name
}

# resource "kubernetes_service_account" "karpentor-service-account" {
#   metadata {
#     name      = "karpenter"
#     namespace = "karpenter"
#     labels = {
#       "app.kubernetes.io/name" = "karpenter"
#     }
#     annotations = {
#       # This annotation is only used when running on EKS which can use IAM roles for service accounts.
#       "eks.amazonaws.com/role-arn" = aws_iam_role.KarpenterControllerRole.arn
#     }
#   }
#   depends_on = [
#     aws_iam_role_policy.KarpenterControllerRole-iam-role-policy-attachment
#   ]
# }

# Node Group
data "aws_iam_policy_document" "nodegroup_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "nodegroup_role" {
  assume_role_policy = data.aws_iam_policy_document.nodegroup_trust_policy.json
  name               = "Fabric-NodeGroup-Role"
}

resource "aws_iam_role_policy_attachment" "nodegroup-iam-role-policy-attachment" {
  count = length(var.nodegroup_role_policies)
  policy_arn = var.nodegroup_role_policies[count.index]
  role       = aws_iam_role.nodegroup_role.name
}

# Fargate
data "aws_iam_policy_document" "fargate_trust_policy" {
  version = "2012-10-17"

  statement {
    sid       = ""
    effect    = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
    actions   = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "fargate_role" {
  assume_role_policy = data.aws_iam_policy_document.fargate_trust_policy.json
  name               = "Fabric-Fargate-Role"
}

resource "aws_iam_role_policy_attachment" "fargate-iam-role-policy-attachment" {
  count = length(var.fargate_role_policies)
  policy_arn = var.fargate_role_policies[count.index]
  role       = aws_iam_role.fargate_role.name
}

# AWS AUTH
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/managed-by" = "Terraform"
      "terraform.io/module"          = "terraform-aws-modules.eks.aws"
    }
  }

  data = {
    mapAccounts = "[]"
    mapRoles = <<EOF
      - groups:
        - system:bootstrappers
        - system:nodes
        - system:node-proxier
        rolearn: ${aws_iam_role.fargate_role.arn}
        username: system:node:{{SessionName}}
      - groups:
        - system:bootstrappers
        - system:nodes
        rolearn: ${aws_iam_role.nodegroup_role.arn}
        username: system:node:{{EC2PrivateDNSName}}
      - groups:
        - system:bootstrappers
        - system:nodes
        rolearn: arn:aws:iam::988847430543:role/KarpenterInstanceNodeRole
        username: system:node:{{EC2PrivateDNSName}}
      - groups:
        - test_aws_admin_access
        rolearn: arn:aws:iam::988847430543:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_005b7f535a4f560c
        username: AWSReservedSSO_AdministratorAccess_005b7f535a4f560c
    EOF
    mapUsers = <<EOF
      - groups:
        - developer
        rolearn: arn:aws:iam::988847430543:user/swiftalk-eks-deployer
        username: swiftalk-eks-deployers
    EOF
  }
  depends_on = [
    module.eks-cluster
  ]
}