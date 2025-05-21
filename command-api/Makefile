
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}command-api

build:
	docker build . -t ${tag}

buildx:
	${host_proxy_clean} docker buildx build . -t ${tag} ${buildx_suffix_clean} ${build_proxy_clean}
