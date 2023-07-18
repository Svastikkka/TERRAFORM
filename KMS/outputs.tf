output "key_id" {
  value = aws_kms_key.kms_key.key_id
}

output "key_arn" {
  value = aws_kms_key.kms_key.arn
}

output "kms_vault_service_role_arn" {
  value = aws_iam_role.kms-vault-service-account-iam-role.arn
}
