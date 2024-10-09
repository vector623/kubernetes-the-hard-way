#!make

install-hypervisor:

start-hypervisor:
	sudo systemctl start libvirtd
	sudo systemctl enable libvirtd

connect:
	terraform login

taint:
	terraform taint libvirt_volume.debian-bookworm-qcow2-server
	terraform taint libvirt_domain.k8s-server

apply:
	terraform apply -auto-approve

console:
	sudo virsh console k8s-server

clean:
	-sudo virsh net-destroy k8snet
	-sudo virsh net-undefine k8snet
