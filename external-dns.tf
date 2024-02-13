resource "google_service_account" "externaldns" {
  account_id   = "externaldns"
  display_name = "ExternalDNS Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "externaldns_dns_admin" {
  project = var.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.externaldns.email}"
}

resource "google_service_account_key" "externaldns" {
  service_account_id = google_service_account.externaldns.name
}

resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_secret" "externaldns_credentials" {
  depends_on = [google_service_account_key.externaldns]
  metadata {
    name = "external-dns"
    namespace = kubernetes_namespace.external_dns.metadata[0].name
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.externaldns.private_key)
  }
}

resource "helm_release" "external_dns" {
  depends_on = [kubernetes_namespace.nginx_ingress, kubernetes_secret.externaldns_credentials]
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.external_dns_chart_version
  namespace  = kubernetes_namespace.external_dns.metadata.0.name

  set {
    name  = "provider"
    value = "google"
  }

  set {
    name  = "google.project"
    value = var.project_id
  }

  set {
    name  = "google.serviceAccountSecret"
    value = kubernetes_secret.externaldns_credentials.metadata.0.name
  }

  set {
    name  = "google.serviceAccountSecretKey"
    value = keys(kubernetes_secret.externaldns_credentials.data).0
  }

  set {
    name  = "google.zoneVisibility"
    value = "public"
  }

  set {
    name  = "domainFilters[0]"
    value = var.dns_name
  }

  set {
    name  = "txtOwnerId"
    value = var.external_dns_txt_owner_id
  }

  set {
    name  = "image.registry"
    value = "registry.k8s.io"
  }

  set {
    name  = "image.repository"
    value = "external-dns/external-dns"
  }

  set {
    name  = "image.tag"
    value = var.external_dns_image_tag
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "sources[0]"
    value = "service"
  }

  set {
    name  = "sources[1]"
    value = "ingress"
  }
}
