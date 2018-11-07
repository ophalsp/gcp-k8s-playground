variable "credentials" {}

variable "project" {}

variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "additional_zones" {
  type = "list"

  default = [
    "europe-west1-c",
    "europe-west1-d",
  ]
}

variable "prefix" {
  default = "play"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "master_cidr_block" {
  description = "The CIDR from which to allocate master IPs"
  type        = "string"
  default     = "192.168.10.0/28"
}

variable "primary_ip_range" {
  default = "10.3.0.0/20"
}

variable "secondary_ip_range" {
  default = "10.5.0.0/20"
}

variable "bastion_machine_type" {
  description = "The instance size to use for your bastion instance."
  type        = "string"
  default     = "f1-micro"
}

variable "bastion_hostname" {
  type    = "string"
  default = "play-gke-bastion"
}

variable "bastion_tags" {
  description = "A list of tags applied to your bastion instance."
  type        = "list"
  default     = ["play-gke-bastion"]
}
