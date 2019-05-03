resource "kubernetes_daemonset" "traefik_controller" {
  metadata {
    name      = "traefik-controller"
    namespace = "${kubernetes_namespace.traefik.metadata.0.name}"

    labels {
      k8s-app = "traefik-ingress-lb"
    }
  }

  spec {
    #replicas = 1
    selector = {
      match_labels {
        k8s-app = "traefik-ingress-lb"
        name    = "traefik-ingress-lb"
      }
    }

    template {
      metadata {
        labels {
          k8s-app = "traefik-ingress-lb"
          name    = "traefik-ingress-lb"
        }
      }

      spec {
        service_account_name             = "${kubernetes_service_account.traefik_controller_admin.metadata.0.name}"
        termination_grace_period_seconds = 60

        volume {
          name = "${kubernetes_config_map.traefik_configmap.metadata.0.name}"
          config_map {
            name = "${kubernetes_config_map.traefik_configmap.metadata.0.name}"
          }
        }

        container {
          image = "traefik:2.0"        # The official v2.0 Traefik docker image
          name  = "traefik-ingress-lb"

          port {
            name           = "http"
            host_port = 80
            container_port = 80
          }

          port {
            name           = "dashboard"
            host_port = 8080
            container_port = 8080
          }

          port {
            name           = "mongo"
            host_port = 27017
            container_port = 27017
          }

          port {
            name           = "redis"
            host_port = 6379
            container_port = 6379
          }

          volume_mount {
            mount_path = "/config"
            name = "${kubernetes_config_map.traefik_configmap.metadata.0.name}"
            read_only  = false
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          args = [
            "--api",
            "--configfile=/config/traefik.toml"
          ]
        }
      }
    }
  }
}
