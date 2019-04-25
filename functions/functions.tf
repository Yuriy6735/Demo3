# Configure the GCP Provider
provider "google" {
  region      = "${var.region}"
  project     = "${var.project}"
}

resource "google_storage_bucket" "bucket" {
  name = "${var.bucket}"
  location = "EU"
}

data "archive_file" "app" {
  type        = "zip"
  source_dir  = "./functions/app/app"
  output_path = "./functions/app/app.zip"
}

resource "google_storage_bucket_object" "app" {
  name   = "app.${data.archive_file.app.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/app/app.zip"
}

data "archive_file" "save-to-db" {
  type        = "zip"
  source_dir  = "./functions/save-to-db/save-to-db"
  output_path = "./functions/save-to-db/save-to-db.zip"
}

resource "google_storage_bucket_object" "save-to-db" {
  name   = "save-to-db.${data.archive_file.save-to-db.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/save-to-db/save-to-db.zip"
}

data "archive_file" "current-temp" {
  type        = "zip"
  source_dir  = "./functions/current-temp/current-temp"
  output_path = "./functions/current-temp/current-temp.zip"
}

resource "google_storage_bucket_object" "current-temp" {
  name   = "current-temp.${data.archive_file.current-temp.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/current-temp/current-temp.zip"
}

data "archive_file" "zamb" {
  type        = "zip"
  source_dir  = "./functions/zamb/zamb"
  output_path = "./functions/zamb/zamb.zip"
}

resource "google_storage_bucket_object" "zamb" {
  name   = "zamb.${data.archive_file.zamb.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/zamb/zamb.zip"
}

data "archive_file" "to-zamb" {
  type        = "zip"
  source_dir  = "./functions/to-zamb/to-zamb"
  output_path = "./functions/to-zamb/to-zamb.zip"
}

resource "google_storage_bucket_object" "to-zamb" {
  name   = "to-zamb.${data.archive_file.to-zamb.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/to-zamb/to-zamb.zip"
}

data "archive_file" "get-from-db" {
  type        = "zip"
  source_dir  = "./functions/get-from-db/get-from-db"
  output_path = "./functions/get-from-db/get-from-db.zip"
}

resource "google_storage_bucket_object" "get-from-db" {
  name   = "get-from-db.${data.archive_file.get-from-db.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/get-from-db/get-from-db.zip"
}

data "archive_file" "api-to-tf" {
  type        = "zip"
  source_dir  = "./functions/api-to-tf/api-to-tf"
  output_path = "./functions/api-to-tf/api-to-tf.zip"
}

resource "google_storage_bucket_object" "api-to-tf" {
  name   = "api-to-tf.${data.archive_file.api-to-tf.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/api-to-tf/api-to-tf.zip"
}

data "archive_file" "get-predictions" {
  type        = "zip"
  source_dir  = "./functions/get-predictions/get-predictions"
  output_path = "./functions/get-predictions/get-predictions.zip"
}

resource "google_storage_bucket_object" "get-predictions" {
  name   = "get-predictions.${data.archive_file.get-predictions.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/get-predictions/get-predictions.zip"
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
  entry_point           = "get_data_from_api"
  labels = {
    my-label = "my-label-value"
  }
  environment_variables = {
    API = "${var.API}"
    project = "${var.project}"
  }

}

resource "google_pubsub_topic" "topic1" {
  name = "topic1"
}

resource "google_pubsub_topic" "topic2" {
  name = "topic2"
}

resource "google_pubsub_topic" "topic3" {
  name = "topic3"
}

resource "google_cloudfunctions_function" "save-to-db" {
  name                  = "save-to-db"
  description           = "My weather"
  available_memory_mb   = 256
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.save-to-db.name}"
  timeout               = 60
  runtime               = "python37"
  entry_point           = "message_from_topic1"
  event_trigger {
    event_type          = "google.pubsub.topic.publish"
    resource            = "${google_pubsub_topic.topic1.name}"
    failure_policy {
      retry = true
    }
  }
    environment_variables = {
    user_name = "${var.MONGODB_USERNAME}"
    user_pass = "${var.MONGODB_PASSWORD}"
    ip = "${var.service}"
  }

}

resource "google_cloudfunctions_function" "current-temp" {
  name                  = "current-temp"
  description           = "My weather"
  available_memory_mb   = 256
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.current-temp.name}"
  timeout               = 60
  runtime               = "python37"
  entry_point           = "message_from_topic3"
  event_trigger {
    event_type          = "google.pubsub.topic.publish"
    resource            = "${google_pubsub_topic.topic3.name}"
    failure_policy {
      retry = true
    }
  }
    environment_variables = {
    project = "${var.project}"
    ip_redis = "${var.ip_redis}"
  }

}

resource "google_cloudfunctions_function" "zamb" {
  name                  = "zamb"
  description           = "My weather"
  available_memory_mb   = 256
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.zamb.name}"
  trigger_http          = true
  timeout               = 60
  runtime               = "python37"
  entry_point           = "zamb"


    environment_variables = {
    user_name = "${var.MONGODB_USERNAME}"
    user_pass = "${var.MONGODB_PASSWORD}"
    ip = "${var.service}"
    ip_redis = "${var.ip_redis}"
  }

}

resource "google_cloudfunctions_function" "to-zamb" {
  name                  = "to-zamb"
  description           = "My weather"
  available_memory_mb   = 256
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.to-zamb.name}"
  timeout               = 60
  runtime               = "python37"
  entry_point           = "message_from_topic2"

  event_trigger {
    event_type          = "google.pubsub.topic.publish"
    resource            = "${google_pubsub_topic.topic2.name}"
    failure_policy {
      retry = true
    }
  }
    environment_variables = {
    project = "${var.project}"
    link_zamb = "${google_cloudfunctions_function.zamb.https_trigger_url}"
  }

}


resource "google_cloud_scheduler_job" "api-job" {
  name     = "api-job"
  description = "test http job"
  schedule = "*/15 * * * *"
  time_zone = "Europe/Brussels"

  http_target {
    http_method = "POST"
    uri = "${google_cloudfunctions_function.get-data.https_trigger_url}"
  }
}


resource "google_cloudfunctions_function" "get-from-db" {
  name = "get-from-db"
  description = "Fetching from MongoDB"
  available_memory_mb = 128
  trigger_http = true
  timeout = 60
  entry_point = "get_from_db"
  runtime = "python37"
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.get-from-db.name}"
  environment_variables = {
    user_name = "${var.MONGODB_USERNAME}"
    user_pass = "${var.MONGODB_PASSWORD}"
    ip = "${var.service}"
  }
}

resource "google_cloudfunctions_function" "api-to-tf" {
  name = "api-to-tf"
  description = "api_to_TF"
  available_memory_mb = 128
  trigger_http = true
  timeout = 60
  entry_point = "data_to_predict"
  runtime = "python37"
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.api-to-tf.name}"

}


resource "google_cloudfunctions_function" "get-predictions" {
  name = "get-predictions"
  description = "Fetching from MongoDB"
  available_memory_mb = 128
  trigger_http = true
  timeout = 60
  entry_point = "get_predictions"
  runtime = "python37"
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.get-predictions.name}"
  environment_variables = {

    ip_tf = "${var.ip_tf1}"
    link_api_to_tf = "${google_cloudfunctions_function.api-to-tf.https_trigger_url}"
  }
}

