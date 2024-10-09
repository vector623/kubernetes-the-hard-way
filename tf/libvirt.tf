resource "libvirt_pool" "default" {
  name = "default"
  type = "dir"
  path = "~/kvm-storage"
  # this fixes permissions issues
  # https://github.com/dmacvicar/terraform-provider-libvirt/issues/658#issuecomment-569695035
}

resource "libvirt_volume" "debian-bookworm-qcow2" {
  name   = "debian-bookworm.qcow2"
  pool   = "default" # List storage pools using virsh pool-list
  source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2"
  format = "qcow2"
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

resource "libvirt_domain" "debian12" {
  name   = "debian"
  memory = "2048"
  vcpu   = 2

  network_interface {
    network_name = libvirt_network.kube_network.name # List networks with virsh net-list
  }

  disk {
    volume_id = libvirt_volume.debian-bookworm-qcow2.id
  }

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

output "ip" {
  value = libvirt_domain.debian12.network_interface.0.addresses.0
}