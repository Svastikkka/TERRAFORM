resource "google_sql_database_instance" "db_instance" {
  name             = var.db_instance_name
  region           = var.region
  database_version = var.postgres_version
  project          = var.project_id

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = "projects/${var.project_id}/global/networks/${var.network}"
    }

    backup_configuration {
      enabled = true
    }

    disk_size = var.disk_size
    disk_type = var.disk_type

    activation_policy = var.activation_policy
  }

  deletion_protection = false
}

resource "google_sql_database" "default_db" {
  name     = var.db_name
  instance = google_sql_database_instance.db_instance.name
}

resource "google_sql_user" "default_user" {
  name     = var.db_user
  instance = google_sql_database_instance.db_instance.name
  password = var.db_password
}
