data "google_container_engine_versions" "zonal-gke-node-versions" {
  project = "${var.project}"
  zone    = "${var.zone}"
}

resource "google_service_account" "gsa-gke-cluster" {
  account_id   = "${var.prefix}-gke-cluster"
  display_name = "GKE Service Account"
}

# TODO what are these for?
# resource "google_project_iam_member" "member-1" {
#   role   = "roles/logging.logWriter"
#   member = "serviceAccount:${google_service_account.gsa-gke-cluster.email}"
# }
#
# # TODO what are these for?
# resource "google_project_iam_member" "member-2" {
#   role   = "roles/monitoring.metricWriter"
#   member = "serviceAccount:${google_service_account.gsa-gke-cluster.email}"
# }
#
# # TODO what are these for?
# resource "google_project_iam_member" "member-3" {
#   role   = "roles/monitoring.viewer"
#   member = "serviceAccount:${google_service_account.gsa-gke-cluster.email}"
# }
#
# # TODO what are these for?
# resource "google_project_iam_member" "member-4" {
#   role   = "roles/storage.objectViewer"
#   member = "serviceAccount:${google_service_account.gsa-gke-cluster.email}"
# }

resource "google_container_node_pool" "gke-cluster-app-np" {
  name    = "${var.prefix}-gke-cluster-app-np"
  zone    = "${var.zone}"
  cluster = "${google_container_cluster.gke-cluster.name}"

  initial_node_count = 1

  node_config {
    service_account = "${google_service_account.gsa-gke-cluster.email}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      prefix = "${var.prefix}"
    }

    tags = ["${var.prefix}-gke"]

    machine_type = "${var.machine_type}"
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

resource "google_container_cluster" "gke-cluster" {
  provider         = "google-beta"
  name             = "${var.prefix}-gke-cluster"
  zone             = "${var.zone}"
  additional_zones = "${var.additional_zones}"

  network    = "${google_compute_network.default-network.self_link}"
  subnetwork = "${google_compute_subnetwork.default-subnetwork.self_link}"

  min_master_version = "${data.google_container_engine_versions.zonal-gke-node-versions.latest_master_version}"

  lifecycle {
    ignore_changes = [
      "node_pool",
      "ip_allocation_policy",
      "network",
      "subnetwork",
    ]
  }

  node_pool {
    name = "default-pool"
  }

  remove_default_node_pool = true

  addons_config {
    http_load_balancing {
      disabled = true
    }

    kubernetes_dashboard {
      disabled = true
    }

    network_policy_config {
      disabled = false
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO" // CALICO is currently the only supported provider
  }

  # private_cluster_config {
  #   enable_private_endpoint = true
  #   enable_private_nodes    = true
  #   master_ipv4_cidr_block  = "${var.master_cidr_block}"
  # }

  private_cluster        = true
  master_ipv4_cidr_block = "${var.master_cidr_block}"
  ip_allocation_policy {
    cluster_secondary_range_name = "default-secondary-ip-range"
  }
  master_authorized_networks_config {
    cidr_blocks = {
      display_name = "bastion"
      cidr_block   = "${google_compute_instance.default-bastion.network_interface.0.access_config.0.assigned_nat_ip}/32"
    }
  }
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
# output "client_certificate" {
#   value = "${google_container_cluster.gke-cluster.master_auth.0.client_certificate}"
# }
#
# output "client_key" {
#   value = "${google_container_cluster.gke-cluster.master_auth.0.client_key}"
# }
#
# output "cluster_ca_certificate" {
#   value = "${google_container_cluster.gke-cluster.master_auth.0.cluster_ca_certificate}"
# }

