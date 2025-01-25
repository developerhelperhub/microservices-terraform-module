variable "kubernetes_namespace" {
  type        = string
  description = "Namepace of kubernetes the service need to install"
}

variable "klight_api_gateway_enable" {
  type        = bool
  description = "Enable the installation"
  default     = false
}

variable "klight_api_gateway_domain" {
  type        = string
  description = "Domain name of Api Gateway"
}

variable "klight_api_gateway_port" {
  type        = number
  description = "Port name of Api Gateway"
}

variable "klight_api_gateway_admin_domain" {
  type        = string
  description = "Domain name of Admin Service"
}

variable "klight_api_gateway_admin_port" {
  type        = number
  description = "Port name of Admin Service"
}

#------------------- Kub configuration ---------------------

variable "kube_endpoint" {
  type        = string
  description = "Endpoint"
}

variable "kube_client_key" {
  type        = string
  description = "Client key"
}

variable "kube_client_certificate" {
  type        = string
  description = "Client certificate"
}

variable "kube_cluster_ca_certificate" {
  type        = string
  description = "Client ca certificate"
}


#------------------- Mongo DB configuration ---------------------

variable "mongodb_root_user" {
  type        = string
  description = "Database root password"
  default = "root"
}

variable "mongodb_root_password" {
  type        = string
  description = "Database root password"
}

variable "mongodb_user" {
  type        = string
  description = "Database username"
  default     = "klight-api-gateway"
}

variable "mongodb_password" {
  type        = string
  description = "Database password"
}

variable "mongodb_name" {
  type        = string
  description = "Database name"
  default     = "klight-api-gateway"
}

variable "mongodb_port" {
  type        = number
  description = "Database port"
  default     = 27017
}

variable "mongodb_persistence_size" {
  type        = string
  description = "Presistance size"
  default     = "1Gi"
}

variable "mongodb_persistence_storage_class" {
  type        = string
  description = "Presistance storage class"
  default = "standard"
}

#------------------- Redis configuration ---------------------

variable "redis_password" {
  type        = string
  description = "Password"
}


variable "redis_master_count" {
  type        = number
  description = "Number of master count"
  default = 1
}

variable "redis_persistence_size" {
  type        = string
  description = "Presistance size"
  default = "1Gi"
}

variable "redis_replicas_min" {
  type        = number
  description = "Min number of replicas"
  default = 1
}

variable "redis_replicas_max" {
  type        = number
  description = "Max number of replicas"
  default = 1
}


