
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}golang-lambda

build:
	docker build . -t ${tag}

check:
	

buildx:
	docker buildx build . -t ${tag} ${buildx_suffix} ${build_proxy_clean}
