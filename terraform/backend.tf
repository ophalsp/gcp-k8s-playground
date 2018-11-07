terraform {
  backend "gcs" {
    bucket = "gcp-k8s-playground-terraform"
    prefix = "terraform.tfstate"
  }
}
