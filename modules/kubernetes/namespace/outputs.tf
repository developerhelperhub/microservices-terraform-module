
#This namespace is using to create the resources under Microservices cluster
output "namespace" {
  value = kubernetes_namespace.microservices.metadata[0].name
}