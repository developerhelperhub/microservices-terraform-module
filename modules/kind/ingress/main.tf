#This module is used to manage Kind ingress controller resource and this resource installing by Kubernetes shell script command.
resource "null_resource" "apply_kubectl" {
  provisioner "local-exec" {
    # Service Type and Port are "LoadBalancer" and 80
    command = "kubectl apply -f ${path.module}/ingress-nginx.yaml"
    
    # Configuring the cluster information and these information getting from kind resource
    environment = {
      KUBERNETES_HOST       = var.kube_endpoint
      CLIENT_CERTIFICATE    = var.kube_client_certificate
      CLIENT_KEY            = var.kube_client_key
      CLUSTER_CA_CERTIFICATE = var.kube_cluster_ca_certificate
    }
  }
}