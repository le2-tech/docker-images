
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-ubuntu

build:
	docker build . -t ${tag} -f Dockerfile.ubuntu-bionic

build-client:
	docker build . -t ${tag}-client -f Dockerfile.ubuntu-bionic-client

check:
	@docker run -it --rm ${tag} sh -c " \
		set -eux ;\
		mysql -V ;\
		mysqld -V ;\
	"

buildx:
	docker buildx build . -t ${tag} ${buildx_suffix} ${build_proxy_clean} -f Dockerfile.ubuntu-bionic

will:
	curl -s https://launchpad.net/ubuntu/+source/mysql-5.7 | grep 'mysql-5.7' | grep -o '[0-9.]\+-[0-9]\+ubuntu[0-9.]\+' | head -n 1