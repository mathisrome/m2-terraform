terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.57.0"
    }
  }
}

provider "scaleway" {
  project_id = "af37e4fc-e172-4e7b-807d-932ea1afe8dd"
  zone       = "fr-par-2"
  region     = "fr-par"
}