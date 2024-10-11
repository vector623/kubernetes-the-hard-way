#!make

connect:
	terraform login

taint:
	terraform taint libvirt_network.kube_network
	terraform taint module.k8s-server.libvirt_domain.domain
	terraform taint module.k8s-server.libvirt_volume.base-volume
	terraform taint module.k8s-agent0.libvirt_domain.domain
	terraform taint module.k8s-agent0.libvirt_volume.base-volume
	terraform taint module.k8s-agent1.libvirt_domain.domain
	terraform taint module.k8s-agent1.libvirt_volume.base-volume

apply:
	terraform apply -auto-approve

console:
	sudo virsh console k8s-server

shutdown:
	sudo virsh shutdown k8s-server

start:
	sudo virsh start k8s-server

list:
	sudo virsh list --all

