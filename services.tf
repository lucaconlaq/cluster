resource "google_project_service" "container" {
    service = "container.googleapis.com"
      disable_dependent_services = true
  }
  
  resource "google_project_service" "dns" {
    service = "dns.googleapis.com"
    disable_dependent_services = true
  }