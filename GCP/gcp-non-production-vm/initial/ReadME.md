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
  -backend-config="key=<S3_PATH>/terraform.tfstate" \
  -reconfigure
```

```bash
terraform plan \
  -var="project_id=<PROJECT_ID>" \
  -var="region=<REGION>" \
  -var="zone=<REGION>-a" \
  -var="network=fabric-dev-network" \
  -var="instance_name=vm-testing" \
  -var="machine_type=e2-medium" \
  -var="disk_image=debian-cloud/debian-11" \
  -var="disk_size=100" \
  -var="startup_script_path=./startup.sh" \
  -var='tags=["fabric-ai", "dev"]'
```

```bash
terraform apply \
  -var="project_id=<PROJECT_ID>" \
  -var="region=<REGION>" \
  -var="zone=<REGION>-a" \
  -var="network=fabric-dev-network" \
  -var="instance_name=vm-testing" \
  -var="machine_type=e2-medium" \
  -var="disk_image=debian-cloud/debian-11" \
  -var="disk_size=100" \
  -var="startup_script_path=./startup.sh" \
  -var='tags=["fabric-ai", "dev"]'
```

```bash
terraform destroy \                                  
  -var="project_id=<PROJECT_ID>" \
  -var="region=<REGION>" \
  -var="zone=<REGION>-a" \
  -var="network=fabric-dev-network" \
  -var="instance_name=vm-testing" \
  -var="machine_type=e2-medium" \
  -var="disk_image=debian-cloud/debian-11" \
  -var="disk_size=100" \
  -var="startup_script_path=./startup.sh" \
  -var='tags=["fabric-ai", "dev"]'
```