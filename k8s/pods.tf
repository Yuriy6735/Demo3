################
### K8S PODs ###
################

resource "kubernetes_deployment" "mongo-master" {
  metadata {
    name = "mongo-master"
    namespace = "${kubernetes_namespace.mongo_space.metadata.0.name}"

    labels {
      app  = "mongo"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "mongo"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "mongo"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "bitnami/mongodb:latest"
          name  = "master"

          port {
            container_port = 27017
          }

          env {
            name  = "MONGODB_DATABASE"
            value = "${var.MONGODB_DATABASE}"
          }

          env {
            name  = "MONGODB_USERNAME"
            value = "${var.MONGODB_USERNAME}"
          }

          env {
            name  = "MONGODB_PASSWORD"
            value = "${var.MONGODB_PASSWORD}"
          }

          env {
            name  = "MONGODB_ROOT_PASSWORD"
            value = "${var.MONGODB_ROOT_PASSWORD}"
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "redis-master" {
  metadata {
    name = "redis-master"
    namespace = "${kubernetes_namespace.redis_space.metadata.0.name}"

    labels {
      app  = "redis"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "redis"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "redis"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "k8s.gcr.io/redis:e2e"
          name  = "master"

          port {
            container_port = 6379
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "custom-files" {
  metadata {
    name = "custom-files"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "2Gi"
      }
    }

    storage_class_name = "standard"
  }
}

resource "kubernetes_deployment" "jupyter-notebook" {
  metadata {
    name = "jupyter-notebook"

    labels {
      app  = "jupyter-notebook"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "jupyter-notebook"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "jupyter-notebook"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        security_context {
          fs_group = 100
        }
        volume {
          name      = "myfiles"
        }
        container {
          image = "jupyter/all-spark-notebook"
          name  = "minimal-notebook"
          command = [ "start-notebook.sh" ]
            args = [
              "--NotebookApp.base_url='/jupyterx'",
              "--NotebookApp.token='secretjupyterxtoken'"
            ]

          volume_mount {
            mount_path = "/home/jovyan/work"
            name       = "myfiles"
            read_only = false
          }

          port {
            container_port = 8888
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_deployment" "telebot" {
  metadata {
    name = "telebot"

    labels {
      app  = "telebot"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "telebot"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "telebot"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "denizka/telebot:v0.3"
          name  = "master"
          /*env {
            name  = "api_telegram"
            value = "${var.api_telegram}"
          }
          env {
            name  = "ip_redis"
            value = "${kubernetes_service.redis-master.load_balancer_ingress.0.ip}"
          }*/
          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
          }}
        }
      }
    }
  }
}

resource "kubernetes_deployment" "tf" {
  metadata {
    name = "tf"

    labels {
      app  = "tf"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "tf"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "tf"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "yuriy6735/flask"
          name  = "master"

          port {
            container_port = 80
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
          }}
        }
      }
    }
  }
}



