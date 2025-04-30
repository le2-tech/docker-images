
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

will:
	${host_proxy_clean} curl -s https://api.github.com/repos/aws/aws-cli/tags | jq -r '.[].name' | sort -V | tail -n1
	${host_proxy_clean} wget -qO- https://packages.debian.org/sid/mysql-client | grep 'Package: mysql-client' -A 1

tag := ${REGISTRY_HOST}${IMAGE_NS}awscli

build:
	${host_proxy_clean} docker build . -t ${tag}  ${build_proxy_clean} --pull

build2:
	${host_proxy_clean} docker build . -t ${tag}2 ${build_proxy_clean} --pull -f Dockerfile.build2

check:
	@docker run -it --rm ${tag} sh -c " \
		set -eux ;\
		aws --version ;\
		session-manager-plugin ;\
		mysql -V ;\
	"

buildx:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag} ${buildx_suffix_clean}

buildx2:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag}:2 ${buildx_suffix_clean} -f Dockerfile.build2

check2:
	docker run -it --rm ${tag} sh -c " \
		set -eux ;\
		aws --version ;\
		session-manager-plugin ;\
		mysql --version ;\
	"