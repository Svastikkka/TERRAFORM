package main

deny[msg] {
  not input.module.vpc
  msg = "VPC module not defined"
}

deny[msg] {
  not input.module.vpc.name
  msg = "VPC name not defined"
}

deny[msg] {
  not input.module.vpc.cidr
  msg = "VPC CIDR not defined"
}

deny[msg] {
  not input.module.vpc.public_subnets
  msg = "Public subnets not defined"
}

deny[msg] {
  not input.module.vpc.private_subnets
  msg = "Private subnets not defined"
}

deny[msg] {
  not input.module.vpc.tags.kubernetes_io_cluster
  msg = "Kubernetes cluster tag not defined"
}

deny[msg] {
  not input.module.vpc.tags.Environment
  msg = "Environment tag not defined"
}
