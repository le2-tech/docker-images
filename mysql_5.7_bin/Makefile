
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag_name := ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-ubuntu

build:
	docker build . -t ${tag_name} -f Dockerfile.ubuntu-bionic

build-client:
	docker build . -t ${tag_name}-client -f Dockerfile.ubuntu-bionic-client

check:
	@docker run -it --rm ${tag_name} sh -c " \
		set -eux ;\
		mysql -V ;\
		mysqld -V ;\
	"

buildx:
	docker buildx build . -t ${tag_name} ${buildx_suffix} ${build_proxy_clean} -f Dockerfile.ubuntu-bionic

will:
	curl -s https://launchpad.net/ubuntu/+source/mysql-5.7 | grep 'mysql-5.7' | grep -o '[0-9.]\+-[0-9]\+ubuntu[0-9.]\+' | head -n 1