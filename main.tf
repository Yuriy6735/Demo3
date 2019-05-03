#################
### Variables ###
#################
variable "username" {
  default = "admin"
}

terraform {
  backend "gcs" {
    bucket = "tfd3state"
    prefix = "demo"
   // credentials = "./creds/d3tf-238518-b1dc0018dc93.json"
  }
}

variable "password" {}

variable "MONGODB_DATABASE" {
  default = "mysinoptik"
}

variable "MONGODB_USERNAME" {
  default = "main_admin"
}

variable "MONGODB_PASSWORD" {}
variable "MONGODB_ROOT_PASSWORD" {}

variable "project" {}

variable "region" {
  default = "europe-west1"

}
variable "api_telegram" {}

variable "bucket" {
  description = "my bucket"
//  export TF_VAR_bucket=api_app
}

variable "API" {
  description = "API Key"
//  export TF_VAR_API=....
}

//variable "ip_tf" {
//  description = "ip_tf"
////  export TF_VAR_API=....
//}


###############
### Modules ###
###############
module "gke" {
  source   = "./gke"
  project  = "${var.project}"
  region   = "${var.region}"
  username = "${var.username}"
  password = "${var.password}"
}

module "k8s" {
  source                 = "./k8s"
  host                   = "${module.gke.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  MONGODB_DATABASE       = "${var.MONGODB_DATABASE}"
  MONGODB_USERNAME       = "${var.MONGODB_USERNAME}"
  MONGODB_PASSWORD       = "${var.MONGODB_PASSWORD}"
  MONGODB_ROOT_PASSWORD  = "${var.MONGODB_ROOT_PASSWORD}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  api_telegram = "${var.api_telegram}"

//  ip_redis = "${module.k8s.ip_redis}"
//  ip_tf1 = "${module.k8s.ip_tf1}"
}

module "traefik" {
  source = "./k8s/traefik"
  host                   = "${module.gke.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  lb_ext_ip              = "${module.gke.external_ip}"
}


module "functions" {
  project  = "${var.project}"
  source = "./functions"
  region = "${var.region}"
  bucket = "${var.bucket}"
  API = "${var.API}"
  service = "${module.gke.external_ip}"
  ip_redis = "${module.gke.external_ip}"
  ip_tf1 = "${module.gke.external_ip}"
  MONGODB_PASSWORD = "${var.MONGODB_PASSWORD}"
  MONGODB_ROOT_PASSWORD = "${var.MONGODB_ROOT_PASSWORD}"
}
