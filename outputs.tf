output "dns_zone_name_servers" {
  description = "The name servers for the managed zone."
  value       = google_dns_managed_zone.main.name_servers
}

output "dns_zone_address" {
  description = "The name servers for the managed zone."
  value       = google_dns_managed_zone.main.dns_name
}

output "cluster_service_account_email" {
  description = "The email address of the cluster service account"
  value       = google_service_account.cluster.email
}