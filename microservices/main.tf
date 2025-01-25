#Installing the cluster in Docker
module "kind_cluster" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kind?ref=klight-api-gateway"

  name       = var.kind_cluster_name
  http_port  = 80
  https_port = 443
}


#Configuring the kubenretes provider based on the cluster information
provider "kubernetes" {

  host                   = module.kind_cluster.endpoint
  client_certificate     = module.kind_cluster.client_certificate
  client_key             = module.kind_cluster.client_key
  cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate
}

#Installing the ingress controller in the cluster, this ingress support by kind. This ingress controller will be different based on the clusters such as AWS, Azure, Etc.
module "kind_ingress" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kind/ingress?ref=klight-api-gateway"

  kube_endpoint               = module.kind_cluster.endpoint
  kube_client_key             = module.kind_cluster.client_key
  kube_client_certificate     = module.kind_cluster.client_certificate
  kube_cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate

  depends_on = [module.kind_cluster]
}

#Configuring the helm provider based on the cluster information
provider "helm" {
  kubernetes = {
    host                   = module.kind_cluster.endpoint
    client_certificate     = module.kind_cluster.client_certificate
    client_key             = module.kind_cluster.client_key
    cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate
  }
}

#Instaling helm modules
module "helm" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/helm?ref=klight-api-gateway"
}


#Installing the namespace in the Kuberenetes cluster
module "kubernetes_namespace" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kubernetes/namespace?ref=klight-api-gateway"

  namespace_name = var.kubernetes_namespace

  depends_on = [module.kind_ingress]
}

#Instaling common modules
module "common" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/common?ref=klight-api-gateway"
}

#This resource is designed to generate a password across the system to enhance security. It can be used to create passwords for users, ensuring that each password includes special characters, uppercase and lowercase letters, and default numbers. You can also specify which special characters should be included in the password.
resource "random_password" "microservices_random_service_passwords" {
  for_each         = var.microservices_service_passwords
  length           = each.value.length
  special          = each.value.special
  upper            = each.value.upper
  lower            = each.value.lower
  override_special = "#$%&" # Only these special characters are allowed
}


#Instaling the kong
module "kong" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kong?ref=klight-api-gateway"

  kong_enable          = var.kong_enable
  kubernetes_namespace = module.kubernetes_namespace.namespace

  admin_service_port = var.kong_admin_service_port
  admin_domain_name  = var.kong_admin_domain_name

  proxy_domain_name  = var.kong_proxy_domain_name
  proxy_service_port = var.kong_proxy_service_port

  db_user           = var.kong_db_user
  db_password       = var.kong_db_password == "AUTO_GENERATED" ? random_password.microservices_random_service_passwords["kong_postgres_user_password"].result : var.kong_db_password
  db_name           = var.kong_db_name
  db_port           = var.kong_db_port
  persistence_size  = var.kong_persistence_size
  db_admin_password = var.kong_db_admin_password == "AUTO_GENERATED" ? random_password.microservices_random_service_passwords["kong_postgres_admin_user_password"].result : var.kong_db_admin_password

  depends_on = [module.kubernetes_namespace]
}



#Instaling the klight-api-gateway
module "klight_api_gateway" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/klight-api-gateway?ref=klight-api-gateway"

  klight_api_gateway_enable = var.klight_api_gateway_enable
  kubernetes_namespace      = module.kubernetes_namespace.namespace

  klight_api_gateway_domain = var.klight_api_gateway_domain
  klight_api_gateway_port   = var.klight_api_gateway_port

  klight_api_gateway_admin_domain = var.klight_api_gateway_admin_domain
  klight_api_gateway_admin_port   = var.klight_api_gateway_admin_port

  kube_endpoint               = module.kind_cluster.endpoint
  kube_client_key             = module.kind_cluster.client_key
  kube_client_certificate     = module.kind_cluster.client_certificate
  kube_cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate

  mongodb_root_user                 = var.klight_api_gateway_mongodb_root_user
  mongodb_root_password             = var.klight_api_gateway_mongodb_root_password == "AUTO_GENERATED" ? random_password.microservices_random_service_passwords["klight_api_gateway_mongodb_root_password"].result : var.klight_api_gateway_mongodb_root_password
  mongodb_user                      = var.klight_api_gateway_mongodb_user
  mongodb_name                      = var.klight_api_gateway_mongodb_name
  mongodb_port                      = var.klight_api_gateway_mongodb_port
  mongodb_persistence_size          = var.klight_api_gateway_mongodb_persistence_size
  mongodb_persistence_storage_class = var.klight_api_gateway_mongodb_persistence_storage_class
  mongodb_password                  = var.klight_api_gateway_mongodb_password == "AUTO_GENERATED" ? random_password.microservices_random_service_passwords["klight_api_gateway_mongodb_password"].result : var.klight_api_gateway_mongodb_password


  redis_password         = var.klight_api_gateway_redis_password == "AUTO_GENERATED" ? random_password.microservices_random_service_passwords["klight_api_gateway_redis_password"].result : var.klight_api_gateway_redis_password
  redis_master_count     = var.klight_api_gateway_redis_master_count
  redis_persistence_size = var.klight_api_gateway_redis_persistence_size
  redis_replicas_min     = var.klight_api_gateway_redis_replicas_min
  redis_replicas_max     = var.klight_api_gateway_redis_replicas_max

  depends_on = [module.kubernetes_namespace]
}

#Instaling the keycloak
module "keycloak" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/keycloak?ref=klight-api-gateway"

  keycloak_enable      = var.keycloak_enable
  kubernetes_namespace = module.kubernetes_namespace.namespace

  service_port = var.keycloak_service_port
  domain_name  = var.keycloak_domain_name

  admin_user     = var.keycloak_admin_user
  admin_password = var.keycloak_admin_password == "AUTO_GENERATED" ? random_password.microservices_random_service_passwords["keycloak_password"].result : var.keycloak_admin_password

  resources_requests_cpu    = var.keycloak_resources_requests_cpu
  resources_requests_memory = var.keycloak_resources_requests_memory
  resources_limit_cpu       = var.keycloak_resources_limit_cpu
  resources_limit_memory    = var.keycloak_resources_limit_memory
  db_user                   = var.keycloak_db_user
  db_password               = var.keycloak_db_password == "AUTO_GENERATED" ? random_password.microservices_random_service_passwords["keycloak_postgres_user_password"].result : var.keycloak_db_password
  db_name                   = var.keycloak_db_name
  db_port                   = var.keycloak_db_port
  autoscaling_min_replicas  = var.keycloak_autoscaling_min_replicas
  autoscaling_max_replicas  = var.keycloak_autoscaling_max_replicas
  persistence_size          = var.keycloak_persistence_size
  db_admin_password         = var.keycloak_db_admin_password == "AUTO_GENERATED" ? random_password.microservices_random_service_passwords["keycloak_postgres_admin_user_password"].result : var.keycloak_db_admin_password

  depends_on = [module.kubernetes_namespace]
}


#Instaling the kube-prometheus-stack
module "kube_prometheus_stack" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kube-prometheus-stack?ref=klight-api-gateway"

  kube_prometheus_stack_enable = var.kube_prometheus_stack_enable
  kubernetes_namespace         = module.kubernetes_namespace.namespace

  prometheus_service_port = var.prometheus_service_port
  prometheus_domain_name  = var.prometheus_domain_name

  grafana_domain_name    = var.grafana_domain_name
  grafana_service_port   = var.grafana_service_port
  grafana_admin_password = var.grafana_admin_password == "AUTO_GENERATED" ? random_password.microservices_random_service_passwords["grafana_password"].result : var.grafana_admin_password

  alertmanager_enabled      = var.prometheus_alertmanager_enabled
  persistent_volume_enabled = var.prometheus_persistent_volume_enabled
  persistent_volume_size    = var.prometheus_persistent_volume_size

  depends_on = [module.kubernetes_namespace]
}
