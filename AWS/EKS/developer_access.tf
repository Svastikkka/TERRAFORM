resource "kubernetes_cluster_role" "developer-role" {
  metadata {
    name = "developer-role"
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch", "get", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
    verbs      = ["get", "list", "watch", "create"]
  }

  rule {
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
    verbs      = ["get", "list", "watch", "create"]
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions", "apiservices"]
    verbs      = ["get", "list", "watch", "create", "patch","delete", "update"]
  }

  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterroles", "clusterrolebindings", "roles", "rolebindings"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "secrets", "namespaces", "configmaps", "serviceaccount", "resourcequotas"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["*"]
  }  

  rule {
    api_groups = [""]
    resources  = ["nodes/start", "nodes/stats"]
    verbs      = ["get"]
  }

  rule {
    api_groups = ["storage"]
    resources  = ["volumesttachments"]
    verbs      = ["get", "list", "watch"]
  }
  
  # Additional permissions for operators
  rule {
    api_groups = ["mongodbcommunity.mongodb.com"]
    resources  = ["mongodbcommunity"]
    verbs      = ["get", "list", "create", "update", "patch"]
  }
  
  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["create", "update", "patch", "delete"]
  }
  
  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations"]
    verbs      = ["delete"]
  }
  
  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates"]
    verbs      = ["delete"]
  }
  
  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["issuers"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete", "deletecollection"]
  }
  
  rule {
    api_groups = ["certmanager.k8s.io"]
    resources  = ["certificates"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete", "deletecollection"]
  }
  
  rule {
    api_groups = ["pxc.percona.com"]
    resources  = ["perconaxtradbclusterbackups","perconaxtradbclusterbackups/status", "perconaxtradbclusterrestores", "perconaxtradbclusterrestores/status", "perconaxtradbclusters", "perconaxtradbclusters/status"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["update", "delete"]
  }
  
  rule {
    api_groups = [""]
    resources  = ["services/finalizers"]
    verbs      = ["list", "get", "create", "patch", "update", "watch", "delete"]
  }
    
  rule {
    api_groups = [""]
    resources  = ["rolebindings", "roles"]
    verbs      = ["bind", "escalate", "impersonate", "userextras", "create", "get", "list", "watch", "update", "patch", "delete", "deletecollection"]
  }
  
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["read", "listallnamespaces", "watchlist", "watchlistallnamespaces", "replace"]
  }
  
  rule {
    api_groups = [""]
    resources  = ["serviceaccounts"]
    verbs      = ["bind", "escalate", "userextras"]
  }
  
  rule {
    api_groups = ["app.redislabs.com"]
    resources  = ["redisenterpriseclusters", "redisenterpriseclusters/status", "redisenterpriseclusters/status", "redisenterprisedatabases", "redisenterprisedatabases/finalizers", "redisenterprisedatabases/status"]
    verbs      = ["delete", "deletecollection", "get", "list", "patch", "create", "update", "watch"]
  }
  
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["replace", "read", "listallnamespaces", "watchlist", "watchlistallnamespaces", "patchstatus", "readstatus", "replacestatus"]
  }
  
  rule {
    api_groups = ["policy"]
    resources  = ["podsecuritypolicies"]
    resource_names = ["redis-enterprise-psp"]
    verbs      = ["use"]
  }
  
  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["rolebindings", "roles"]
    verbs      = ["bind", "escalate", "impersonate", "userextras"]
  }
  
  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["serviceaccounts"]
    verbs      = ["bind", "escalate", "impersonate", "userextras", "create", "get", "list", "watch", "update", "patch", "delete", "deletecollection"]
  }
  
  rule {
    api_groups = ["apiregistration.k8s.io/v1"]
    resources  = ["apiservices"]
    verbs      = ["get"]
  }
  
  rule {
    api_groups = [""]
    resources  = ["nodes/metrics"]
    verbs      = ["get"]
  }
  
  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims/finalizers"]
    verbs      = ["create","delete", "get", "list", "patch", "update", "watch"]
  }
  
  rule {
    api_groups = ["databases.spotahome.com"]
    resources  = ["redisfailovers", "redisfailovers/finalizers"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }
  
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create", "get", "list", "update"]
  }

  # Added this for API gateway roles
  rule {
    api_groups = [""]
    resources  = ["nodes/proxy"]
    verbs      = ["get", "watch", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "dev-admin-role-binding" {
  metadata {
    name = "dev-admin-role-binding"
    labels = {
      "name" = "dev-admin-role-binding"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "Group"
    name      = "developer"
    namespace = "jenkins-jobs"
  }
  subject {
    kind      = "Group"
    name      = "developer"
    namespace = "mongo"
  }
  subject {
    kind      = "Group"
    name      = "developer"
    namespace = "mysql"
  }
  subject {
    kind      = "Group"
    name      = "developer"
    namespace = "oauth"
  }
  subject {
    kind      = "Group"
    name      = "developer"
    namespace = "cache"
  }
  subject {
    kind      = "Group"
    name      = "developer"
    namespace = "observability"
  }
  subject {
    kind      = "Group"
    name      = "developer"
    namespace = "aws-observability"
  }
  subject {
    kind      = "Group"
    name      = "developer"
    namespace = "nh44"
  }
  dynamic "subject" {
    for_each = var.dev_admin_role_binding
    content {
      kind = "Group"
      name = subject.value["group_name"]
      namespace = subject.value["namespace"]
    }
  }
  # Vault namespace access should not be available to developers group in production 
}

resource "kubernetes_cluster_role_binding" "developer-role-binding" {
  metadata {
    name = "developer-role-binding"
    labels = {
      "name" = "developer-role-binding"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "developer-role"
  }
  
  subject {
    kind = "Group"
    name = "developer"
  }
}

resource "kubernetes_cluster_role" "reader-additional-role" {
  metadata {
    name = "reader-additional-role"
  }
  
  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/portforward"]  
  } 
}

resource "kubernetes_cluster_role_binding" "reader-cluster-role-binding" {
  metadata {
    name = "reader-cluster-role-binding"
    labels = {
      "name" = "reader-cluster-role-binding"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  
  subject {
    kind = "Group"
    name = "reader"
  }
}

resource "kubernetes_cluster_role_binding" "reader-role-binding" {
  metadata {
    name = "reader-role-binding"
    labels = {
      "name" = "reader-role-binding"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  } 
  subject {
    kind      = "Group"
    name      = "reader"
    namespace = "jenkins-jobs"
  }
  subject {
    kind      = "Group"
    name      = "reader"
    namespace = "mongo"
  }
  subject {
    kind      = "Group"
    name      = "reader"
    namespace = "mysql"
  }
  subject {
    kind      = "Group"
    name      = "reader"
    namespace = "oauth"
  }
  subject {
    kind      = "Group"
    name      = "reader"
    namespace = "observability"
  }
  subject {
    kind      = "Group"
    name      = "reader"
    namespace = "aws-observability"
  }
  subject {
    kind      = "Group"
    name      = "reader"
    namespace = "nh44"
  }
  subject {
    kind      = "Group"
    name      = "reader"
    namespace = "cache"
  }
  dynamic "subject" {
    for_each = var.reader_role_binding
    content {
      kind = "Group"
      name = subject.value["group_name"]
      namespace = subject.value["namespace"]
    }
  }
}

resource "kubernetes_cluster_role_binding" "reader-additional-role-binding" {
  metadata {
    name = "reader-additional-role-binding"
    labels = {
      "name" = "reader-additional-role-binding"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "reader-additional-role"
  }
  
  subject {
    kind = "Group"
    name = "reader"
  }
}

# Creates Kubernetes RBAC roles giving access to deploy services in specified namespaces
# module kube_deploy_access_roles_on_namespace {
#   count = length(var.kube_deploy_rbac_on_namespaces)
#   source                    =  "./kubernetes-rbac-roles/single-namespace-access"
#   cluster_name              =  "${var.eks_cluster_name}-${var.environment}"
#   kube_namespace            =  var.kube_deploy_rbac_on_namespaces[count.index]["namespace"]
#   rbac_group_name           =  var.kube_deploy_rbac_on_namespaces[count.index]["group_name"]

#   depends_on = [kubernetes_namespace.fabric-namespaces]
# }
