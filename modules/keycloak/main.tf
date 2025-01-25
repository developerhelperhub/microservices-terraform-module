
#This module is designed to manage the resources, providers, and Kubernetes Ingress configurations for the keycloak It supports Helm chart version 22.2.3

#postgres configuration
resource "helm_release" "keycloak_postgresql" {
  name       = "keycloak-postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.5.34"

  count     = var.keycloak_enable ? 1 : 0
  namespace = var.kubernetes_namespace

  set = [{
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
}

#keyloack configuration 
resource "helm_release" "keycloak" {
  name       = "keycloak"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  version    = "22.2.6"

  count     = var.keycloak_enable ? 1 : 0
  namespace = var.kubernetes_namespace

  set = [{
    name  = "image.pullPolicy"
    value = "IfNotPresent"
    },
    {
      name  = "auth.adminUser"
      value = var.admin_user
    },
    {
      name  = "auth.adminPassword"
      value = var.admin_password
    },
    {
      name  = "resources.requests.cpu"
      value = var.resources_requests_cpu
    },
    {
      name  = "resources.requests.memory"
      value = var.resources_requests_memory
    },
    {
      name  = "resources.limits.cpu"
      value = var.resources_limit_cpu
    },
    {
      name  = "resources.limits.memory"
      value = var.resources_limit_memory
    },
    {
      name  = "postgresql.enabled"
      value = "false"
    },
    {
      name  = "networkPolicy.enabled"
      value = "false"
    },
    {
      name  = "externalDatabase.host"
      value = "keycloak-postgresql.${var.kubernetes_namespace}.svc.cluster.local"
    },
    {
      name  = "externalDatabase.user"
      value = var.db_user
    },
    {
      name  = "externalDatabase.password"
      value = var.db_password
    },
    {
      name  = "externalDatabase.database"
      value = var.db_name
    },
    {
      name  = "externalDatabase.port"
      value = var.db_port
    },
    {
      name  = "autoscaling.enabled"
      value = false
    },
    {
      name  = "autoscaling.minReplicas"
      value = var.autoscaling_min_replicas
    },
    {
      name  = "autoscaling.minReplicas"
      value = var.autoscaling_max_replicas
  }]

  # wait          = false
  # wait_for_jobs = false
  timeout = 20000

  depends_on = [helm_release.keycloak_postgresql[0]]
}

#keyloack ingress configuration 
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
