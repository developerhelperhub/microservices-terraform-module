variable "kubernetes_namespace" {
  type        = string
  description = "Namepace of kubernetes the service need to install"
}

variable "kong_enable" {
  type        = bool
  description = "Enable the installation"
  default     = false
}

variable "admin_service_port" {
  type        = number
  description = "Admin service port"
  default     = 8001
}

variable "admin_domain_name" {
  type        = string
  description = "Domain name of Admin API"
  default = "localhost"
}

variable "proxy_service_port" {
  type        = number
  description = "Proxy service port"
  default     = 80
}

variable "proxy_domain_name" {
  type        = string
  description = "Domain name of Proxy service"
  default = "localhost"
}

variable "db_user" {
  type        = string
  description = "Database username"
  default     = "kongapigateway"
}

variable "db_password" {
  type        = string
  description = "Database password"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "kongapigatewaydb"
}

variable "db_port" {
  type        = number
  description = "Database port"
  default     = 5432
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
