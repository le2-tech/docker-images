
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0_debian ${build_proxy} --progress=plain

check:
	

buildx:
	docker buildx build --platform linux/amd64,linux/arm64 -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7 . --push ${build_proxy}
