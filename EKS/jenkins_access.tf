resource "kubernetes_service_account" "jenkins-service-account" {
  metadata {
    name      = "jenkins"
    namespace = "jenkins-jobs"
    labels = {
      "app.kubernetes.io/name" = "jenkins"
    }
  }
  secret {
    name = "jenkins-token"
  }
  depends_on = [module.fargate-profile]
}

resource "kubernetes_secret" "jenkins-token" {
  metadata {
    name = "jenkins-token"
    namespace = "jenkins-jobs"
    labels = {
      "app.kubernetes.io/name" = "jenkins"
    }
    annotations = {
      "kubernetes.io/service-account.name" = "jenkins"
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_role_binding" "jenkins-role-binding" {
  metadata {
    name      = "jenkins-role-binding"
    namespace = "jenkins-jobs"
    labels = {
      "name" = "jenkins-role-binding"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = "jenkins-jobs"
  }

  depends_on = [kubernetes_service_account.jenkins-service-account]
}
