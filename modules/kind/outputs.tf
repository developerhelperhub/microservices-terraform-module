#These are variables used to configure in the Kubernetes and Helm configuration after creating the Kubernetes cluster
output "kubeconfig" {
  value = kind_cluster.default.kubeconfig
}

output "endpoint" {
  value = kind_cluster.default.endpoint
}

output "client_key" {
  value = kind_cluster.default.client_key
}

output "client_certificate" {
  value = kind_cluster.default.client_certificate
}

output "cluster_ca_certificate" {
  value = kind_cluster.default.cluster_ca_certificate
}