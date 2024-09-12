
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

will:
	curl -s https://api.github.com/repos/aws/aws-cli/tags | jq -r '.[].name' | sort -V | tail -n1
	wget -qO- https://packages.debian.org/sid/mysql-client | grep 'Package: mysql-client' -A 1


tag_name := ${REGISTRY_HOST}${IMAGE_NS}awscli

build:
	docker build . -t ${tag_name} ${build_proxy} --pull

check:
	@docker run -it --rm ${tag_name} sh -c " \
		set -eux ;\
		aws --version ;\
		session-manager-plugin ;\
		mysql -V ;\
	"

buildx:
	${host_proxy} docker buildx build . -t ${tag_name} ${buildx_suffix} ${build_proxy}

build2:
	docker build . -f Dockerfile.build2 -t ${tag_name}2 ${build_proxy} --pull

check2:
	docker run -it --rm ${tag_name}2 sh -c " \
		set -eux ;\
		aws --version ;\
		session-manager-plugin ;\
		mysql --version ;\
	"