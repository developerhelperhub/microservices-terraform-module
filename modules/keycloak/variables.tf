variable "kubernetes_namespace" {
  type        = string
  description = "Namepace of kubernetes the service need to install"
}

variable "keycloak_enable" {
  type        = bool
  description = "Enable the installation"
  default     = false
}

variable "service_port" {
  type        = number
  description = "Service port"
  default     = 80
}

variable "domain_name" {
  type        = string
  description = "Domain name of service"
}

variable "admin_user" {
  type        = string
  description = "Admin username"
}

variable "admin_password" {
  type        = string
  description = "Admin password"
}

variable "resources_requests_cpu" {
  type        = string
  description = "Requested cpu size"
  default     = "500m"
}

variable "resources_requests_memory" {
  type        = string
  description = "Requested memory size"
  default     = "1024Mi"
}

variable "resources_limit_cpu" {
  type        = string
  description = "Limit cpu size"
  default     = "500m"
}

variable "resources_limit_memory" {
  type        = string
  description = "Limit memory size"
  default     = "1024Mi"
}

variable "db_user" {
  type        = string
  description = "Database username"
  default     = "keycloak"
}

variable "db_password" {
  type        = string
  description = "Database password"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "keycloakdb"
}

variable "db_port" {
  type        = number
  description = "Database port"
  default     = 5432
}

variable "autoscaling_min_replicas" {
  type        = number
  description = "Minimum auto scalign replicas"
  default     = 1
}

variable "autoscaling_max_replicas" {
  type        = number
  description = "Maximum auto scalign replicas"
  default     = 1
}

variable "persistence_size" {
  type        = string
  description = "Presistance size"
  default     = "8Gi"
}

variable "db_admin_password" {
  type        = string
  description = "Database admin password"
}
