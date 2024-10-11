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

