#!make

connect:
	terraform login

taint:
	terraform taint libvirt_volume.debian-bookworm-qcow2-server
	terraform taint libvirt_domain.k8s-server

apply:
	terraform apply -auto-approve

console:
	sudo virsh console k8s-server

shutdown:
	sudo virsh shutdown k8s-server
