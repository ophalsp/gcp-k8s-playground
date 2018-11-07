# module "mig-b" {
#   source            = "GoogleCloudPlatform/managed-instance-group/google"
#   version           = "1.1.14"
#   zone              = "${var.zone}"
#   region            = "${var.region}"
#   name              = "default-network-mig-b"
#   size              = "1"
#   target_tags       = ["default-network-mig-b"]
#   service_port      = 80
#   service_port_name = "http"
#
#   # startup_script    = "${data.template_file.group-startup-script.rendered}"
#   network    = "${google_compute_network.default-network.name}"
#   subnetwork = "${google_compute_subnetwork.default-subnetwork.name}"
# }
#
# module "mig-c" {
#   source            = "GoogleCloudPlatform/managed-instance-group/google"
#   version           = "1.1.14"
#   zone              = "${var.additional_zones[0]}"
#   region            = "${var.region}"
#   name              = "default-network-mig-c"
#   size              = "1"
#   target_tags       = ["default-network-mig-c"]
#   service_port      = 80
#   service_port_name = "http"
#
#   # startup_script    = "${data.template_file.group-startup-script.rendered}"
#   network    = "${google_compute_network.default-network.name}"
#   subnetwork = "${google_compute_subnetwork.default-subnetwork.name}"
# }
#
# module "mig-d" {
#   source            = "GoogleCloudPlatform/managed-instance-group/google"
#   version           = "1.1.14"
#   zone              = "${var.additional_zones[1]}"
#   region            = "${var.region}"
#   name              = "default-network-mig-d"
#   size              = "1"
#   target_tags       = ["default-network-mig-d"]
#   service_port      = 80
#   service_port_name = "http"
#
#   # startup_script    = "${data.template_file.group-startup-script.rendered}"
#   network    = "${google_compute_network.default-network.name}"
#   subnetwork = "${google_compute_subnetwork.default-subnetwork.name}"
# }

