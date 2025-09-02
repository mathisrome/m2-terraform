terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.59.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
  required_version = "1.13.1"
}

provider "scaleway" {
  project_id = "af37e4fc-e172-4e7b-807d-932ea1afe8dd"
  zone       = "fr-par-2"
  region     = "fr-par"
}


provider "helm" {
  kubernetes = {
    host  = null_resource.kubeconfig.triggers.host
    token = null_resource.kubeconfig.triggers.token
    cluster_ca_certificate = base64decode(
      null_resource.kubeconfig.triggers.cluster_ca_certificate
    )
  }
}

provider "kubernetes" {
  host                   = null_resource.kubeconfig.triggers.host
  token                  = null_resource.kubeconfig.triggers.token
  cluster_ca_certificate = base64decode(
    null_resource.kubeconfig.triggers.cluster_ca_certificate
  )
}