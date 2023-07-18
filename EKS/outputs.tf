output "cluster_oidc_issuer_url" {
  value = module.eks-cluster.cluster_oidc_issuer_url
}

output "cluster_oidc_provider" {
  value = module.eks-cluster.oidc_provider
}

output "cluster_oidc_provider_arn" {
  value = module.eks-cluster.oidc_provider_arn
}
output "cluster_iam_role_arn" {
  value = module.eks-cluster.cluster_iam_role_arn
}