# GCP Non Production VM Deployment

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
  -backend-config="key=<PATH>/terraform.tfstate" \
  -reconfigure
```

```bash
terraform plan \
  -var=db_instance_name="inital" \
  -var="project_id=<PROJECT_ID>" \
  -var="region=<REGION>" \
  -var="network=fabric-dev-network" \
  -var="postgres_version=POSTGRES_15" \
  -var="tier=db-custom-2-7680" \
  -var="disk_size=100" \
  -var="disk_type=PD_HDD" \
  -var="ipv4_enabled=false" \
  -var="activation_policy=ALWAYS" \
  -var="db_name=fabric_db" \
  -var="db_user=fabric_admin" \
  -var="db_password=SecurePass123" \
  -var='tags=["fabric", "dev"]'
```

```bash
terraform apply -var="db_instance_name=inital" \
  -var="project_id=<PROJECT_ID>" \
  -var="region=<REGION>" \
  -var="network=fabric-dev-network" \
  -var="postgres_version=POSTGRES_15" \
  -var="tier=db-custom-2-7680" \
  -var="disk_size=100" \
  -var="disk_type=PD_HDD" \
  -var="ipv4_enabled=false" \
  -var="activation_policy=ALWAYS" \
  -var="db_name=fabric_db" \
  -var="db_user=fabric_admin" \
  -var="db_password=SecurePass123" \
  -var='tags=["fabric", "dev"]'
```

```bash
terraform output -json
```

```bash
terraform destroy \
  -var="db_instance_name=inital" \
  -var="project_id=<PROJECT_ID>" \
  -var="region=<REGION>" \
  -var="network=fabric-dev-network" \
  -var="postgres_version=POSTGRES_15" \
  -var="tier=db-custom-2-7680" \
  -var="disk_size=100" \
  -var="disk_type=PD_HDD" \
  -var="ipv4_enabled=false" \
  -var="activation_policy=ALWAYS" \
  -var="db_name=fabric_db" \
  -var="db_user=fabric_admin" \
  -var="db_password=SecurePass123" \
  -var='tags=["fabric", "dev"]'
```