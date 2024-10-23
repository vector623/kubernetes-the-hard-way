# Kubernetes The Hard Way

This tutorial walks you through setting up Kubernetes the hard way. This guide is not for someone looking for a fully automated tool to bring up a Kubernetes cluster. Kubernetes The Hard Way is optimized for learning, which means taking the long route to ensure you understand each task required to bootstrap a Kubernetes cluster.

> The results of this tutorial should not be viewed as production ready, and may receive limited support from the community, but don't let that stop you from learning!

## Copyright

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

## Target Audience

The target audience for this tutorial is someone who wants to understand the fundamentals of Kubernetes and how the core components fit together.

## Cluster Details

Kubernetes The Hard Way guides you through bootstrapping a basic Kubernetes cluster with all control plane components running on a single node, and two worker nodes, which is enough to learn the core concepts.

Component versions:

* [kubernetes](https://github.com/kubernetes/kubernetes) v1.28.x
* [containerd](https://github.com/containerd/containerd) v1.7.x
* [cni](https://github.com/containernetworking/cni) v1.3.x
* [etcd](https://github.com/etcd-io/etcd) v3.4.x

## Labs

This tutorial requires four (4) ARM64 based virtual or physical machines connected to the same network. While ARM64 based machines are used for the tutorial, the lessons learned can be applied to other platforms.

* [Prerequisites](docs/01-prerequisites.md)
* [Setting up the Jumpbox](docs/02-jumpbox.md)
* [Provisioning Compute Resources](docs/03-compute-resources.md)
* [Provisioning the CA and Generating TLS Certificates](docs/04-certificate-authority.md)
* [Generating Kubernetes Configuration Files for Authentication](docs/05-kubernetes-configuration-files.md)
* [Generating the Data Encryption Config and Key](docs/06-data-encryption-keys.md)
* [Bootstrapping the etcd Cluster](docs/07-bootstrapping-etcd.md)
* [Bootstrapping the Kubernetes Control Plane](docs/08-bootstrapping-kubernetes-controllers.md)
* [Bootstrapping the Kubernetes Worker Nodes](docs/09-bootstrapping-kubernetes-workers.md)
* [Configuring kubectl for Remote Access](docs/10-configuring-kubectl.md)
* [Provisioning Pod Network Routes](docs/11-pod-network-routes.md)
* [Smoke Test](docs/12-smoke-test.md)
* [Cleaning Up](docs/13-cleanup.md)


## Infrastructure

* `ansible/` installs libvirt and configures permissions
* `tf/` provisions kvm VMs to use for k8s

## Permissions problems and fixes

### enable virsh and terraform qemu/kvm access without root

Follow this guide https://computingforgeeks.com/use-virt-manager-as-non-root-user/. This will setup libvirtd with permissions.

Then use socket file connection string:

```
export LIBVIRT_DEFAULT_URI=qemu+unix:///system?socket=/var/run/libvirt/libvirt-sock
virsh  pool-list --all
```

### correct faulty libvirt storage permissions

problem: libvirt server can't access its own images/volumes

```shell
│ Error: error retrieving volume for disk: Storage volume not found: no storage vol with matching name 'k8s-node-0.qcow2'
│ 
│   with module.k8s-nodes["node0"].libvirt_domain.main,
│   on ../instance/main.tf line 38, in resource "libvirt_domain" "main":
│   38: resource "libvirt_domain" "main" 
```

solution: turn off apparmor and revise permissions

```
# install apparmor utils
sudo apt update
sudo apt install apparmor-utils

# disable apparmor enforcement on libvirt
sudo aa-complain /etc/apparmor.d/usr.sbin.libvirtd

# fix libvirt permissions
sudo chown -R libvirt-qemu:kvm /var/lib/libvirt
sudo chmod g+rw /var/lib/libvirt/images

# restart libvirt
sudo systemctl restart libvirtd
```