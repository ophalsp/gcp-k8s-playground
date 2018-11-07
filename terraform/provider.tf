provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "~> 1.19"
}

provider "google-beta" {
  credentials = "${file("credentials.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "~> 1.19"
}
