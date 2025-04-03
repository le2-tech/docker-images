
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag_name := ${REGISTRY_HOST}${IMAGE_NS}golang-lambda

build:
	docker build . -t ${tag_name}

check:
	

buildx:
	docker buildx build . -t ${tag_name} ${buildx_suffix} ${build_proxy_clean}
