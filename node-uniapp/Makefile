
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

tag := ${REGISTRY_HOST}${IMAGE_NS}node-uniapp:3

## build
build:
	${host_proxy} docker        build . ${build_proxy} -t ${tag}  --pull --no-cache --progress=plain

## buildx
buildx:
	${host_proxy} docker buildx build . ${build_proxy} -t ${tag} ${buildx_suffix}
