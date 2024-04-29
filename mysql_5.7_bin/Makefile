
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-ubuntu -f Dockerfile.ubuntu-bionic

build2:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-ubuntu-client -f Dockerfile.ubuntu-bionic-client


check:
	

buildx:
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-ubuntu -f Dockerfile.ubuntu-bionic --platform linux/amd64,linux/arm64  --push ${build_proxy}
