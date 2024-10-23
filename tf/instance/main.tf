terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

variable base_volume_id {}
variable base_volume_pool {}
variable domain_name {}
variable network_name {}
variable ip-address {}
variable "hostname" {}
variable "fqdn" {}

resource "libvirt_volume" "main" {
  name             = "${var.domain_name}.qcow2"
  base_volume_id   = var.base_volume_id
  base_volume_pool = var.base_volume_pool
  size             = 32212254720
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = var.hostname
    fqdn     = var.fqdn
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "${var.domain_name}.iso"
  pool      = var.base_volume_pool
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_domain" "main" {
  name   = var.domain_name
  memory = "2048"
  vcpu   = 1
  network_interface {
    network_name   = var.network_name
    hostname       = var.hostname
    wait_for_lease = true

    addresses = [
      var.ip-address
    ]
  }
  disk {
    volume_id = libvirt_volume.main.id
  }
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "debug" {
  value = {
    ip-address = libvirt_domain.main.network_interface.0.addresses.0
    disk-size  = libvirt_volume.main.size
  }
}

