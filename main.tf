resource "google_project_service" "container" {
  service = "container.googleapis.com"
    disable_dependent_services = true
}

resource "google_project_service" "dns" {
  service = "dns.googleapis.com"
  disable_dependent_services = true
}

resource "google_dns_managed_zone" "main" {
  depends_on = [google_project_service.dns]
  name     = "${trimsuffix(replace(trimspace(var.dns_name), ".", "-"), "-")}"
  dns_name = var.dns_name
}

resource "google_service_account" "cluster" {
  account_id   = "cluster"
  display_name = "GKE Nodes Service Account"
  project      = var.project_id
}

resource "google_container_cluster" "main" {
  name     = "main"
  location = "${var.cluster_location}" 

  node_pool {
    name       = "default"
    node_count = var.cluster_node_count 

    node_config {
      machine_type    = var.cluster_machine_type  
      service_account = google_service_account.cluster.email
    }
  }

  depends_on = [google_project_service.container] 
  deletion_protection = false
}