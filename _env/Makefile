CURRENT_MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

BASE_DIR := $(abspath $(CURRENT_MAKEFILE_DIR)/../)

include ${BASE_DIR}/.env
include ${BASE_DIR}/_env/${BASIC_ENV}.env

buildx_suffix :=" --pull --platform linux/amd64,linux/arm64 --push"

build_proxy_clean := $(subst ",,$(build_proxy))
host_proxy_clean := $(subst ",,$(host_proxy))
buildx_suffix_clean := $(subst ",,$(buildx_suffix))

tag_full := ${REGISTRY_HOST}${IMAGE_NS}${tag}

bash:
	${host_proxy_clean} docker run -it --rm ${tag_full} bash

buildx:
	${host_proxy_clean} docker buildx build . -t ${tag_full} ${buildx_suffix_clean} ${build_proxy_clean}

# --no-cache --progress=plain
build:
	${host_proxy_clean} docker        build . -t ${tag_full}                         ${build_proxy_clean} --pull --progress=plain

check:
	${host_proxy_clean} docker run -it --rm ${tag_full} sh -c "$(CHECK_CMD)"
