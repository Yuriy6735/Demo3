resource "kubernetes_namespace" "mongo_space" {
  metadata {
    name = "mspace"
  }
}

resource "kubernetes_namespace" "redis_space" {
  metadata {
    name = "rspace"
  }
}

//resource "kubernetes_namespace" "traefik" {
//  metadata {
//    name = "traefik"
//  }
//}