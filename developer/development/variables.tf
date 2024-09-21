#This is variable arguments while running the terraform scripts
variable "kind_cluster_name" {
    type = string
    description = "Kind cluster name"
}

variable "prometheus_domain_name" {
    type = string
    description = "Prometheus domain name"
    default = "prometheus.microservices.com"
}

variable "grafana_domain_name" {
    type = string
    description = "Grafana domain name"
    default = "grafana.microservices.com"
}

variable "keycloak_domain_name" {
    type = string
    description = "Keycloak domain name"
    default = "keycloak.myapp.com"
}

