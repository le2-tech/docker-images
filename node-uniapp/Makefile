
.PHONY: 
.DEFAULT_GOAL := build

include ../.env_Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}node-uniapp:3

build:## build
	${host_proxy_clean} docker        build . ${build_proxy_clean} -t ${tag}  --pull --no-cache --progress=plain


buildx:## buildx
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag} ${buildx_suffix}

bash:
	docker run -it --rm ${tag} bash