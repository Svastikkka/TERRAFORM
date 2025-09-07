# GCP Non Production GKE Deployment

Following are the required steps to deploy terraform

```bash
export AWS_ACCESS_KEY_ID="ID"
export AWS_SECRET_ACCESS_KEY="SECRET"
export AWS_DEFAULT_REGION="<REGION>"
```

```bash
gcloud auth application-default login
```

```bash
terraform init \
  -backend-config="<PATH>/terraform.tfstate" \
  -reconfigure
```

```bash
terraform plan \
  -var="project_id=<PROJECT_ID>" \
  -var="region=<REGION>" \
  -var="zone=<REGION>-a" \
  -var="network=fabric-devlopment-network" \
  -var="mode=true" \
  -var="vpc_name=fabric-devlopment-vpc" \
  -var="subnet_name=fabric-devlopment-subnet" \
  -var="subnet_ip_range=10.0.0.0/24" \
  -var="cluster_name=fabric-development" \
  -var='tags=["fabric", "dev"]'
```

```bash
terraform apply -var="project_id=<PROJECT_ID>" \
  -var="region=<REGION>" \
  -var="zone=<REGION>-a" \
  -var="network=fabric-devlopment-network" \
  -var="mode=true" \
  -var="vpc_name=fabric-devlopment-vpc" \
  -var="subnet_name=fabric-devlopment-subnet" \
  -var="subnet_ip_range=10.0.0.0/24" \
  -var="cluster_name=fabric-development" \
  -var='tags=["fabric", "dev"]'
```

```bash
terraform output -json
```

```bash
terraform destroy \
  -var="project_id=<PROJECT_ID>" \
  -var="region=<REGION>" \
  -var="zone=<REGION>-a" \
  -var="network=fabric-devlopment-network" \
  -var="mode=true" \
  -var="vpc_name=fabric-devlopment-vpc" \
  -var="subnet_name=fabric-devlopment-subnet" \
  -var="subnet_ip_range=10.0.0.0/24" \
  -var="cluster_name=fabric-development" \
  -var='tags=["fabric", "dev"]'
```