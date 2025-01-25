
#This module is designed to manage the resources, providers, and Kubernetes Ingress configurations for the kong It supports Helm chart version 2.41.1

#postgres configuration
resource "helm_release" "kong_postgresql" {
  name       = "kong-postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.5.34"

  count     = var.kong_enable ? 1 : 0
  namespace = var.kubernetes_namespace

  set = [
    {
      name  = "image.pullPolicy"
      value = "IfNotPresent"
    },
    {
      name  = "persistence.enabled"
      value = "true"
    },
    {
      name  = "persistence.size"
      value = var.persistence_size
    },
    {
      name  = "auth.database"
      value = var.db_name
    },
    {
      name  = "auth.username"
      value = var.db_user
    },
    {
      name  = "auth.postgresPassword"
      value = var.db_admin_password
    },
    {
      name  = "auth.password"
      value = var.db_password
    }
  ]

  wait          = false
  wait_for_jobs = false
  # timeout = 20000
}

#keyloack configuration 
resource "helm_release" "kong" {
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"
  version    = "2.41.1"

  count     = var.kong_enable ? 1 : 0
  namespace = var.kubernetes_namespace

  set = [
    {
      name  = "image.pullPolicy"
      value = "IfNotPresent"
    },
    {
      name  = "image.repository"
      value = "developerhelperhub/kong-openid"
    },
    {
      name  = "image.tag"
      value = "v1.0.0"
    },
    {
      name  = "ingressController.installCRDs"
      value = false
    },
    {
      name  = "admin.enabled"
      value = true
    },
    {
      name  = "admin.type"
      value = "ClusterIP"
    },
    {
      name  = "admin.tls.enabled"
      value = false
    },
    {
      name  = "admin.http.enabled"
      value = true
    },
    {
      name  = "admin.http.servicePort"
      value = 8001
    },
    {
      name  = "proxy.enabled"
      value = true
    },
    {
      name  = "proxy.type"
      value = "ClusterIP"
    },
    {
      name  = "postgresql.enabled"
      value = "false"
    },
    {
      name  = "env.database"
      value = "postgres"
    },
    {
      name  = "env.pg_host"
      value = "kong-postgresql.${var.kubernetes_namespace}.svc.cluster.local"
    },
    {
      name  = "env.pg_port"
      value = var.db_port
    },
    {
      name  = "env.pg_user"
      value = var.db_user
    },
    {
      name  = "env.pg_password"
      value = var.db_password
    },
    {
      name  = "env.pg_database"
      value = var.db_name
    }
  ]

  # set {
  #   name  = "env.plugins"
  #   value = "kong-oidc"
  # }

  # wait          = false
  # wait_for_jobs = false
  timeout = 20000

  depends_on = [helm_release.kong_postgresql[0]]
}

#keyloack ingress configuration 
resource "kubernetes_ingress_v1" "kong_ingress" {

  count = var.kong_enable ? 1 : 0

  metadata {
    name      = "kong-ingress"
    namespace = var.kubernetes_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = var.admin_domain_name
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "kong-kong-admin"
              port {
                number = var.admin_service_port
              }
            }
          }
        }
      }
    }
    rule {
      host = var.proxy_domain_name
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "kong-kong-proxy"
              port {
                number = var.proxy_service_port
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.kong[0]]
}
