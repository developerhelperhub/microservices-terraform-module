# -------------- Common ----------------
variable "microservices_service_passwords" {
  type = map(object({
    length  = number
    special = bool
    upper   = bool
    lower   = bool
  }))

  default = {
    "grafana_password"  = { length = 16, special = true, upper = true, lower = true }
    "keycloak_password" = { length = 16, special = true, upper = true, lower = true }
    "keycloak_postgres_user_password" = { length = 16, special = true, upper = true, lower = true }
    "keycloak_postgres_admin_user_password" = { length = 16, special = true, upper = true, lower = true }
    "kong_postgres_user_password" = { length = 16, special = true, upper = true, lower = true }
    "kong_postgres_admin_user_password" = { length = 16, special = true, upper = true, lower = true }
  }
}

# -------------- Cluster ----------------
variable "kind_cluster_name" {
  type        = string
  description = "Kind cluster name"
}

variable "kind_http_port" {
  type        = number
  description = "Kind cluster http expose port"
  default     = 80
}

variable "kind_https_port" {
  type        = number
  description = "Kind cluster https expose port"
  default     = 443
}

# -------------- Kubernetes Namespace ----------------

variable "kubernetes_namespace" {
  type        = string
  description = "Resources are installing in the Kubernetes namespace"
}

# -------------- Keycloak ----------------

variable "keycloak_enable" {
  type        = bool
  description = "Enable the installation"
  default     = false
}

variable "keycloak_service_port" {
  type        = number
  description = "Service port"
  default     = 80
}

variable "keycloak_domain_name" {
  type        = string
  description = "Domain name of service"
  default = "localhost"
}

variable "keycloak_admin_user" {
  type        = string
  description = "Admin username"
  default = "admin"
}

variable "keycloak_admin_password" {
  type        = string
  description = "Admin password"
  default     = "AUTO_GENERATED"
}


variable "keycloak_resources_requests_cpu" {
  type        = string
  description = "Requested cpu size"
  default     = "500m"
}

variable "keycloak_resources_requests_memory" {
  type        = string
  description = "Requested memory size"
  default     = "1024Mi"
}

variable "keycloak_resources_limit_cpu" {
  type        = string
  description = "Limit cpu size"
  default     = "500m"
}

variable "keycloak_resources_limit_memory" {
  type        = string
  description = "Limit memory size"
  default     = "1024Mi"
}

variable "keycloak_db_user" {
  type        = string
  description = "Database username"
  default     = "keycloak"
}

variable "keycloak_db_password" {
  type        = string
  description = "Database password"
  default = "AUTO_GENERATED"
}

variable "keycloak_db_name" {
  type        = string
  description = "Database name"
  default     = "keycloakdb"
}

variable "keycloak_db_port" {
  type        = number
  description = "Database port"
  default     = 5432
}

variable "keycloak_autoscaling_min_replicas" {
  type        = number
  description = "Minimum auto scalign replicas"
  default     = 1
}

variable "keycloak_autoscaling_max_replicas" {
  type        = number
  description = "Maximum auto scalign replicas"
  default     = 1
}

variable "keycloak_persistence_size" {
  type        = string
  description = "Presistance size"
  default     = "8Gi"
}

variable "keycloak_db_admin_password" {
  type        = string
  description = "Database admin password"
  default = "AUTO_GENERATED"
}


# -------------- Kong ----------------

variable "kong_enable" {
  type        = bool
  description = "Enable the installation"
  default     = false
}

variable "kong_admin_service_port" {
  type        = number
  description = "Admin service port"
  default     = 8001
}

variable "kong_admin_domain_name" {
  type        = string
  description = "Domain name of Admin API"
  default = "localhost"
}


variable "kong_proxy_service_port" {
  type        = number
  description = "Proxy service port"
  default     = 80
}

variable "kong_proxy_domain_name" {
  type        = string
  description = "Domain name of Proxy service"
  default = "localhost"
}

variable "kong_db_user" {
  type        = string
  description = "Database username"
  default     = "keycloak"
}

variable "kong_db_password" {
  type        = string
  description = "Database password"
  default = "AUTO_GENERATED"
}

variable "kong_db_name" {
  type        = string
  description = "Database name"
  default     = "keycloakdb"
}

variable "kong_db_port" {
  type        = number
  description = "Database port"
  default     = 5432
}

variable "kong_persistence_size" {
  type        = string
  description = "Presistance size"
  default     = "8Gi"
}

variable "kong_db_admin_password" {
  type        = string
  description = "Database admin password"
  default = "AUTO_GENERATED"
}

# -------------- Kube Prometheus Stack ----------------

variable "kube_prometheus_stack_enable" {
  type        = bool
  description = "Enable the installation of Jfrog"
  default     = false
}

variable "prometheus_service_port" {
  type        = number
  description = "Prometheus service port"
  default     = 80
}

variable "prometheus_domain_name" {
  type        = string
  description = "Prometheus domain name"
  default = "localhost"
}

variable "grafana_service_port" {
  type        = number
  description = "Grafana Service port"
  default     = 80
}

variable "grafana_domain_name" {
  type        = string
  description = "Grafana Domain name"
  default = "localhost"
}

variable "grafana_admin_password" {
  type        = string
  description = "Grafana admin password"
  default     = "AUTO_GENERATED"
}

variable "prometheus_alertmanager_enabled" {
  type        = bool
  description = "Prometheus alertmanager whether enabled / desabled, default is enabled"
  default     = true
}

variable "prometheus_persistent_volume_enabled" {
  type        = bool
  description = "Prometheus volume whether enabled / desabled, default is enabled"
  default     = true
}

variable "prometheus_persistent_volume_size" {
  type        = string
  description = "Prometheus volume whether enabled / desabled, default size is 1Gi"
  default     = "1Gi"
}

