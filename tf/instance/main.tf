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
variable cloud_init_id {}

resource "libvirt_volume" "base-volume" {
  name             = "${var.domain_name}.qcow2"
  base_volume_id   = var.base_volume_id
  base_volume_pool = var.base_volume_pool
}

resource "libvirt_domain" "domain" {
  name   = var.domain_name
  memory = "2048"
  vcpu   = 2
  network_interface {
    network_name = var.network_name
  }
  disk {
    volume_id = libvirt_volume.base-volume.id
  }
  cloudinit = var.cloud_init_id
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

output "ip-address" {
  value = libvirt_domain.domain.network_interface
}
