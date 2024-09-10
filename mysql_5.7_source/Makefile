
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

tag_name := ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-debian

build:
	docker build . -t ${tag_name} ${build_proxy} --progress=plain

check:
	

buildx:
	docker buildx build . -t ${tag_name} ${buildx_suffix} ${build_proxy}

build-client:
	docker build . -t ${tag_name}-client ${build_proxy} -f Dockerfile.client.debian --progress=plain --build-arg BASE_IMAGE=bullseye-slim
