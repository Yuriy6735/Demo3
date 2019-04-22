# Configure the GCP Provider
provider "google" {
  credentials = "${file("./creds/first-project-7961f812579a.json")}"
  region = "europe-west1"
  project = "project1-232817"
}

resource "google_storage_bucket" "bucket" {
  name = "superpuperdemo3"
  location = "EU"

}

data "archive_file" "function_app" {
  type        = "zip"
  source_dir  = "./app"
  output_path = "app.zip"
}

resource "google_storage_bucket_object" "app" {
  name   = "app.${data.archive_file.function_app.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./app.zip"
}

resource "google_cloudfunctions_function" "get-data" {
  name                  = "get-data"
  description           = "My weather"
  available_memory_mb   = 256
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.app.name}"
  trigger_http          = true
  timeout               = 60
  runtime               = "python37"
  entry_point           = "test_jenkins"
  labels = {
    my-label = "my-label-value"
  }

}


terraform {
  backend "gcs" {
    bucket = "tfdemo3st"
    prefix = "demo"
    credentials = "./creds/first-project-7961f812579a.json"
  }
}