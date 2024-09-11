#Installing the cluster in Docker
module "kind_cluster" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kind?ref=dev"

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
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kind/ingress?ref=dev"

  kube_endpoint               = module.kind_cluster.endpoint
  kube_client_key             = module.kind_cluster.client_key
  kube_client_certificate     = module.kind_cluster.client_certificate
  kube_cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate

  depends_on = [module.kind_cluster]
}

#Configuring the helm provider based on the cluster information
provider "helm" {
  kubernetes {
    host                   = module.kind_cluster.endpoint
    client_certificate     = module.kind_cluster.client_certificate
    client_key             = module.kind_cluster.client_key
    cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate
  }
}

#Installing the namespace in the Kuberenetes cluster
module "kubernetes_namespace" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kubernetes/namespace?ref=dev"

  namespace_name = var.kubernetes_namespace

  depends_on = [module.kind_ingress]
}

#Instaling common modules
module "common" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/common?ref=dev"
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

#Instaling the kube-prometheus-stack
module "kube_prometheus_stack" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kube-prometheus-stack?ref=dev"

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
