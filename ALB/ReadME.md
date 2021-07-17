# Application load balancer 
## Requirements
- 1  VPC
- 2  Subnets
- 3  Security groups
- 2  VMS of t2.micro
- 1  ALB Application Load balancer
- 3  Security group for opening 443 port for ALB,   security group for opening 80 port in-app, security group opening 1433 port in db subnet from app subnet only

## Application Architecture

Created using [App Diagram](https://app.diagrams.net/)
<div align="center">  
  <img alt="Application Architechture" src="./image/image.png"/>
</div>

## How to run?
- terraform init  (To initialize the terraform)
- terraform plan  (checks already-existing remote objects, Noting any differences, validate configuration)
- terraform apply (actions proposed in a Terraform plan)

# Dependency
- Credential enviroment variable should be created to pass secrets

