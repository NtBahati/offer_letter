# Terraform Settings Block
terraform {
  required_version = ">= 1.11.3"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.42.0"
    }
  }
  backend "gcs" {
    bucket = "a1bahati"
    prefix = "prod/gke-cluster-private"    
  }
}

# Terraform Provider Block
provider "google" {
  project = var.gcp_project
  region = var.gcp_region1
}