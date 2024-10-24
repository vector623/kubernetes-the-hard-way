resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo $HOME"
  }
}

output homedir {
  value = null_resource.example
}

# resource "libvirt_pool" "default" {
#   name = "k8s-pool"
#   type = "dir"
#
#   target {
#     path = "/home/davidg/k8s-pool"
#   }
#   # make sure ownership is set to libvirt-qemu:kvm
#   # permissions issues ref: https://github.com/dmacvicar/terraform-provider-libvirt/issues/658#issuecomment-569695035
# }

locals {
  k8s-nodes = {
    server = {
      name     = "k8s-server"
      hostname = "server"
      fqdn     = "server.kubernetes.local"
      ip       = "10.17.3.10"
      subnet   = ""
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

module "k8s-nodes" {
  for_each         = local.k8s-nodes
  source           = "../instance"
  domain_name      = each.value.name
  hostname         = each.value.hostname
  fqdn             = each.value.fqdn
  ip-address       = each.value.ip
  base_volume_id   = libvirt_volume.debian-bookworm-qcow2.id
  base_volume_pool = libvirt_volume.debian-bookworm-qcow2.pool
  network_name     = libvirt_network.kube_network.name
}
