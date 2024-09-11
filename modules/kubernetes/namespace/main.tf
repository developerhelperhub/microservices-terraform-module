resource "kubernetes_namespace" "microservices" {
  metadata {
    name = var.namespace_name
  }
}
