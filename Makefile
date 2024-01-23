include ./.env

install:
	apt update
	apt upgrade -y
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends make screen zip unzip tree
	curl -fsSL https://get.docker.com -o get-docker.sh
	sh get-docker.sh

uninstall:
	apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

init-user:
	groupadd -g 1000 dev-group
	useradd -m -u 1000 -g dev-group -s /bin/bash dev-user
	usermod -aG docker dev-user
	newgrp docker
	echo "dev-user:$(openssl rand -base64 12)" >> userpass.txt
	cat userpass.txt
	chpasswd < userpass.txt
	# visudo
	#dev-user ALL=(ALL) NOPASSWD: ALL

	# # init-user-local:
	# 	# ssh-keygen -t rsa
	# 	cat ~/.ssh/vps/id_rsa.pub
	# 	ssh-copy-id -i ~/.ssh/vps/id_rsa.pub dev-user@???
	

uninit-user:
	userdel dev-user
	groupdel dev-group


prune:
	docker stop $(docker ps -aq)
	docker rm $(docker ps -aq)
	docker system prune



buildx:
	docker buildx create --name mybuilder --use
	# docker buildx create --name mybuilder
	# docker buildx use mybuilder
	docker buildx inspect --bootstrap
	docker login --username=${DOCKER_USER} -p=${DOCKER_PASSWORD} registry.cn-hongkong.aliyuncs.com

