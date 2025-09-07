output "vpc_name" {
  value = google_compute_network.vpc_network.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}