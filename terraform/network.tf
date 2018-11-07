resource "google_compute_network" "default-network" {
  name                    = "${var.prefix}-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default-subnetwork" {
  name                     = "${var.prefix}-subnetwork"
  ip_cidr_range            = "${var.primary_ip_range}"
  region                   = "${var.region}"
  network                  = "${google_compute_network.default-network.self_link}"
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "default-secondary-ip-range"
    ip_cidr_range = "${var.secondary_ip_range}"
  }
}

resource "google_compute_firewall" "bastion-ssh" {
  name          = "bastion-ssh"
  network       = "${google_compute_network.default-network.self_link}"
  direction     = "INGRESS"
  project       = "${var.project}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = "${var.bastion_tags}"
}

# module "gce-lb-http" {
#   source = "GoogleCloudPlatform/lb-http/google"
#   name   = "${var.prefix}-lb-http"
#
#   target_tags = [
#     "${module.mig-b.target_tags}",
#     "${module.mig-c.target_tags}",
#     "${module.mig-d.target_tags}",
#   ]
#
#   firewall_networks = ["${google_compute_network.default-network.name}"]
#
#   backends = {
#     "0" = [
#       {
#         group = "${module.mig-b.instance_group}"
#       },
#       {
#         group = "${module.mig-c.instance_group}"
#       },
#       {
#         group = "${module.mig-d.instance_group}"
#       },
#     ]
#   }
#
#   backend_params = [
#     // health check path, port name, port number, timeout seconds.
#     "/,http,80,10",
#   ]
# }
#
# output "load-balancer-ip" {
#   value = "${module.gce-lb-http.external_ip}"
# }

