
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-debian

build:
	docker build . -t ${tag} ${build_proxy_clean} --progress=plain

check:
	

buildx:
	docker buildx build . -t ${tag} ${buildx_suffix} ${build_proxy_clean}

build-client:
	docker build . -t ${tag}-client ${build_proxy_clean} -f Dockerfile.client.debian --progress=plain --build-arg BASE_IMAGE=bullseye-slim
