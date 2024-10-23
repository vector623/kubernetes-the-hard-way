#!make

LIBVIRT_DEFAULT_URI=qemu+unix:///system?socket=/var/run/libvirt/libvirt-sock
export

connect:
	terraform login

virsh-test-cn:
	#virsh -c test:///default list
	#virsh -c qemu+unix:///system?socket=/var/run/libvirt/libvirt-sock pool-list --all
	virsh  pool-list --all

taint:
	terraform taint libvirt_network.kube_network
	terraform taint module.k8s-nodes[\"server\"].libvirt_domain.main
	terraform taint module.k8s-nodes[\"server\"].libvirt_volume.main
	terraform taint module.k8s-nodes[\"node0\"].libvirt_domain.main
	terraform taint module.k8s-nodes[\"node0\"].libvirt_volume.main
	terraform taint module.k8s-nodes[\"node1\"].libvirt_domain.main
	terraform taint module.k8s-nodes[\"node1\"].libvirt_volume.main


ssh-hosts-reset:
	ssh-keygen -f "/home/davidg/.ssh/known_hosts" -R "10.17.3.10"
	ssh-keygen -f "/home/davidg/.ssh/known_hosts" -R "10.17.3.20"
	ssh-keygen -f "/home/davidg/.ssh/known_hosts" -R "10.17.3.21"

reset: taint ssh-hosts-reset

clean: fix-perms
	-sudo virsh destroy k8s-server
	-sudo virsh destroy k8s-node-0
	-sudo virsh destroy k8s-node-1
	-sudo virsh undefine k8s-server
	-sudo virsh undefine k8s-node-0
	-sudo virsh undefine k8s-node-1
	-sudo virsh vol-delete --pool default k8s-server.iso
	-sudo virsh vol-delete --pool default k8s-node-0.iso
	-sudo virsh vol-delete --pool default k8s-node-1.iso
	-terraform state rm module.k8s-nodes\[\"node0\"\].data.template_file.user_data
	-terraform state rm module.k8s-nodes\[\"node0\"\].libvirt_cloudinit_disk.commoninit
	-terraform state rm module.k8s-nodes\[\"node0\"\].libvirt_domain.main
	-terraform state rm module.k8s-nodes\[\"node1\"\].data.template_file.user_data
	-terraform state rm module.k8s-nodes\[\"node1\"\].libvirt_cloudinit_disk.commoninit
	-terraform state rm module.k8s-nodes\[\"node1\"\].libvirt_domain.main
	-terraform state rm module.k8s-nodes\[\"server\"\].data.template_file.user_data
	-terraform state rm module.k8s-nodes\[\"server\"\].libvirt_cloudinit_disk.commoninit
	-terraform state rm module.k8s-nodes\[\"server\"\].libvirt_domain.main
	-rm ~/k8s-pool/k8s-server.iso

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

fix-perms:
	-sudo chown -R davidg:davidg /home/davidg/k8s-pool