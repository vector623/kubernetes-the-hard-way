terraform {
  cloud {
    organization = "ptcdevs"
    workspaces {
      name = "k8s-the-hard-way"
    }
  }
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  ## Configuration options
  uri = "qemu:///system"
  #alias = "server2"
  #uri   = "qemu+ssh://root@192.168.100.10/system"
}