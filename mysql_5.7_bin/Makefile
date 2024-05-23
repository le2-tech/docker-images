
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-ubuntu -f Dockerfile.ubuntu-bionic

build2:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-ubuntu-client -f Dockerfile.ubuntu-bionic-client


check:
	@docker run -it --rm ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-ubuntu sh -c " \
		set -eux ;\
		mysql -V ;\
		mysqld -V ;\
	"

buildx:
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-ubuntu -f Dockerfile.ubuntu-bionic --platform linux/amd64,linux/arm64  --push ${build_proxy}

will:
	curl -s https://launchpad.net/ubuntu/+source/mysql-5.7 | grep 'mysql-5.7' | grep -o '[0-9.]\+-[0-9]\+ubuntu[0-9.]\+' | head -n 1