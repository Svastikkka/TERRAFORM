output "cluster_id" {
  value = module.eks-cluster.cluster_id
}

output "cluster_certificate_authority_data" {
  value = module.eks-cluster.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  value = module.eks-cluster.cluster_oidc_issuer_url
}

output "cluster_oidc_provider" {
  value = module.eks-cluster.oidc_provider
}

output "cluster_oidc_provider_arn" {
  value = module.eks-cluster.oidc_provider_arn
}