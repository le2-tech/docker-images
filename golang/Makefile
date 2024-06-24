
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}golang

check:
	

buildx_suffix := --pull --platform linux/amd64,linux/arm64 --push

tag_name := ${REGISTRY_HOST}${IMAGE_NS}golang

buildx:
	${host_proxy} docker buildx build . -t ${tag_name} ${buildx_suffix} ${build_proxy}
