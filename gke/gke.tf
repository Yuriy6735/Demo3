#############################
### Google Cloud Platform ###
#############################
provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
//  credentials = "${file("/home/zambezi/devops/gityura/Demo2/key.json")}"
}
/*
resource "google_compute_address" "default" {
  name         = "default"
  address_type = "EXTERNAL"
  address      = "${var.address}"
  region       = "${var.region}"
}
output "ipaddress" {
  value     = "${google_compute_address.default.address}"
  sensitive = true
}*/