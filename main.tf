provider "google-beta" {
  project     = var.provider_project
  region      = var.provider_region
  access_token = var.access_token
}

provider "google" {
  project     = var.provider_project
  region      = var.provider_region
  access_token = var.access_token
}

resource "google_dataplex_lake" "basic_lake" { 
  name     = "wf-us-prod-dpx-fghi-app01" 
  location = "us-west1" 
  project  = var.provider_project 
  labels   = var.labels
} 

resource "google_dataplex_zone" "basic_zone" {
  name           = "wf-us-prod-dpz-fghi-app01" 
  location       = "us-west1" 
  lake           = google_dataplex_lake.basic_lake.name 
  type           = "RAW" 
  discovery_spec { enabled = false } 
  resource_spec  { location_type = "MULTI_REGION" } 
  project        = var.provider_project  
  labels         = var.labels
} 

resource "google_dataplex_asset" "primary" {
  name           = "wf-us-prod-dpa-fghi-app01" 
  location       = "us-west1" 
  lake           = google_dataplex_lake.basic_lake.name 
  dataplex_zone  = google_dataplex_zone.basic_zone.name 
  discovery_spec { enabled = false } 
  resource_spec  { 
                    name = "projects/modular-scout-345114/buckets/my-bucket-df" 
                    type = "STORAGE_BUCKET"
                 } 
  project        = var.provider_project
  labels         = var.labels
  depends_on     = [ google_storage_bucket.basic_bucket ] 
}

resource "google_storage_bucket" "basic_bucket" {
  name          = "wf-us-prod-gcs-fghi-app01"
  location      = "us-west1"
  uniform_bucket_level_access = true
  lifecycle {
    ignore_changes = [
      labels
    ]
  }

  project = var.provider_project
}
