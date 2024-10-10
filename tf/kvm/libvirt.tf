resource "libvirt_pool" "default" {
  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images"
  # make sure ownership is set to libvirt-qemu:kvm
  # permissions issues ref: https://github.com/dmacvicar/terraform-provider-libvirt/issues/658#issuecomment-569695035
}

resource "libvirt_network" "kube_network" {
  name   = "k8snet"
  mode   = "nat"
  domain = "k8s.local"
  addresses = [
    "10.17.3.0/24",
    #"2001:db8:ca2:2::1/64"
  ]
  dns {
    enabled    = true
    local_only = true
  }
  autostart = true
}

resource "libvirt_volume" "debian-bookworm-qcow2" {
  name   = "debian-bookworm.qcow2"
  source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  format = "qcow2"
  pool   = libvirt_pool.default.name # List storage pools using virsh pool-list
}

resource "libvirt_volume" "debian-bookworm-qcow2-server" {
  name             = "debian-bookworm-server.qcow2"
  base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
  base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  pool      = libvirt_pool.default.name
  user_data = data.template_file.user_data.rendered
}

module k8s-server {
  source           = "../instance"
  domain_name      = "debian-bookworm-server"
  base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
  base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
  network_name     = libvirt_network.kube_network.name
  cloud_init_id    = libvirt_cloudinit_disk.commoninit.id
}

module k8s-agent-0 {
  source           = "../instance"
  domain_name      = "debian-bookworm-agent=0"
  base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
  base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
  network_name     = libvirt_network.kube_network.name
  cloud_init_id    = libvirt_cloudinit_disk.commoninit.id
}

module k8s-agent-1 {
  source           = "../instance"
  domain_name      = "debian-bookworm-agent=1"
  base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
  base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
  network_name     = libvirt_network.kube_network.name
  cloud_init_id    = libvirt_cloudinit_disk.commoninit.id
}

output "ips" {
  value = {
    #server = libvirt_domain.k8s-server.network_interface.0.addresses.0
    # agent0 = libvirt_domain.k8s-agent0.network_interface.0.addresses.0
  }
}