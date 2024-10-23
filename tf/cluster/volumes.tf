resource "libvirt_volume" "debian-bookworm-qcow2" {
  name   = "debian-bookworm.qcow2"
  #source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  source = "file:///home/davidg/Downloads/debian-12-generic-amd64.qcow2"
  format = "qcow2"
  pool   = libvirt_pool.default.name
}
