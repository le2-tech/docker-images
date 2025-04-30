
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}mysql:8.0-source

build:
	docker build . -t ${tag} ${build_proxy_clean} --progress=plain

check:


buildx:
	docker buildx build . -t ${tag} ${buildx_suffix_clean} ${build_proxy_clean}
