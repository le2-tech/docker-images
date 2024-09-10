
.PHONY: 
.DEFAULT_GOAL := _
_ : build

-include ../.env

tag := ${REGISTRY_HOST}${IMAGE_NS}tmp

build:
	docker build        . -t ${tag}                  ${build_proxy}

buildx:
	docker buildx build . -t ${tag} ${buildx_suffix} ${build_proxy}

