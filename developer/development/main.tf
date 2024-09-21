module "microservices" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//microservices?ref=dev"

  kind_cluster_name = var.kind_cluster_name
  kind_http_port    = 80
  kind_https_port   = 443

  kubernetes_namespace = "microservices"

  keycloak_enable      = true
  keycloak_domain_name = var.keycloak_domain_name

  keycloak_admin_user       = "admin"
  keycloak_admin_password   = "MyPassword2222@"
  keycloak_persistence_size = "5Gi"

  kube_prometheus_stack_enable = false
  prometheus_domain_name       = var.prometheus_domain_name

  grafana_domain_name = var.grafana_domain_name

  prometheus_alertmanager_enabled      = true
  prometheus_persistent_volume_enabled = true
  prometheus_persistent_volume_size    = "5Gi"
}
