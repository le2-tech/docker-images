
.PHONY: 
.DEFAULT_GOAL := _
_ : build

-include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}tmp

build:
	docker build        . -t ${tag}                  ${build_proxy_clean}

buildx:
	docker buildx build . -t ${tag} ${buildx_suffix} ${build_proxy_clean}

