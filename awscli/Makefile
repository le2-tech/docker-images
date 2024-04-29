
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${IMAGE_NS}awscli ${build_proxy} --pull

check:
	docker run -it --rm ${IMAGE_NS}awscli aws --version
	docker run -it --rm ${IMAGE_NS}awscli mysql -V

buildx:
	${host_proxy} docker buildx build --platform linux/amd64,linux/arm64 -t ${REGISTRY_HOST}${IMAGE_NS}awscli . --push ${build_proxy}


build2:
	docker build . -f Dockerfile.build2 -t ${IMAGE_NS}awscli2 ${build_proxy} --pull

check2:
	docker run -it --rm ${IMAGE_NS}awscli2:latest sh -c " \
		set -eux ; \
		aws --version ; \
		session-manager-plugin ; \
		mysql --version"