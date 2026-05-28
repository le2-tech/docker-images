CURRENT_MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

BASE_DIR := $(abspath $(CURRENT_MAKEFILE_DIR))

-include ${BASE_DIR}/.env
include ${BASE_DIR}/.env.${BASIC_ENV}

build_proxy_clean := $(subst ",,$(build_proxy))
# host_proxy_clean := $(subst ",,$(host_proxy))
buildx_suffix_clean := $(subst ",,$(buildx_suffix))
check_docker_args_clean := $(subst ",,$(check_docker_args))

export

buildx_suffix :=" --pull --platform linux/amd64,linux/arm64 --push"

tag_full := ${REGISTRY_HOST}${IMAGE_NS}${tag}

bash:
	docker run -it --rm ${tag_full} bash

buildx:
	docker buildx build . -t ${tag_full} ${buildx_suffix_clean} ${build_proxy_clean} --build-arg IMAGE_MIRROR=${IMAGE_MIRROR} --build-arg APT_REPOSITORY=${APT_REPOSITORY}

# --no-cache --progress=plain
build:
	env
	docker        build . -t ${tag_full}                         ${build_proxy_clean} --pull --progress=plain --build-arg IMAGE_MIRROR=${IMAGE_MIRROR} --build-arg APT_REPOSITORY=${APT_REPOSITORY}

check:
	docker run -it --rm ${check_docker_args_clean} ${tag_full} sh -c "$(CHECK_CMD)"

# install:
# 	sudo apt update
# 	sudo apt upgrade -y
# 	DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends make screen zip unzip tree
# 	curl -fsSL https://get.docker.com -o get-docker.sh
# 	sh get-docker.sh

# uninstall:
# 	apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# init-user:
# 	groupadd -g 1000 dev-group
# 	useradd -m -u 1000 -g dev-group -s /bin/bash dev-user
# 	usermod -aG docker dev-user
# 	newgrp docker
# 	echo "dev-user:$(openssl rand -base64 12)" >> userpass.txt
# 	cat userpass.txt
# 	chpasswd < userpass.txt
# 	# visudo
# 	#dev-user ALL=(ALL) NOPASSWD: ALL

# 	# # init-user-local:
# 	# 	# ssh-keygen -t rsa
# 	# 	cat ~/.ssh/vps/id_rsa.pub
# 	# 	ssh-copy-id -i ~/.ssh/vps/id_rsa.pub dev-user@???

# uninit-user:
# 	userdel dev-user
# 	groupdel dev-group

# init-ecsuser:
# 	sudo usermod -aG docker ecs-user
# 	newgrp docker

# prune:
# 	docker stop $(docker ps -aq)
# 	docker rm $(docker ps -aq)
# 	docker system prune

# buildx-init:
# 	docker buildx create --name mybuilder --use
# 	# docker buildx create --name mybuilder
# 	# docker buildx use mybuilder
# 	docker buildx inspect --bootstrap

# login_hub:
# 	docker login --username=${DOCKER_USERNAME} -p=${DOCKER_PASSWORD} ${REGISTRY_HOST}
