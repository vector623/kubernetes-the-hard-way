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
    hosts {
      hostname = local.hosts.server.hostname
      ip       = local.hosts.server.ip
    }
    hosts {
      hostname = local.hosts.agent0.hostname
      ip       = local.hosts.agent0.ip
    }
    hosts {
      hostname = local.hosts.agent1.hostname
      ip       = local.hosts.agent1.ip
    }
  }
  autostart = true
}

locals {
  machine-database = <<-EOT
    ${local.hosts.server.ip} ${local.hosts.server.fqdn} ${local.hosts.server.hostname}
    ${local.hosts.agent0.ip} ${local.hosts.agent0.fqdn} ${local.hosts.agent0.hostname} 10.200.0.0/24
    ${local.hosts.agent1.ip} ${local.hosts.agent1.fqdn} ${local.hosts.agent1.hostname} 10.200.1.0/24
  EOT
}

resource local_file machines-txt {
  filename = "../../machines.txt"
  content = local.machine-database
}
