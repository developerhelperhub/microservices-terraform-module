module "microservices" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//microservices?ref=klight-api-gateway"

  kind_cluster_name = var.kind_cluster_name
  kind_http_port    = 80
  kind_https_port   = 443

  kubernetes_namespace = "microservices"

  keycloak_enable      = true
  keycloak_domain_name = var.keycloak_domain_name

  keycloak_admin_user     = "admin"
  keycloak_admin_password = "MyPassword2222@"

  keycloak_resources_requests_cpu    = "500m"
  keycloak_resources_requests_memory = "1024Mi"
  keycloak_resources_limit_cpu       = "500m"
  keycloak_resources_limit_memory    = "1024Mi"
  keycloak_db_user                   = "mykeycloak"
  keycloak_db_name                   = "mykeycloakdb"
  keycloak_db_password               = "MyPassword2222@"
  keycloak_db_admin_password         = "MyPassword2222@"
  keycloak_autoscaling_min_replicas  = 1
  keycloak_autoscaling_max_replicas  = 1
  keycloak_persistence_size          = "8Gi"

  klight_api_gateway_enable       = true
  klight_api_gateway_domain       = var.klight_api_gateway_domain
  klight_api_gateway_port         = 80
  klight_api_gateway_admin_domain = var.klight_api_gateway_admin_domain
  klight_api_gateway_admin_port   = 80

  klight_api_gateway_mongodb_root_user        = "root"
  klight_api_gateway_mongodb_root_password    = "klight-api-gateway"
  klight_api_gateway_mongodb_user             = "klight-api-gateway"
  klight_api_gateway_mongodb_name             = "klight-api-gateway"
  klight_api_gateway_mongodb_persistence_size = "1Gi"
  klight_api_gateway_mongodb_password         = "klight-api-gateway"


  klight_api_gateway_redis_password         = "redis-mas-pass"
  klight_api_gateway_redis_master_count     = 1
  klight_api_gateway_redis_persistence_size = "1Gi"
  klight_api_gateway_redis_replicas_min     = 1
  klight_api_gateway_redis_replicas_max     = 1

  # kong_enable            = false
  # kong_admin_domain_name = var.kong_admin_domain_name
  # kong_proxy_domain_name = var.kong_proxy_domain_name

  # kong_db_user           = "mykong"
  # kong_db_name           = "mykongdb"
  # kong_db_password       = "MyPassword2222@"
  # kong_db_admin_password = "MyPassword2222@"
  # kong_persistence_size  = "5Gi"

  # kube_prometheus_stack_enable = false
  # prometheus_domain_name       = var.prometheus_domain_name

  # grafana_domain_name = var.grafana_domain_name

  # prometheus_alertmanager_enabled      = true
  # prometheus_persistent_volume_enabled = true
  # prometheus_persistent_volume_size    = "5Gi"
}
