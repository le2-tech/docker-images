
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}node-uniapp:3

build:## build  // --no-cache
	${host_proxy_clean} docker        build . -t ${tag}                        ${build_proxy_clean}   --pull --progress=plain


buildx:## buildx
	${host_proxy_clean} docker buildx build . -t ${tag} ${buildx_suffix_clean} ${build_proxy_clean}

bash:
	docker run -it --rm ${tag} bash