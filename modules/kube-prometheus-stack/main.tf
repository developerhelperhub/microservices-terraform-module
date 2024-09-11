#This module is designed to manage the resources, providers, and Kubernetes Ingress configurations for the kube-prometheus-stack. It supports Helm chart version 62.3.1, which installs a comprehensive monitoring solution within the cluster. This monitoring stack includes Prometheus, Grafana, Alertmanager, Prometheus Operator, Kube-State-Metrics, Node Exporter, Prometheus Adapter, and several additional exporters.
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "62.3.1"

  count     = var.kube_prometheus_stack_enable ? 1 : 0
  namespace = var.kubernetes_namespace

  set {
    name  = "alertmanager.enabled"
    value = var.alertmanager_enabled
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = var.persistent_volume_enabled
  }

  set {
    name  = "server.persistentVolume.size"
    value = var.persistent_volume_size
  }

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }


  timeout = 600

  depends_on = [var.kubernetes_namespace]
}

# kube-prometheus-stack ingress configuration 
resource "kubernetes_ingress_v1" "kube_prometheus_stack_ingress" {

  count     = var.kube_prometheus_stack_enable ? 1 : 0

  metadata {
    name      = "kube-prometheus-stack-ingress"
    namespace = var.kubernetes_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = var.prometheus_domain_name
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "kube-prometheus-stack-prometheus"
              port {
                number = var.prometheus_service_port
              }
            }
          }
        }
      }
    }
    rule {
      host = var.grafana_domain_name
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "kube-prometheus-stack-grafana"
              port {
                number = var.grafana_service_port
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.kube_prometheus_stack[0]]
}
