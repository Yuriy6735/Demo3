# Configure the GCP Provider
provider "google" {
  credentials = "${file("./creds/first-project-7961f812579a.json")}"
  region = "europe-west1"
  project = "project1-232817"
}

//resource "google_storage_bucket" "bucket" {
//  name = "superdemo3"
//  location = "EU"
//
//}

resource "google_storage_bucket_object" "app" {
  name = "app.zip"
  bucket = "https://console.cloud.google.com/storage/browser/superdemo3"
  source = "./app.zip"

}

resource "google_cloudfunctions_function" "get-data" {
  name                  = "get-data"
  description           = "My weather"
  available_memory_mb   = 256
  source_archive_bucket = "https://console.cloud.google.com/storage/browser/superdemo3"
  source_archive_object = "${google_storage_bucket_object.app.name}"
  trigger_http          = true
  timeout               = 60
  runtime               = "python37"
  entry_point           = "test_jenkins"
  labels = {
    my-label = "my-label-value"
  }

}