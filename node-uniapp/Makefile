
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}node-uniapp:3

build:## build
	${host_proxy_clean} docker        build . ${build_proxy_clean} -t ${tag}  --pull --no-cache --progress=plain


buildx:## buildx
	${host_proxy_clean} docker buildx build . -t ${tag} ${buildx_suffix_clean} ${build_proxy_clean}

bash:
	docker run -it --rm ${tag} bash