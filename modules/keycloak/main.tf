#This module is designed to manage the resources, providers, and Kubernetes Ingress configurations for the keycloak It supports Helm chart version 22.2.6
resource "helm_release" "keycloak" {
  name       = "keycloak"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  version    = "22.2.6"

  count     = var.keycloak_enable ? 1 : 0
  namespace = var.kubernetes_namespace

  set {
    name  = "auth.adminUser"
    value = var.admin_user
  }

  set {
    name  = "auth.adminPassword"
    value = var.admin_password
  }

  set {
    name  = "persistence.enabled"
    value = true
  }

  set {
    name  = "persistence.size"
    value = var.persistence_size
  }


  timeout = 600

  depends_on = [var.kubernetes_namespace]
}

# kube-prometheus-stack ingress configuration 
resource "kubernetes_ingress_v1" "keycloak_ingress" {

  count = var.keycloak_enable ? 1 : 0

  metadata {
    name      = "keycloak-ingress"
    namespace = var.kubernetes_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = var.domain_name
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = helm_release.keycloak[0].name
              port {
                number = var.service_port
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.keycloak[0]]
}
