
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}golang

build:
	docker build . -t ${tag}

buildx:
	${host_proxy_clean} docker buildx build . -t ${tag} ${buildx_suffix} ${build_proxy_clean}
