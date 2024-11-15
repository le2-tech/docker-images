
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

will:
	${host_proxy} curl -s https://api.github.com/repos/aws/aws-cli/tags | jq -r '.[].name' | sort -V | tail -n1
	${host_proxy} wget -qO- https://packages.debian.org/sid/mysql-client | grep 'Package: mysql-client' -A 1


tag_name := ${REGISTRY_HOST}${IMAGE_NS}awscli

build:
	${host_proxy} docker build . -t ${tag_name}  ${build_proxy} --pull

build2:
	${host_proxy} docker build . -t ${tag_name}2 ${build_proxy} --pull -f Dockerfile.build2

check:
	@docker run -it --rm ${tag_name} sh -c " \
		set -eux ;\
		aws --version ;\
		session-manager-plugin ;\
		mysql -V ;\
	"

buildx:
	${host_proxy} docker buildx build . -t ${tag_name}  ${buildx_suffix} ${build_proxy}

buildx2:
	${host_proxy} docker buildx build . -t ${tag_name}2 ${buildx_suffix} ${build_proxy} -f Dockerfile.build2

check2:
	docker run -it --rm ${tag_name} sh -c " \
		set -eux ;\
		aws --version ;\
		session-manager-plugin ;\
		mysql --version ;\
	"