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
