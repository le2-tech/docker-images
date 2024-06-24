
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

buildx_suffix := --pull --platform linux/amd64,linux/arm64 --push

build1:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0-debian -f Dockerfile.debian.sid --pull --progress=plain

build2:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0-ubuntu -f Dockerfile.ubuntu.jammy --pull --progress=plain

buildx1:
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0-debian -f Dockerfile.debian.sid ${buildx_suffix}

buildx2:
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0-ubuntu -f Dockerfile.ubuntu.jammy ${buildx_suffix}
