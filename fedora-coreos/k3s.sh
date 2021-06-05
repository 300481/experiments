#!/bin/bash

mkdir -p /var/lib/rancher/k3s/storage

podman run \
	-it \
	--rm \
	--privileged \
	--name k3d \
	-v /var/run/docker.sock:/var/run/docker.sock:Z \
	-v /root/.kube:/.kube:Z \
	rancher/k3d:v4.4.4 \
	cluster create dev \
		--servers 1 \
		--image rancher/k3s:v1.21.1-k3s1 \
		--api-port 192.168.100.251:6443 \
		--k3s-server-arg --disable=traefik,servicelb,metrics-server \
		--network host \
		--volume /var/lib/rancher/k3s/storage:/var/lib/rancher/k3s/storage@server[0]
