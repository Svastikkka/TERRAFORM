data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "fabric-iac"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "efs-access-security-group" {
  name        = "${var.eks_cluster_name}-efs-access-security-group"
  description = "Security group to allow access to EFS from public and private subnets"
  vpc_id      = data.terraform_remote_state.db.outputs.vpc_id
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  ingress {
    cidr_blocks = flatten([data.terraform_remote_state.db.outputs.public_cidrs, data.terraform_remote_state.db.outputs.private_cidrs])
    from_port   = 0
    to_port     = 2049
    protocol    = "tcp"
    self        = true
  }
  tags = {
    Name                  = "${var.eks_cluster_name}-efs-access-security-group"
    Cost                  = var.cost_tag
    Environment           = var.environment
    VantaOwner            = var.vanta_owner_email
    VantaNonProd          = var.vanta_non_prod
    VantaDescription      = "Security group for Fabric efs"
  }
}


# resource "aws_iam_policy" "fabric-efs-csi-driver-policy" {
#   name        = "FabricEFSCSIDriverPolicy-${var.kube_namespace}"
#   description = "Fabric EFS CSI Driver Policy"

#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "elasticfilesystem:DescribeAccessPoints",
#           "elasticfilesystem:DescribeFileSystems"
#         ],
#         "Resource" : "*"
#       },
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "elasticfilesystem:CreateAccessPoint"
#         ],
#         "Resource" : "*",
#         "Condition" : {
#           "StringLike" : {
#             "aws:RequestTag/efs.csi.aws.com/cluster" : "true"
#           }
#         }
#       },
#       {
#         "Effect" : "Allow",
#         "Action" : "elasticfilesystem:DeleteAccessPoint",
#         "Resource" : "*",
#         "Condition" : {
#           "StringEquals" : {
#             "aws:ResourceTag/efs.csi.aws.com/cluster" : "true"
#           }
#         }
#       }
#     ]
#   })
# }

# data "aws_iam_policy_document" "efs-iam-assume-role-policy" {

#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"
#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.swiftalk-main.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:${var.kube_namespace}:${var.efs_service_account_name}"]
#     }
#     principals {
#       identifiers = [aws_iam_openid_connect_provider.swiftalk-main.arn]
#       type        = "Federated"
#     }
#   }
#   depends_on = [
#     aws_iam_policy.fabric-efs-csi-driver-policy
#   ]
# }

# resource "aws_iam_role" "efs-service-account-iam-role" {
#   assume_role_policy = data.aws_iam_policy_document.efs-iam-assume-role-policy.json
#   name               = "efs-service-account-role"
# }

# resource "aws_iam_role_policy_attachment" "efs-csi-driver-policy-attachment" {
#   role       = aws_iam_role.efs-service-account-iam-role.name
#   policy_arn = aws_iam_policy.fabric-efs-csi-driver-policy.arn
# }

# resource "kubernetes_service_account" "efs-service-account" {
#   metadata {
#     name      = var.efs_service_account_name
#     namespace = var.kube_namespace
#     labels = {
#       "app.kubernetes.io/name" = "${var.efs_service_account_name}"
#     }
#     annotations = {
#       # This annotation is only used when running on EKS which can use IAM roles for service accounts.
#       "eks.amazonaws.com/role-arn" = aws_iam_role.efs-service-account-iam-role.arn
#     }
#   }
#   depends_on = [
#     aws_iam_role_policy_attachment.efs-csi-driver-policy-attachment
#   ]
# }

#  WE DON'T NEED VAULT EFS SA
# resource "kubernetes_service_account" "vault-efs-service-account" {
#   metadata {
#     name      = "vault-efs-serviceaccount"
#     namespace = "vault"
#     labels = {
#       "app.kubernetes.io/name" = "vault-efs-serviceaccount"
#     }
#     annotations = {
#       # This annotation is only used when running on EKS which can use IAM roles for service accounts.
#       "eks.amazonaws.com/role-arn" = aws_iam_role.efs-service-account-iam-role.arn
#     }
#   }
#   depends_on = [
#     aws_iam_role_policy_attachment.efs-csi-driver-policy-attachment
#   ]
# }

# resource "kubernetes_role" "kube-efs-role" {
#   metadata {
#     name = "kube-efs-role"
#     labels = {
#       "name" = "kube-efs-role"
#     }
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["persistentvolumeclaims", "persistentvolumes"]
#     verbs      = ["create", "get", "list", "update", "watch", "patch"]
#   }

#   rule {
#     api_groups = ["", "storage"]
#     resources  = ["nodes", "pods", "events", "csidrivers", "csinodes", "csistoragecapacities", "storageclasses"]
#     verbs      = ["get", "list", "watch"]
#   }
#   depends_on = [aws_iam_role_policy_attachment.alb-ingress-policy-attachment]
# }

# resource "kubernetes_role_binding" "efs-role-binding" {
#   depends_on = [
#     kubernetes_service_account.efs-service-account
#   ]
#   metadata {
#     name = "kube-efs-role-binding"
#     labels = {
#       "app.kubernetes.io/name" = "kube-efs-role-binding"
#     }
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.kube-efs-role.metadata[0].name
#   }
#   subject {
#     kind      = "ServiceAccount"
#     name      = var.efs_service_account_name
#     namespace = var.kube_namespace
#   }
# }

# resource "kubernetes_role_binding" "vault-efs-role-binding" {
#   depends_on = [
#     kubernetes_service_account.efs-service-account
#   ]
#   metadata {
#     name = "vault-efs-role-binding"
#     labels = {
#       "app.kubernetes.io/name" = "vault-efs-role-binding"
#     }
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.kube-efs-role.metadata[0].name
#   }
#   subject {
#     kind      = "ServiceAccount"
#     name      = "vault-efs-serviceaccount"
#     namespace = "vault"
#   }
# }

## This link says Fargate Auto install CSI https://aws.amazon.com/blogs/containers/running-stateful-workloads-with-amazon-eks-on-aws-fargate-using-amazon-efs/

# EFS creation
resource "aws_efs_file_system" "eks-efs" {
  creation_token = var.creation_token_efs_name
  encrypted      = true
  tags = {
    Name                  = var.creation_token_efs_name
    Cost                  = var.cost_tag
    Environment           = var.environment
    VantaContainsUserData = var.vanta_user_data
    VantaUserDataStored   = var.vanta_user_data_stored
    VantaOwner            = var.vanta_owner_email
    VantaNonProd          = var.vanta_non_prod
    VantaDescription      = "EFS for Fabric Platform EKS Cluster"
  }
  # depends_on = [
  #   kubernetes_role_binding.efs-role-binding
  # ]
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.eks-efs.id

  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_mount_target" "eks-efs-private-subnet-mnt-target" {
  # count           = length(data.terraform_remote_state.db.outputs.private_subnets)
  count           = 3
  file_system_id  = aws_efs_file_system.eks-efs.id
  subnet_id       = data.terraform_remote_state.db.outputs.private_subnets[count.index]
  security_groups = [aws_security_group.efs-access-security-group.id]
}

# resource "aws_efs_access_point" "eks-efs-mongo-access-point" {
#   file_system_id = aws_efs_file_system.eks-efs.id
#   root_directory {
#     path = "/mongo"
#     creation_info {
#       owner_gid   = 999
#       owner_uid   = 999
#       permissions = 755
#     }
#   }
#   posix_user {
#     gid = 999
#     uid = 999
#   }
#   tags = {
#     Name        = "eks-efs-${var.kube_namespace}-mongo-access-point"
#     Cost        = var.cost_tag
#     Environment = var.environment
#   }
# }

resource "aws_efs_access_point" "eks-efs-kafka-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/kafka"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-${var.kube_namespace}-kafka-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-zookeeper-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/zookeeper"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-${var.kube_namespace}-zookeeper-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

#Vault
resource "aws_efs_access_point" "eks-efs-vault-data-access-point" {
  count = var.vault_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/vault/vol-${count.index}/data"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-vault${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-sk-db-mysql-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/mysqlskdb"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
  }
  tags = {
    Name        = "eks-efs-${var.kube_namespace}-sk-db-mysql-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# mongocr
resource "aws_efs_access_point" "eks-efs-mongocr-data-access-point" {
  count = var.mongodbcr_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/mongodbcr/vol-${count.index}/data"
    creation_info {
      owner_gid   = 2000
      owner_uid   = 2000
      permissions = 755
    }
  }
  posix_user {
    gid = 2000
    uid = 2000
  }
  tags = {
    Name        = "eks-efs-mongocr${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-mongocr-logs-access-point" {
  count = var.mongodbcr_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/mongodbcr/vol-${count.index}/logs"
    creation_info {
      owner_gid   = 2000
      owner_uid   = 2000
      permissions = 755
    }
  }
  posix_user {
    gid = 2000
    uid = 2000
  }
  tags = {
    Name        = "eks-efs-mongocr${count.index}-logs-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

#Nifi
resource "aws_efs_access_point" "eks-efs-nifi-configdata-access-point" {
  count = var.nifi_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nifi/vol-${count.index}/configdata"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-nifi${count.index}-configdata-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-nifi-data1-access-point" {
  count = var.nifi_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nifi/vol-${count.index}/data1"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-nifi${count.index}-data1-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-nifi-data2-access-point" {
  count = var.nifi_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nifi/vol-${count.index}/data2"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-nifi${count.index}-data2-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-nifi-data3-access-point" {
  count = var.nifi_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nifi/vol-${count.index}/data3"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-nifi${count.index}-data3-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

#Mysql
resource "aws_efs_access_point" "eks-efs-mysqlcr-data-access-point" {
  count = var.mysqlcr_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/mysqlcr/vol-${count.index}/data"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = 755
    }
  }
  posix_user {
    gid = 1001
    uid = 1001
  }
  tags = {
    Name        = "eks-efs-mysqlcr${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

#Grafana
resource "aws_efs_access_point" "eks-efs-grafana-access-point" {

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/grafana"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-grafana-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-prometheus-log-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/prometheus/log"
    creation_info {
      owner_gid   = 65534
      owner_uid   = 65534
      permissions = 755
    }
  }
  posix_user {
    gid = 65534
    uid = 65534
  }
  tags = {
    Name        = "eks-efs-prometheus-log-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-prometheus-data-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/prometheus/data"
    creation_info {
      owner_gid   = 65534
      owner_uid   = 65534
      permissions = 755
    }
  }
  posix_user {
    gid = 65534
    uid = 65534
  }
  tags = {
    Name        = "eks-efs-prometheus-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-loki-data-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/loki/data"
    creation_info {
      owner_gid   = 10001
      owner_uid   = 10001
      permissions = 755
    }
  }
  posix_user {
    gid = 10001
    uid = 10001
  }
  tags = {
    Name        = "eks-efs-loki-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}


# Graphite
resource "aws_efs_access_point" "eks-efs-graphite-data-access-point" {
  count = var.graphite_replicas
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/opt/graphite-${count.index}/storage"
    creation_info {
      owner_gid   = 10001
      owner_uid   = 10001
      permissions = 755
    }
  }
  posix_user {
    gid = 10001
    uid = 10001
  }
  tags = {
    Name        = "eks-efs-graphite-${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Jaeger
resource "aws_efs_access_point" "eks-efs-jaeger-data-access-point" {
  count = var.jaeger_replicas
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/jaeger-${count.index}/badger"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-jaeger-${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Nh44
resource "aws_efs_access_point" "eks-efs-nh44-zookeeper-data-access-point" {
  count = var.nh44_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nh44/zookeeper/vol-${count.index}/data"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-nh44-zookeeper${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-nh44-zookeeper-logs-access-point" {
  count = var.nh44_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nh44/zookeeper/vol-${count.index}/logs"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-nh44-zookeeper${count.index}-logs-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-nh44-kafka-data-access-point" {
  count = var.nh44_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nh44/kafka/vol-${count.index}/data"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-nh44-kafka${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# AI
resource "aws_efs_access_point" "eks-efs-mlrest-data-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/mlrest/data"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
  }
  tags = {
    Name        = "eks-efs-mlrest-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-mlrest-logs-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/mlrest/logs"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
  }
  tags = {
    Name        = "eks-efs-mlrest-logs-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# SKBot
resource "aws_efs_access_point" "eks-efs-skbot-traindata-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/skbot/traindata"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = 755
    }
  }
  posix_user {
    gid = 1001
    uid = 1001
  }
  tags = {
    Name        = "eks-efs-skbot-traindata-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-skbot-logs-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/skbot/logs"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = 755
    }
  }
  posix_user {
    gid = 1001
    uid = 1001
  }
  tags = {
    Name        = "eks-efs-skbot-logs-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Nimble UAT MSSQL DB
resource "aws_efs_access_point" "eks-efs-uat-nimble-mssqldb-data-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble${var.uat_kube_namespace}/mssqldb/data"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
  }
  tags = {
    Name        = "eks-efs-${var.uat_kube_namespace}-nimble-mssqldb-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-uat-nimble-mssqldb-baseline-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble${var.uat_kube_namespace}/mssqldb/baseline"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
  }
  tags = {
    Name        = "eks-efs-${var.uat_kube_namespace}-nimbledev-mssqldb-baseline-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Nimble UAT SLAVE LICENCE
resource "aws_efs_access_point" "eks-efs-uat-nimbleslave1-license-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble/slave1/${var.uat_kube_namespace}/license"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
  }
  tags = {
    Name        = "eks-efs-${var.uat_kube_namespace}-nimbleslave1-license-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-uat-nimbleslave2-license-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble/slave2/${var.uat_kube_namespace}/license"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
  }
  tags = {
    Name        = "eks-efs-${var.uat_kube_namespace}-nimbleslave2-license-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Nimble Dev MSSQL DB
resource "aws_efs_access_point" "eks-efs-dev-nimble-mssqldb-data-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble${var.dev_kube_namespace}/mssqldb/data"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
  }
  tags = {
    Name        = "eks-efs-${var.dev_kube_namespace}-nimble-mssqldb-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-dev-nimble-mssqldb-baseline-access-point" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble${var.dev_kube_namespace}/mssqldb/baseline"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
  }
  tags = {
    Name        = "eks-efs-${var.dev_kube_namespace}-nimbledev-mssqldb-baseline-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Nimble Dev MSSQL DB Latest
resource "aws_efs_access_point" "eks-efs-dev-nimble-mssqldb-data-access-point-2" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble/${var.dev_kube_namespace}/mssqldb/data"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 775
    }
  }
  posix_user {
    gid = 999
    uid = 999
    secondary_gids = [0]
  }
  tags = {
    Name        = "eks-efs-${var.dev_kube_namespace}-nimble-mssqldb-data-access-point-2"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-dev-nimble-mssqldb-baseline-access-point-2" {
  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble/${var.dev_kube_namespace}/mssqldb/baseline"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
    secondary_gids = [0]
  }
  tags = {
    Name        = "eks-efs-${var.dev_kube_namespace}-nimbledev-mssqldb-baseline-access-point-2"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Kafka cluster
resource "aws_efs_access_point" "eks-efs-kafkacluster-zookeeper-data-access-point" {
  count = var.kafka_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/kafkacluster/zookeeper/vol-${count.index}/data"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-kafkacluster-zookeeper${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-kafkacluster-zookeeper-logs-access-point" {
  count = var.kafka_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/kafkacluster/zookeeper/vol-${count.index}/logs"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-kafkacluster-zookeeper${count.index}-logs-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "eks-efs-kafkacluster-kafka-data-access-point" {
  count = var.kafka_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/kafkacluster/kafka/vol-${count.index}/data"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    Name        = "eks-efs-kafkacluster-kafka${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

#Nimble Solr Server
resource "aws_efs_access_point" "eks-efs-nimble-solr-data-access-point" {
  count = var.nimble_solr_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble/solr/vol-${count.index}/data"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = 755
    }
  }
  posix_user {
    gid = 1001
    uid = 1001
  }
  tags = {
    Name        = "eks-efs-nimble-solr${count.index}-data-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Nimble App Dev(dev namespace) License
resource "aws_efs_access_point" "eks-efs-dev-nimble-slave-license-access-point" {
  count = var.nimbledev_slave_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble/dev/slave${count.index}/license"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
    secondary_gids = [0]
  }
  tags = {
    Name        = "eks-efs-dev-nimble-slave${count.index}-license-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Nimble App Dev(dev namespace) Logs
resource "aws_efs_access_point" "eks-efs-dev-nimble-slave-logs-access-point" {
  count = var.nimbledev_slave_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble/dev/slave${count.index}/logs"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
    secondary_gids = [0]
  }
  tags = {
    Name        = "eks-efs-dev-nimble-slave${count.index}-logs-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# Nimble App UAT(uat namespace) Logs
resource "aws_efs_access_point" "eks-efs-uat-nimble-slave-logs-access-point" {
  count = var.nimbleuat_slave_replicas

  file_system_id = aws_efs_file_system.eks-efs.id
  root_directory {
    path = "/nimble/uat/slave${count.index}/logs"
    creation_info {
      owner_gid   = 999
      owner_uid   = 999
      permissions = 755
    }
  }
  posix_user {
    gid = 999
    uid = 999
    secondary_gids = [0]
  }
  tags = {
    Name        = "eks-efs-uat-nimble-slave${count.index}-logs-access-point"
    Cost        = var.cost_tag
    Environment = var.environment
  }
}

# resource "kubernetes_storage_class" "eks-efs-storage-class" {
#   metadata {
#     name = "eks-efs-storage-class"
#   }
#   storage_provisioner = "efs.csi.aws.com"
#   reclaim_policy      = "Retain"
#   #volume_binding_mode = "WaitForFirstConsumer"
# }
