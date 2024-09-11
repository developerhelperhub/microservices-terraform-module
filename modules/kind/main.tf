#This module is used to manage Kind-related resources, providers and kind ingress controller script file. The Kind support version 1.27.1 or above.
resource "kind_cluster" "default" {
    name           = var.name
    node_image = "kindest/node:v1.27.1"
    wait_for_ready = true

  kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
          role = "control-plane"
          
          #Ingress enabledd
          kubeadm_config_patches = [
              "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
          ]

          # Exposing the ports are http and https in the cluster
          extra_port_mappings {
              container_port = var.http_port
              host_port      = var.http_port
          }
          extra_port_mappings {
              container_port = var.https_port
              host_port      = var.https_port
          }
      }
  }
}
