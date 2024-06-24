
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

tag_name := ${REGISTRY_HOST}${IMAGE_NS}golang-lambda

build:
	docker build . -t ${tag_name}

check:
	

buildx_suffix := --pull --platform linux/amd64,linux/arm64 --push

buildx:
	docker buildx build . -t ${tag_name} ${buildx_suffix} ${build_proxy}
