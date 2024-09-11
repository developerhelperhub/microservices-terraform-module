variable "kubernetes_namespace" {
  type        = string
  description = "Namepace of kubernetes the service need to install"
}

variable "kube_prometheus_stack_enable" {
  type        = bool
  description = "Enable the installation of Jfrog"
  default = false
}

variable "prometheus_service_port" {
  type        = number
  description = "Prometheus Service port"
  default     = 9090
}

variable "prometheus_domain_name" {
  type        = string
  description = "Prometheus Domain name"
}

variable "grafana_service_port" {
  type        = number
  description = "Grafana Service port"
  default     = 80
}

variable "grafana_domain_name" {
  type        = string
  description = "Grafana Domain name"
}

variable "grafana_admin_password" {
  type        = string
  description = "Grafana admin password"
}

variable "alertmanager_enabled" {
  type        = bool
  description = "Alertmanager whether enabled / desabled, default is enabled"
  default     = true
}

variable "persistent_volume_enabled" {
  type        = bool
  description = "Volume whether enabled / desabled, default is enabled"
  default     = true
}

variable "persistent_volume_size" {
  type        = string
  description = "Volume whether enabled / desabled, default size is 1Gi"
  default     = "1Gi"
}
