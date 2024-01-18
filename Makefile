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
	docker buildx inspect --bootstrap

# 由于docker设定的iptable规则的优先级高于ufw设定的iptable规则，所以导致ufw设定docker打开的端口无效。
# 之后考虑使用 DOCKER-USER 链: iptables -I DOCKER-USER -p tcp --dport 9087 -j REJECT
# ufw-install:
# 	apt update 
# 	apt install -y ufw

# ufw-config:
# 	sudo ufw default deny incoming
# 	sudo ufw default allow outgoing
# 	# sudo ufw allow ssh
# 	sudo ufw allow 22
# 	sudo ufw enable
# 	sudo ufw deny from any to any port 9000:9999 proto tcp
# 	sudo ufw allow from 125.70.177.230/24 #cd
# 	sudo ufw allow from 103.235.18.152/24 #hk
# 	sudo ufw status verbose


