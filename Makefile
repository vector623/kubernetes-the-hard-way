#!make

start:
	sudo virsh start k8s-server
	sudo virsh start k8s-node-0
	sudo virsh start k8s-node-1

stop:
	sudo virsh destroy k8s-server
	sudo virsh destroy k8s-node-0
	sudo virsh destroy k8s-node-1
