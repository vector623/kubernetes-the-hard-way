#!make

install-hypervisor:

start-hypervisor:
	sudo systemctl start libvirtd
	sudo systemctl enable libvirtd

connect:
	terraform login

fix-perms:
	sudo chown -R libvirt-qemu:kvm ~/kvm-storage
	sudo chmod 600 ~/kvm-storage/*

tf-apply: fix-perms
	terraform apply

clean:
	-sudo virsh net-destroy k8snet
	-sudo virsh net-undefine k8snet
