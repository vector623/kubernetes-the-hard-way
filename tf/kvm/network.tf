resource "libvirt_network" "kube_network" {
  name   = "k8snet"
  mode   = "nat"
  domain = "kubernetes.local"
  addresses = [
    "10.17.3.0/24",
    #"2001:db8:ca2:2::1/64"
  ]
  dns {
    enabled    = true
    local_only = true
    dynamic "hosts" {
      for_each = local.k8s-nodes

      content {
        hostname = hosts.value.hostname
        ip       = hosts.value.ip
      }
    }
  }
  autostart = true
}

locals {
  machine-database = join("\n", [for k, v in local.k8s-nodes : "${v.ip} ${v.fqdn} ${v.hostname} ${v.subnet}"])
  hosts = join("\n", [for k, v in local.k8s-nodes : "${v.ip} ${v.fqdn} ${v.hostname}"])
}

resource "local_file" "machines-txt" {
  filename = "../../machines.txt"
  content  = local.machine-database
}

resource "local_file" "hosts" {
  filename = "../../hosts"
  content  = local.hosts
}
