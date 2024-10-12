resource "libvirt_volume" "debian-bookworm-qcow2" {
  name   = "debian-bookworm.qcow2"
  source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  format = "qcow2"
  pool   = libvirt_pool.default.name
}

resource "libvirt_volume" "debian-bookworm-qcow2-server" {
  name             = "debian-bookworm-server.qcow2"
  base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
  base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
}

