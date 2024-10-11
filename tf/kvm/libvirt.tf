resource "libvirt_pool" "default" {
  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images"
  # make sure ownership is set to libvirt-qemu:kvm
  # permissions issues ref: https://github.com/dmacvicar/terraform-provider-libvirt/issues/658#issuecomment-569695035
}

locals {
  k8s-nodes = {
    server = {
      name     = "k8s-server"
      hostname = "server"
      fqdn     = "server.kubernetes.local"
      ip       = "10.17.3.10"
    }
    node0 = {
      name     = "k8s-node-0"
      hostname = "node-0"
      fqdn     = "node-0.kubernetes.local"
      ip       = "10.17.3.20"
      subnet   = "10.200.0.0/24"
    }
    node1 = {
      name     = "k8s-node-1"
      hostname = "node-1"
      fqdn     = "node-1.kubernetes.local"
      ip       = "10.17.3.21"
      subnet   = "10.200.1.0/24"
    }
  }
}

module k8s-nodes {
  for_each = local.k8s-nodes
  source           = "../instance"
  domain_name      = each.value.name
  hostname         = each.value.hostname
  ip-address       = each.value.ip
  base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
  base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
  network_name     = libvirt_network.kube_network.name
  cloud_init_id    = libvirt_cloudinit_disk.commoninit.id

}

# module "k8s-server" {
#   source           = "../instance"
#   domain_name      = local.hosts.server.name
#   hostname         = local.hosts.server.hostname
#   base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
#   base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
#   network_name     = libvirt_network.kube_network.name
#   cloud_init_id    = libvirt_cloudinit_disk.commoninit.id
#   ip-address       = local.hosts.server.ip
# }
#
# module "k8s-agent0" {
#   source           = "../instance"
#   domain_name      = local.hosts.agent0.name
#   hostname         = local.hosts.agent0.hostname
#   base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
#   base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
#   network_name     = libvirt_network.kube_network.name
#   cloud_init_id    = libvirt_cloudinit_disk.commoninit.id
#   ip-address       = local.hosts.agent0.ip
# }
#
# module "k8s-agent1" {
#   source           = "../instance"
#   domain_name      = local.hosts.agent1.name
#   hostname         = local.hosts.agent1.hostname
#   base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
#   base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
#   network_name     = libvirt_network.kube_network.name
#   cloud_init_id    = libvirt_cloudinit_disk.commoninit.id
#   ip-address       = local.hosts.agent1.ip
# }
