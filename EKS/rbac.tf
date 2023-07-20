# Creating role per namespace of each group of users
# 1) developers-role
# 2) fabric-developers-role
# Same for role binding
# 1) developers-role-binding
# 2) fabric-developers-role-binding

# dev namespace role for developers

resource "kubernetes_role" "dev_developer_role" {
	metadata {
    name      = "developers-role"
    namespace = "dev"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}
# qa namespace role for developers
resource "kubernetes_role" "qa_developer_role" {
	metadata {
    name      = "developers-role"
    namespace = "qa"
  }
  rule {
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
  }
  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
  }
}
# standalone namespace role for developers
resource "kubernetes_role" "standalone_developer_role" {
	metadata {
    name      = "developers-role"
    namespace = "standalone"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# dev namespace role for fabric developers
resource "kubernetes_role" "dev_fabric_developer_role" {
	metadata {
		name 			= "fabric-developers-role"
		namespace = "dev"
	}
	rule {
    api_groups = [""]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/exec", "pods/log", "pods/portforward", "secrets", "services"]
    verbs      = ["*"]
  }  
	rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["create", "update", "patch", "delete"]
  }
}
# qa namespace role for fabric developers
resource "kubernetes_role" "qa_fabric_developer_role" {
	metadata {
		name 			= "fabric-developers-role"
		namespace = "qa"
	}
	rule {
    api_groups = [""]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/exec", "pods/log", "pods/portforward", "secrets", "services"]
    verbs      = ["*"]
  }  
	rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["create", "update", "patch", "delete"]
  }
}
# standalone namespace role for fabric developers
resource "kubernetes_role" "standalone_fabric_developer_role" {
	metadata {
		name 			= "fabric-developers-role"
		namespace = "standalone"
	}
	rule {
    api_groups = [""]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/exec", "pods/log", "pods/portforward", "secrets", "services"]
    verbs      = ["*"]
  }  
	rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["create", "update", "patch", "delete"]
  }
}

# uat namespace role for fabric developers
resource "kubernetes_role" "uat_fabric_developer_role" {
	metadata {
		name 			= "fabric-developers-role"
		namespace = "uat"
	}
	rule {
    api_groups = [""]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/exec", "pods/log", "pods/portforward", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }  
	rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["create", "update", "patch", "delete"]
  }
}

# cache namespace role for fabric developers
resource "kubernetes_role" "cache_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "cache"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# vault namespace role for fabric developers
resource "kubernetes_role" "vault_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "vault"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# mongo namespace role for fabric developers
resource "kubernetes_role" "mongo_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "mongo"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# mongocr namespace role for fabric developers
resource "kubernetes_role" "mongocr_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "mongocr"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# mysql namespace role for fabric developers
resource "kubernetes_role" "mysql_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "mysql"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# nh44 namespace role for fabric developers
resource "kubernetes_role" "nh44_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "nh44"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# indexing namespace role for fabric developers
resource "kubernetes_role" "indexing_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "indexing"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# obervability namespace role for fabric developers
resource "kubernetes_role" "observability_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "observability"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# config namespace role for fabric developers
resource "kubernetes_role" "config_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "config"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

# oauth namespace role for fabric developers
resource "kubernetes_role" "oauth_fabric_developer_role" {
	metadata {
    name      = "fabric-developers-role"
    namespace = "oauth"
  }
  rule {
    api_groups = ["", "apps", "batch", "extensions", "metrics.k8s.io"]
    resources  = ["cronjobs", "deployments", "events", "jobs", "pods", "pods/attach", "pods/log", "secrets", "services"]
    verbs      = ["get", "describe", "logs", "exec", "attach", "wait", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]  
    verbs      = ["create"]
  }
}

resource "kubernetes_role_binding" "developers_role_binding" {
  count = length(var.rbac_developers_role_namespaces)
  metadata {
    name      = "developers-role-binding"
    namespace = var.rbac_developers_role_namespaces[count.index]["namespace"]
  } 
  subject {
    kind = "Group"
    name = var.rbac_developers_group_name
    namespace = var.rbac_developers_role_namespaces[count.index]["namespace"]
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "developers-role"
  }
}

# role binding for developers
resource "kubernetes_role_binding" "fabric_developers_role_binding" {
  count = length(var.rbac_fabric_developers_role_namespaces)
  metadata {
    name      = "fabric-developers-role-binding"
    namespace = var.rbac_fabric_developers_role_namespaces[count.index]["namespace"]
  } 
  subject {
    kind = "Group"
    name = var.rbac_fabric_developers_group_name
    namespace = var.rbac_fabric_developers_role_namespaces[count.index]["namespace"]
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "fabric-developers-role"
  }
}

# jenkins cluster_role and jenkins cluster_role binding
