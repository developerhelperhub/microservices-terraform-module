This is terraform module repository to maintain the version microservice related resources to install inside the Kubernetes cluster. 

**Following the resources and provider supports in this module**

| Module                            | Description                                                                                                                                                                                                                                                                                                                                                 |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Setup the Kind                    | This module is used to manage Kind-related resources, providers and kind ingress controller script file. The Kind support version 1.27.1                                                                                                                                                                                                                    |
| Setup the Kind Ingress Controller | This module is used to manage Kind ingress controller resource and this resource installing by Kubernetes shell script command.                                                                                                                                                                                                                             |
| Setup the Helm provider           | This module is used to manage Helm-related resources and providers. The Helm support version 2.15 or above.                                                                                                                                                                                                                                                 |
| Setup the Kubernetes provider     | This module is used to manage Kubernetes-related resources, providers. The Kubernetes support version 2.31 or above                                                                                                                                                                                                                                         |
| Setup the Kubernetes Namespace    | This module is used to manage Kubernetes namespace-related resources, providers.                                                                                                                                                                                                                                                                            |
| Setup the common module           | This module is used to manage the common resources and providers needed in the root and child modules of "microservice." In this example, we are using the "random_password" resource to generate a password for Grafana, Keycloak, etc.                                                                                                                                         |
| Setup the Keycloak                 | This module is used to manage Keycloak resources, providers and Kubernetes ingress configuration. The Helm Keycloak support version 22.2.3                                                                                                                                                                                                            |
| Setup the Kube Prometheus Stack                 | This module is designed to manage the resources, providers, and Kubernetes Ingress configurations for the kube-prometheus-stack. It supports Helm chart version 62.3.1, which installs a comprehensive monitoring solution within the cluster. This monitoring stack includes Prometheus, Grafana, Alertmanager, Prometheus Operator, Kube-State-Metrics, Node Exporter, Prometheus Adapter, and several additional exporters.                                                                                                                                                                                                           |
| Setup Microservices                      | This is the main module for managing all Microservice-related modules and includes the installation steps for services that need to be deployed on the Kubernetes cluster. In this example, we configure Microservices tools required for the application, such as Kind Cluster, Kind Ingress Controller, Kubernetes provider and namespace, Helm provider, and Keycloak, Kong API Gateway, etc. |

## Usage of Microservices Module 

We easily use to “microservices” module to setup resources inside the Kubernetes cluster locally, this cluster create on docker container in our local machine.

`main.tf` terraform script
```shell
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
 
  keycloak_resources_requests_cpu    = "500m"
  keycloak_resources_requests_memory = "1024Mi"
  keycloak_resources_limit_cpu       = "500m"
  keycloak_resources_limit_memory    = "1024Mi"
  keycloak_db_password="MyPassword2222@"
  keycloak_db_admin_password="MyPassword2222@"
  keycloak_autoscaling_min_replicas  = 1
  keycloak_autoscaling_max_replicas  = 1
  keycloak_persistence_size          = "8Gi"

  kube_prometheus_stack_enable = false
  prometheus_domain_name       = var.prometheus_domain_name

  grafana_domain_name = var.grafana_domain_name

  prometheus_alertmanager_enabled      = true
  prometheus_persistent_volume_enabled = true
  prometheus_persistent_volume_size    = "5Gi"
}
```
## Usage of Kind Module

We easily use to “kind” module to setup create the cluster in docker container in our local machine

`main.tf` terraform script
```shell
#Installing the cluster in Docker
module "kind_cluster" {
    source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kind?ref=dev"
    name = 'test-my-cluster'
    http_port = 80
    https_port = 443
}
```
## Usage of Kind Ingress Module

We easily use to “kind ingress” module to install ingress the controller in the Kind Kubernetes cluster.

`main.tf` terraform script
```shell
#Installing the ingress controller in the cluster, this ingress support by kind. This ingress controller will be different based on the clusters such as AWS, Azure, Etc.
module "kind_ingress" {
    source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kind/ingress?ref=dev"
    kube_endpoint = module.kind_cluster.endpoint
    kube_client_key = module.kind_cluster.client_key
    kube_client_certificate = module.kind_cluster.client_certificate
    kube_cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate
    depends_on = [module.kind_cluster]
}
```
## Usage of Helm Module

We easily use to “helm” module to configure helm provider

`main.tf` terraform script
```shell
#Configuring the helm provider based on the cluster information
provider "helm" {
    kubernetes {
        host                   = module.kind_cluster.endpoint
        client_certificate     = module.kind_cluster.client_certificate
        client_key             = module.kind_cluster.client_key
        cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate
    }
}
```

## Usage of Kubernetes Module

We easily use to “kubernetes” module to configure Kubernetes provider

`main.tf` terraform script
```shell
#Configuring the kubenretes provider based on the cluster information
provider "kubernetes" {
    host                   = module.kind_cluster.endpoint
    client_certificate     = module.kind_cluster.client_certificate
    client_key             = module.kind_cluster.client_key
    cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate
}
```
## Usage of Kubernetes Namespace Module

We easily use to “kubernetes namespace” module to create the namespace Kubernetes cluster.

`main.tf` terraform script
```shell
#Installing the namespace in the Kuberenetes cluster
module "kubernetes_namespace" {
    source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kubernetes/namespace?ref=dev"
    namespace_name = 'microservices'
    depends_on = [module.kind_ingress]
}
```


## Usage of Keycloak Module

We easily use to keycloak module to install the Keycloak inside Kubernetes namespace.

`main.tf` terraform script
```shell
#Instaling the keycloak
module "keycloak" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/keycloak?ref=dev"

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
```

## Usage of Kube Prometheus Stack Module

We easily use to kube-prometheus-stack module to install the Kube Prometheus Stack inside Kubernetes namespace.

`main.tf` terraform script
```shell
#Instaling the kube-prometheus-stack
module "kube_prometheus_stack" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//modules/kube-prometheus-stack?ref=dev"

  kube_prometheus_stack_enable = var.kube_prometheus_stack_enable
  kubernetes_namespace         = module.kubernetes_namespace.namespace

  prometheus_service_port = var.prometheus_service_port
  prometheus_domain_name  = var.prometheus_domain_name

  grafana_domain_name    = var.grafana_domain_name
  grafana_service_port   = var.grafana_service_port
  grafana_admin_password = var.grafana_admin_password

  alertmanager_enabled      = var.prometheus_alertmanager_enabled
  persistent_volume_enabled = var.prometheus_persistent_volume_enabled
  persistent_volume_size    = var.prometheus_persistent_volume_size

  depends_on = [module.kubernetes_namespace]
}
```