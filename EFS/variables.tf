variable "access_key" {
  type        = string
  description = "value of AWS access key"
}
#export TF_VAR_access_key=""

variable "secret_key" {
  type        = string
  description = "value of AWS secret key"
}
#export TF_VAR_secret_key=""

variable "session_token" {
  type        = string
  description = "AWS MFA session token value"
}
#export TF_VAR_session_token=""

variable "region" {
  type        = string
  description = "value of region"
  default = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment Name"
  default     = "dev"
}

# variable "bucket_versioning" {
#   type        = bool
#   description = "Bucket versioning"
#   default     = false
# }

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster Name"
  default     = "fabric"
}

variable "cost_tag" {
  type        = string
  description = "AWS cost tag for reporting"
  default = "Fabric"
}

variable "vanta_owner_email" {
  type        = string
  description = "email address for vanta notifications"
  default     = "st.engg@digite.com"
}

variable "vanta_user_data" {
  type        = bool
  description = "Vanta contains user data"
  default = true
}

variable "vanta_user_data_stored" {
  type        = string
  description = "Vanta stored user data"
  default = "User Official Emails and Company Confidential Projects Data"
}

variable "vanta_non_prod" {
  type        = bool
  description = "Toggle mark env as non prod for vanta"
  default     = true
}

# variable "kubernetes_namespaces" {
#   type        = list(string)
#   description = "List of namespaces to create in the kube cluster"
#   default     = ["dev", "qa", "uat", "vault", "jenkins-jobs", "mongo", "mysql", "oauth", "cache", "observability", "nh44", "standalone", "config", "indexing", "notification"]
# }

# variable "alb_service_account_name" {
#   type = string
#   description = "name of the service account for ALB"
#   default = "aws-load-balancer-controller"
# }

variable "creation_token_efs_name" {
  type        = string
  description = "EFS token name"
  default     = "fabric-efs"
}

# variable "efs_service_account_name" {
#   type        = string
#   description = "Service Account for EFS CSI driver"
#   default = "efs-serviceaccount"
# }

variable "mongodbcr_replicas" {
  type        = number
  description = "No of Mongodb CR replicas"
  default = 3
}

variable "nifi_replicas" {
  type        = number
  description = "No of Nifi replicas"
  default = 2
}

variable "mysqlcr_replicas" {
  type        = number
  description = "No of MySQL replicas"
  default = 2  
}

variable "vault_replicas" {
  type        = number
  description = "No of Vault replicas"
  default = 3 
}

variable "graphite_replicas" {
  type        = number
  description = "No of graphite replicas"
  default = 1
}

variable "jaeger_replicas" {
  type        = number
  description = "No of jaeger replicas"
  default = 1
}

variable "nh44_replicas" {
  type        = number
  description = "No of NH44 replicas"
  default = 3 
}

variable "kafka_replicas" {
  type        = number
  description = "No of kafka replicas"
  default = 3 
}

variable "nimble_solr_replicas" {
  type        = number
  description = "No of Nimble solr server replicas"
  default = 3 
}

variable "nimbledev_slave_replicas" {
  type        = number
  description = "No of Nimble dev slave replicas"
  default = 2 
}

variable "nimbleuat_slave_replicas" {
  type        = number
  description = "No of Nimble uat slave replicas"
  default = 2 
}

# variable "cluster_allowed_cidrs" {
#   type = list(string)
#   description = "IP CIDRs that are allowed access to the cluster"
#   default = ["35.171.87.178/32", "52.44.24.254/32", "54.235.89.147/32", "54.235.42.147/32", "54.152.198.97/32", "104.21.192.28/32", "104.21.65.79/32", "18.212.88.112/32", "140.82.201.129/32", "15.207.188.167/32", "3.108.174.44/32","3.95.3.34/32","3.221.93.236/32"]
# }

# variable "aws_kube_roles_mapping" {
#   type = list(object({
#     rolearn  = string
#     username = string
#     groups   = list(string)
#   }))
#   description = "Additional IAM roles to add to the aws-auth configmap."
#   default = [{
#     groups   = ["developer"]
#     rolearn  = "arn:aws:iam::406059358747:role/AWSReservedSSO_SwifTalkEngineerAccess_da53d1896638677f"
#     username = "AWSReservedSSO_SwifTalkEngineerAccess_da53d1896638677f"
#     },
#     {
#       groups   = ["reader"]
#       rolearn  = "arn:aws:iam::406059358747:role/AWSReservedSSO_SwifTalkInternAccess_5b30898d87482d0a"
#       username = "AWSReservedSSO_SwifTalkInternAccess_5b30898d87482d0a"
#     },
#     {
#       groups   = ["system:masters"]
#       rolearn  = "arn:aws:iam::406059358747:role/AWSReservedSSO_Admin_Restricted_04835747ed2394fc"
#       username = "AWSReservedSSO_Admin_Restricted_04835747ed2394fc"
#     },
#     {
#       groups   = ["system:bootstrappers","system:nodes"]
#       rolearn  = "arn:aws:iam::406059358747:role/eks-fabric-dev-node-group"
#       username = "system:node:{{EC2PrivateDNSName}}"
      
#     },
#     {
#       groups   = ["developers-group"]
#       rolearn  = "arn:aws:iam::406059358747:role/AWSReservedSSO_DevelopersAccessFabricDev_a487c524bfcfe1f2"
#       username = "AWSReservedSSO_DevelopersAccessFabricDev_a487c524bfcfe1f2"
#     },
#     {
#       groups   = ["fabric-developers-group"]
#       rolearn  = "arn:aws:iam::406059358747:role/AWSReservedSSO_FabricDevelopersAccess_c0be6497014edf3d"
#       username = "AWSReservedSSO_FabricDevelopersAccess_c0be6497014edf3d"
#     }
#   ]
# }

# variable "aws_kube_users_mapping" {
#   type = list(object({
#     userarn  = string
#     username = string
#     groups   = list(string)
#   }))
#   description = "Additional IAM users to add to the aws-auth configmap."
#   default = [{
#     groups   = ["developer"]
#     userarn  = "arn:aws:iam::406059358747:user/swiftalk-eks-deployer"
#     username = "swiftalk-eks-deployer"
#   }]
# }

# variable "fabric_profile_name" {
#   type = string
#   description = "Profile name for running Fabric Components"
#   default = "alb-profile"
# }

# variable "alb_ingress_policy_name" {
#   type = string
#   description = "IAM Policy for AWS Load Balancer Controller"
#   default = "SwifTalkAWSLoadBalancerControllerIAMPolicy"
# }

# variable "remote_backend" {
#   type = string
#   default = "fabric-iac"
# }

# variable "cluster_log_retention_days" {
#   type = number
#   default = 7
# }

# variable app_profile_selectors {
#   type = list(object({
#     namespace = string
#   }))
#   default = [
#     {
#       namespace = "dev"
#     },
#     {
#       namespace = "qa"
#     },
#     {
#       namespace = "uat"
#     },
#     {
#       namespace = "saas-test"
#     }    
#   ]
# }

# variable accountId {
#   type = string
#   default = "127311923021"
# }

# variable "subOrgAccountId" {
#   type = string
#   default = "406059358747"
# }

# variable "reader_role_binding" {
#   type = list(object({
#     group_name = string
#     namespace = string
#   }))
#   default = [{
#     group_name = "reader",
#     namespace = "dev",
#   },
#   {
#     group_name = "reader",
#     namespace = "qa",
#   },
#   {
#     group_name = "reader",
#     namespace = "uat",
#   }]
#   description = "List of reader role group mapping"
# }

# variable "dev_admin_role_binding" {
#   type = list(object({
#     group_name = string
#     namespace = string
#   }))
#   default = [{
#     group_name = "developer",
#     namespace = "dev",
#   },
#   {
#     group_name = "developer",
#     namespace = "qa",
#   },
#   {
#     group_name = "developer",
#     namespace = "uat",
#   },
#   {
#     group_name = "developer",
#     namespace = "vault",
#   }]
#   description = "List of dev admin role group mapping"
# }

variable "kube_namespace" {
  type = string
  default = "uat"
}

variable "dev_kube_namespace" {
  type = string
  description = "Name of the kubernetes namespace which is used before applying changes in final env namespace"
  default = "dev"
}

variable "uat_kube_namespace" {
  type = string
  description = "Name of the kubernetes namespace which is used before applying changes in final env namespace"
  default = "uat"
}

# variable "alblogs_s3_prefix" {
#   type = list(string)
#   description = "List of s3 prefixes for all the albs in which their log files will be created"
#   default = ["alb", "nifi-alb", "nifiregistry-alb", "auth-alb", "internal-alb", "ups-internal-alb", "oauth", "srv", "retro"]
# }

# variable "kube_deploy_rbac_on_namespaces" {
#   type = list(object({
#     namespace  = string
#     group_name = string
#   }))
#   description = "List of namespaces with their group name for which deployment kubernetes rbac roles should be created"
#   default = [
#     {
#       namespace = "dev"
#       group_name = "product-developer"
#     }
#   ]
  
#   /*Example = [
#     {
#       namespace = "default"
#       group_name = "default-write"
#     },
#   ]*/
# }

# variable "rbac_developers_group_name" {
#   type = string
#   default = "developers-group"
# }

# variable "rbac_fabric_developers_group_name" {
#   type = string
#   default = "fabric-developers-group"
# }

# variable "rbac_developers_role_namespaces" {
#   type = list(object({
#     namespace = string
#   }))
#   description = "List of namespaces for developers role"
#   default = [
#     {
#       namespace = "dev"
#     },
#     {
#       namespace = "qa"
#     },
#     {
#       namespace = "standalone"
#     }
#   ]
# }

# variable "rbac_fabric_developers_role_namespaces" {
#   type = list(object({
#     namespace = string
#   }))
#   description = "List of namespaces for developers role"
#   default = [
#     {
#       namespace = "dev"
#     },
#     {
#       namespace = "qa"
#     },
#     {
#       namespace = "standalone"
#     },
#     {
#       namespace = "uat"
#     },
#     {
#       namespace = "cache"
#     },
#     {
#       namespace = "vault"
#     },
#     {
#       namespace = "mongo"
#     },
#     {
#       namespace = "mongocr"
#     },
#     {
#       namespace = "mysql"
#     },
#     {
#       namespace = "nh44"
#     },
#     {
#       namespace = "indexing"
#     },
#     {
#       namespace = "observability"
#     },
#     {
#       namespace = "config"
#     },
#     {
#       namespace = "devops"
#     },
#     {
#       namespace = "oauth"
#     }
#   ]
# }