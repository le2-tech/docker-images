
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

tag_name := ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0-source

build:
	docker build . -t ${tag_name} ${build_proxy} --progress=plain

check:


buildx:
	docker buildx build . -t ${tag_name} ${buildx_suffix} ${build_proxy}
