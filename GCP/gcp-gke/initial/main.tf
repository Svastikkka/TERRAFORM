data "google_compute_network" "vpc" {
  name    = var.vpc_name
  project = var.project_id
}

data "google_compute_subnetwork" "subnet" {
  name   = var.subnet_name
  region = var.region
  project = var.project_id
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  deletion_protection = false

  network    = data.google_compute_network.vpc.name
  subnetwork = data.google_compute_subnetwork.subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {} # Needed for Autopilot or VPC-native clusters
  node_locations = ["us-central1-a", "us-central1-b", "us-central1-c", "us-central1-f"]
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 3
  depends_on = [google_container_cluster.primary]

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    tags = var.tags
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
