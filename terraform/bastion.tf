data "template_file" "bastion-startup-script" {
  template = <<EOF
sudo apt-get update -y
sudo apt-get install -y kubectl
sudo apt-get install -y git
echo "gcloud container clusters get-credentials $${cluster_name} --zone $${cluster_zone} --project $${project}" >> /etc/profile
EOF

  vars {
    cluster_name = "${var.prefix}-gke-cluster"
    cluster_zone = "${var.zone}"
    project      = "${var.project}"
  }
}

resource "google_compute_instance" "default-bastion" {
  name                      = "${var.bastion_hostname}"
  machine_type              = "${var.bastion_machine_type}"
  zone                      = "${var.zone}"
  project                   = "${var.project}"
  tags                      = "${var.bastion_tags}"
  allow_stopping_for_update = true

  // Specify the Operating System Family and version.
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Define a network interface in the correct subnet.
  network_interface {
    subnetwork = "${google_compute_subnetwork.default-subnetwork.self_link}"

    // Add an ephemeral external IP.
    access_config {
      // Implicit ephemeral IP
    }
  }

  // Ensure that when the bastion host is booted, it will have kubectl.
  # metadata_startup_script = "sudo apt-get install -y kubectl"
  metadata_startup_script = "${data.template_file.bastion-startup-script.rendered}"

  // Necessary scopes for administering kubernetes.
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }
}
