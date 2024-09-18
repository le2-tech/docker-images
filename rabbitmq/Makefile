
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

tag := ${REGISTRY_HOST}${IMAGE_NS}rabbitmq:3-management

## buildx
buildx:
	docker buildx build . ${build_proxy} -t ${tag} ${buildx_suffix}
