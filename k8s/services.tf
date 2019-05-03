###################
### K8S Service ###
###################
resource "kubernetes_service" "mongo-master" {
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
    selector {
      app  = "mongo"
      role = "master"
      tier = "backend"
    }

    type = "ClusterIP"

    port {
      port        = 27017
      target_port = 27017
    }
  }
}


resource "kubernetes_service" "redis-master" {
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
    selector {
      app  = "redis"
      role = "master"
      tier = "backend"
    }

    type = "ClusterIP"

    port {
      port        = 6379
      target_port = 6379
    }
  }
}



resource "kubernetes_service" "jupyter-balancer" {
  metadata {
    name = "jupyter-balancer"

    labels {
      app  = "jupyter-notebook"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    selector {
      app  = "jupyter-notebook"
      role = "master"
      tier = "backend"
    }

    type = "ClusterIP"

    port {
      port        = 80
      target_port = 8888
    }
  }
}

resource "kubernetes_service" "telebot" {
  metadata {
    name = "telebot"

    labels {
      app  = "telebot"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    selector {
      app  = "telebot"
      role = "master"
      tier = "backend"
    }
    port {
      port        = 80
    }

  }
}

resource "kubernetes_service" "tf" {
  metadata {
    name = "tf"

    labels {
      app  = "tf"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    selector {
      app  = "tf"
      role = "master"
      tier = "backend"
    }

    type = "ClusterIP"

    port {
      port        = 80
      target_port = 80
    }

  }
}



