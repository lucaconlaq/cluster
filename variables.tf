variable "project_id" {
  description = "The unique identifier for the Google Cloud project."
  type        = string
  default     = "cluster-414209"
}

variable "region" {
  description = "Defines the geographic region for Google Cloud resources."
  type        = string
  default     = "europe-west1"
}

variable "dns_name" {
  description = "The DNS name for the managed zone."
  type        = string
  default     = "cluster.lucaconlaq.io."
}

variable "cluster_node_count" {
  description = "The number of nodes in the default node pool"
  default     = 1
}

variable "cluster_machine_type" {
  description = "The machine type for GKE nodes"
  default     = "e2-medium"
}

variable "cluster_location" {
  description = "The location for the GKE cluster"
  default     = "europe-west1-b"
}

variable "external_dns_txt_owner_id" {
  description = "The owner ID for the external-dns TXT record"
  default     = "be6111e0bb051cc3ad11c80e40cdf0d9"
}

variable "external_dns_chart_version" {
  description = "The version of the external-dns Helm chart"
  default     = "6.32.1"
}

variable "external_dns_image_tag" {
  description = "The version of the external-dns Docker image"
  default     = "v0.14.0"
}

variable "nginx_ingress_chart_version" {
  description = "Version of the nginx-ingress Helm chart"
  default     = "4.9.1"
}

variable "cert_manager_chart_version" {
  description = "Version of the cert-manager Helm chart"
  default = "v1.14.2"
}
