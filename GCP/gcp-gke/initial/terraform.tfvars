project_id       = "nonprod1-svc-r4rc"
region           = "us-central1"
zone             = "us-central1-a"
vpc_name         = "fabric-devlopment-vpc"
subnet_name      = "fabric-devlopment-subnet"
subnet_ip_range  = "10.0.0.0/24" # Not used, but required by variables.tf
cluster_name     = "fabric-development"
tags             = ["fabric", "dev"]