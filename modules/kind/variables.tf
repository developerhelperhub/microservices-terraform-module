variable "name" {
  type        = string
  description = "Cluster name"
}

variable "http_port" {
  type        = number
  description = "Exposing http port number"
  default     = 80
}

variable "https_port" {
  type        = number
  description = "Exposing https port number"
  default     = 443
}
