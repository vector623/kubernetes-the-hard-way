#!make

connect:
	terraform login

taint:
	#-terraform taint libvirt_network.kube_network
	-terraform taint module.k8s-nodes[\"server\"].libvirt_domain.main
	-terraform taint module.k8s-nodes[\"server\"].libvirt_domain.main
	-terraform taint module.k8s-nodes[\"node0\"].libvirt_domain.main
	-terraform taint module.k8s-nodes[\"node0\"].libvirt_domain.main
	-terraform taint module.k8s-nodes[\"node1\"].libvirt_domain.main
	-terraform taint module.k8s-nodes[\"node1\"].libvirt_domain.main


ssh-hosts-reset:
	ssh-keygen -f "/home/davidg/.ssh/known_hosts" -R "10.17.3.10"
	ssh-keygen -f "/home/davidg/.ssh/known_hosts" -R "10.17.3.20"
	ssh-keygen -f "/home/davidg/.ssh/known_hosts" -R "10.17.3.21"

clean: taint ssh-hosts-reset

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

