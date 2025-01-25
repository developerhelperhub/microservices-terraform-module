
#This module is designed to manage the resources, providers, and Kubernetes Ingress configurations for the Klight API Gateway

#mongodb configuration
resource "helm_release" "klight_api_gateway_mongodb" {
  name       = "klight-api-gateway-mongodb"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "mongodb"
  version    = "16.4.2"

  count     = var.klight_api_gateway_enable ? 1 : 0
  namespace = var.kubernetes_namespace

  set = [
    {
      name  = "auth.enabled"
      value = "true"
    },
    {
      name  = "auth.rootUser"
      value = var.mongodb_root_user
    },
    {
      name  = "auth.rootPassword"
      value = var.mongodb_root_password
    },
    {
      name  = "auth.username"
      value = var.mongodb_user
    },
    {
      name  = "auth.password"
      value = var.mongodb_password
    },
    {
      name  = "auth.database"
      value = var.mongodb_name
    },
    {
      name  = "service.ports.mongodb"
      value = var.mongodb_port
    },
    {
      name  = "persistence.enabled"
      value = "true"
    },
    {
      name  = "persistence.size"
      value = var.mongodb_persistence_size
    },
    {
      name  = "persistence.storageClass"
      value = var.mongodb_persistence_storage_class
    }
  ]

  wait          = false
  wait_for_jobs = false
  # timeout = 20000
}

#redis configuration 
resource "helm_release" "klight_api_gateway_redis" {
  name       = "klight-api-gateway-redis"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "redis"
  version    = "20.6.3"

  count     = var.klight_api_gateway_enable ? 1 : 0
  namespace = var.kubernetes_namespace

  set = [
    {
      name  = "auth.enabled"
      value = "true"
    },
    {
      name  = "auth.password"
      value = var.redis_password
    },
    {
      name  = "master.count"
      value = var.redis_master_count
    },
    {
      name  = "persistence.enabled"
      value = "true"
    },
    {
      name  = "persistence.size"
      value = var.redis_persistence_size
    },
    {
      name  = "autoscaling.minReplicas"
      value = var.redis_replicas_min
    },
    {
      name  = "autoscaling.maxReplicas"
      value = var.redis_replicas_max
    }
  ]

  wait          = false
  wait_for_jobs = false
  # timeout = 20000
}

resource "null_resource" "klight_api_gateway" {
  provisioner "local-exec" {
    command = "kubectl cluster-info"

    # Configuring the cluster information and these information getting from kind resource
    environment = {
      KUBERNETES_HOST        = var.kube_endpoint
      CLIENT_CERTIFICATE     = var.kube_client_certificate
      CLIENT_KEY             = var.kube_client_key
      CLUSTER_CA_CERTIFICATE = var.kube_cluster_ca_certificate
    }
  }

  depends_on = [helm_release.klight_api_gateway_mongodb[0], helm_release.klight_api_gateway_redis[0]]
}

# #API Gateway ingress configuration 
# resource "kubernetes_ingress_v1" "klight_api_gateway_ingress" {

#   count = var.klight_api_gateway_enable ? 1 : 0

#   metadata {
#     name      = "klight-api-gateway-ingress"
#     namespace = var.kubernetes_namespace
#     annotations = {
#       "nginx.ingress.kubernetes.io/rewrite-target" = "/"
#     }
#   }

#   spec {
#     rule {
#       host = var.klight_api_gateway_domain
#       http {
#         path {
#           path      = "/"
#           path_type = "ImplementationSpecific"
#           backend {
#             service {
#               name = "klight-api-gateway"
#               port {
#                 number = var.klight_api_gateway_port
#               }
#             }
#           }
#         }
#       }
#     }
#     rule {
#       host = var.klight_api_gateway_admin_domain
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "klight-api-gateway-admin"
#               port {
#                 number = var.klight_api_gateway_admin_port
#               }
#             }
#           }
#         }
#       }
#     }
#   }

#   depends_on = [helm_release.kong[0]]
# }
