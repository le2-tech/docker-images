
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}rabbitmq:3-management

## buildx
buildx:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag} ${buildx_suffix}
