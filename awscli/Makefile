
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

will:
	curl -s https://api.github.com/repos/aws/aws-cli/tags | jq -r '.[].name' | sort -V | tail -n1
	wget -qO- https://packages.debian.org/sid/mysql-client | grep 'Package: mysql-client' -A 1

build:
	docker build . -t ${IMAGE_NS}awscli ${build_proxy} --pull

check:
	@docker run -it --rm ${IMAGE_NS}awscli sh -c " \
		set -eux ;\
		aws --version ;\
		session-manager-plugin ;\
		mysql -V ;\
	"

buildx:
	${host_proxy} docker buildx build --platform linux/amd64,linux/arm64 -t ${REGISTRY_HOST}${IMAGE_NS}awscli . --push ${build_proxy}


build2:
	docker build . -f Dockerfile.build2 -t ${IMAGE_NS}awscli2 ${build_proxy} --pull

check2:
	docker run -it --rm ${IMAGE_NS}awscli2:latest sh -c " \
		set -eux ;\
		aws --version ;\
		session-manager-plugin ;\
		mysql --version ;\
	"