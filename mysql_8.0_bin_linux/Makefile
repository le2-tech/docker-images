
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0_debian ${build_proxy} --progress=plain

check:

buildx_suffix := --pull --platform linux/amd64,linux/arm64 --push

buildx:
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7 ${buildx_suffix} ${build_proxy}
