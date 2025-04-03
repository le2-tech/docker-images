
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag_name := ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0-source

build:
	docker build . -t ${tag_name} ${build_proxy_clean} --progress=plain

check:


buildx:
	docker buildx build . -t ${tag_name} ${buildx_suffix} ${build_proxy_clean}
