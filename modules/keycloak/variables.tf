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

variable "persistence_size" {
  type        = string
  description = "Presistance size"
}
