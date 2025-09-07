output "db_instance_connection_name" {
  description = "Cloud SQL instance connection name"
  value       = google_sql_database_instance.db_instance.connection_name
}

output "postgres_public_ip" {
  description = "Public IP address of the PostgreSQL instance"
  value       = google_sql_database_instance.db_instance.public_ip_address
}

output "postgres_connection_url" {
  description = "PostgreSQL connection URL"
  value = format(
    "postgresql://%s:%s@%s:5432/%s",
    var.db_user,
    var.db_password,
    google_sql_database_instance.db_instance.public_ip_address,
    var.db_name
  )
  sensitive = true
}

output "postgres_user" {
  description = "Database user name"
  value       = var.db_user
}

output "postgres_db_name" {
  description = "Database name"
  value       = var.db_name
}

output "postgres_password" {
  description = "Database user password"
  value       = var.db_password
  sensitive   = true
}
