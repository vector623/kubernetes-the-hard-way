resource "libvirt_pool" "default" {
  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images"
  # make sure ownership is set to libvirt-qemu:kvm
  # permissions issues ref: https://github.com/dmacvicar/terraform-provider-libvirt/issues/658#issuecomment-569695035
}

resource "libvirt_volume" "debian-bookworm-qcow2" {
  name   = "debian-bookworm.qcow2"
  source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2"
  format = "qcow2"
  pool   = libvirt_pool.default.name # List storage pools using virsh pool-list
}
#
resource "libvirt_volume" "debian-bookworm-qcow2-server" {
  name   = "debian-bookworm-server.qcow2"
  base_volume_id = libvirt_volume.debian-bookworm-qcow2.id
  base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
}

resource "libvirt_volume" "debian-bookworm-qcow2-agent0" {
  name   = "debian-bookworm-agent0.qcow2"
  base_volume_id = libvirt_volume.debian-bookworm-qcow2.id
  base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
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

# resource "libvirt_domain" "k8s-server" {
#   name   = "k8s-server"
#   memory = "2048"
#   vcpu   = 2
#   network_interface {
#     network_name = libvirt_network.kube_network.name # List networks with virsh net-list
#   }
#   disk {
#     volume_id = libvirt_volume.debian-bookworm-qcow2.id
#   }
#   console {
#     type        = "pty"
#     target_type = "serial"
#     target_port = "0"
#   }
#   graphics {
#     type        = "spice"
#     listen_type = "address"
#     autoport    = true
#   }
# }
#
# resource "libvirt_domain" "k8s-agent0" {
#   name   = "k8s-agent0"
#   memory = "2048"
#   vcpu   = 2
#   network_interface {
#     network_name = libvirt_network.kube_network.name # List networks with virsh net-list
#   }
#   disk {
#     volume_id = libvirt_volume.debian-bookworm-qcow2-agent.id
#   }
#   console {
#     type        = "pty"
#     target_type = "serial"
#     target_port = "0"
#   }
#   graphics {
#     type        = "spice"
#     listen_type = "address"
#     autoport    = true
#   }
# }

# output "ips" {
#   value = {
#     server = libvirt_domain.k8s-server.network_interface.0.addresses.0
#     agent0 = libvirt_domain.k8s-agent0.network_interface.0.addresses.0
#   }
# }