terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.33.0"
    }
  }

  backend "gcs" {
    bucket = "harmon-terraform-state"
    prefix = "terraform"
  }
}

provider "google" {
  project = "harmon-sports-platform"
  region  = "us-central1"
  zone    = "us-central1-c"
}
