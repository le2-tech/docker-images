
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0

build1:
	docker build . -t ${tag}-debian -f Dockerfile.debian.sid --pull --progress=plain

build2:
	docker build . -t ${tag}-ubuntu -f Dockerfile.ubuntu.jammy --pull --progress=plain

buildx1:
	docker buildx build . -t ${tag}-debian -f Dockerfile.debian.sid ${buildx_suffix}

buildx2:
	docker buildx build . -t ${tag}-ubuntu -f Dockerfile.ubuntu.jammy ${buildx_suffix}
