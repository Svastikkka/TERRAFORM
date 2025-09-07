package main

deny[msg] {
  resource := input.resource
  resource.type == "aws_security_group"

  # Rule 1: Don't allow ingress from all IPs (0.0.0.0/0)
  ingress := resource.attr.ingress
  ingress.cidr_blocks[_] == "0.0.0.0/0"
  msg = "Security group allows ingress from all IPs (0.0.0.0/0)"

  # Rule 2: Don't allow egress to all IPs (0.0.0.0/0)
  egress := resource.attr.egress
  egress.cidr_blocks[_] == "0.0.0.0/0"
  msg = "Security group allows egress to all IPs (0.0.0.0/0)"
}

deny[msg] {
  resource := input.resource
  resource.type == "aws_security_group"

  # Rule 1: Don't allow inbound traffic from ports 22 and 3389
  ingress := resource.attr.ingress
  ports := [22, 3389]
  port := ports[_]
  ingress[_].from_port == port
  ingress[_].to_port == port
  msg = sprintf("Security group allows inbound traffic on port %v", [port])

  # Rule 2: Require outbound traffic to be restricted to specific destinations
  egress := resource.attr.egress
  allowed_destinations := ["52.44.24.254/32", "54.235.89.147/32", "10.0.0.0/16", "54.235.42.147/32", "54.152.198.97/32", "18.212.88.112/32", "10.41.0.0/16", "140.82.201.129/32", "140.82.201.129/32",]
  egress[_].cidr_blocks[_] != allowed_destinations[_]
  msg = "Security group allows outbound traffic to unauthorized destinations"
}

deny[msg] {
	input.resource.aws_security_group.fabric_vpc_security_group.name != "fabric-dev-security-group"
	msg = "Security Group name should be fabric-dev-security-group"
}

deny[msg] {
  resource := input.resource
  resource.type == "aws_security_group_rule"

  not resource.from_port
  msg := "Security group rule is missing required 'from_port' attribute"
}

deny[msg] {
  resource := input.resource
  resource.type == "aws_security_group_rule"

  not resource.to_port
  msg := "Security group rule is missing required 'from_port' attribute"
}

deny[msg] {
  resource := input.resource
  resource.type == "aws_security_group_rule"

  resource.direction == "ingress"
  not resource.protocol
  msg := "Ingress security group rule is missing required 'protocol' attribute"
}