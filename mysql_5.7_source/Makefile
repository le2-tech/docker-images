
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-debian ${build_proxy} --progress=plain

check:
	

buildx:
	docker buildx build --platform linux/amd64,linux/arm64 -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7 . --push ${build_proxy}

build-client:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-client-bullseye ${build_proxy} -f Dockerfile.client.debian --progress=plain --build-arg BASE_IMAGE=bullseye-slim
	# docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:5.7-client-bookworm ${build_proxy} -f Dockerfile.client.debian --progress=plain --build-arg BASE_IMAGE=bookworm-slim
