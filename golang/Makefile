
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

tag_name := ${REGISTRY_HOST}${IMAGE_NS}golang

build:
	docker build . -t ${tag_name}

buildx:
	${host_proxy} docker buildx build . -t ${tag_name} ${buildx_suffix} ${build_proxy}
