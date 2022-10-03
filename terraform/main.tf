locals {
  services = [
    "storage-api.googleapis.com",
    "container.googleapis.com",
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudscheduler.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "bigquery.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "container.googleapis.com"
  ]
}

resource "google_project_service" "services" {
  for_each                   = toset(local.services)
  service                    = each.key
  disable_dependent_services = true
}

resource "google_project_iam_binding" "data_platform_owner" {
  project = "harmon-sports-platform"
  role    = "roles/owner"

  members = [
    "user:jakekirsch11@gmail.com", "serviceAccount:922320915402@cloudbuild.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "data_platform_viewer" {
  project = "harmon-sports-platform"
  role    = "roles/viewer"

  members = [
  ]
}

resource "google_storage_bucket" "data_platform_data" {
  name          = "harmon-sports-platform-data"
  location      = "us-central1"
  force_destroy = true
}

resource "google_artifact_registry_repository" "repositories" {
  location      = "us-central1"
  repository_id = "docker-repository"
  format        = "DOCKER"
  depends_on = [
    google_project_service.services["artifactregistry.googleapis.com"]
  ]
}

resource "google_cloud_run_service" "run_service" {
  name = "harmon-sports-platform-app"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/harmon-sports-platform/docker-repository/app:prod"
      }
      timeout_seconds = 3000
    }
  }

  # Waits for the Cloud Run API to be enabled
  depends_on = [google_project_service.services["run.googleapis.com"]]
}


data "google_compute_default_service_account" "default" {
  depends_on = [
    google_project_service.services["compute.googleapis.com"]
  ]
}

# resource "google_cloud_scheduler_job" "jobs" {
#   project = google_project.kirsch_data_platform.project_id
#   name             = "get_opendoor"
#   description      = "get_opendoor"
#   schedule         = "0 7 * * *"
#   time_zone        = "America/Mexico_City"

#   retry_config {
#     retry_count = 1
#   }

#   http_target {
#     http_method = "POST"
#     uri         = "https://get-opendoor-gwmmhrzkra-uc.a.run.app"
#     body        = base64encode("{}")
#     oidc_token {
#       service_account_email = data.google_compute_default_service_account.default.email
#     }
#   }
#   depends_on = [google_project_iam_binding.kirsch_data_platform, google_project_service.services, google_project_service.iam-service]
# }