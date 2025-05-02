resource "google_service_account" "cluster" {
  account_id   = "cluster"
  display_name = "GKE Nodes Service Account"
  project      = var.project_id
}

resource "google_container_cluster" "main" {
  name     = "main"
  location = var.cluster_location 

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  node_pool {
    name       = "default"
    node_count = var.cluster_node_count 

    node_config {
      machine_type    = var.cluster_machine_type  
      service_account = google_service_account.cluster.email
      workload_metadata_config {
        mode = "GKE_METADATA"
      }
    }
  }

  depends_on = [google_project_service.container]
  deletion_protection = false
}