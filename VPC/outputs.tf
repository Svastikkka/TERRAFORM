output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_cidrs" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_cidrs" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "security_group_id" {
  value = module.vpc.default_security_group_id
}
