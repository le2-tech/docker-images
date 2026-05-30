CURRENT_MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

BASE_DIR := $(abspath $(CURRENT_MAKEFILE_DIR))

-include ${BASE_DIR}/.env
-include ${BASE_DIR}/.env.${BASIC_ENV}

build_proxy_clean := $(subst ",,$(build_proxy))
# host_proxy_clean := $(subst ",,$(host_proxy))
buildx_suffix_clean := $(subst ",,$(buildx_suffix))
check_docker_args_clean := $(subst ",,$(check_docker_args))

export

buildx_suffix :=" --pull --platform linux/amd64,linux/arm64 --push"

tag_full := ${REGISTRY_HOST}${IMAGE_NS}${tag}

bash:
	docker run -it --rm ${tag_full} bash

buildx:
	docker buildx build . -t ${tag_full} ${buildx_suffix_clean} ${build_proxy_clean} --build-arg IMAGE_MIRROR=${IMAGE_MIRROR} --build-arg APT_REPOSITORY=${APT_REPOSITORY} --build-arg ALPINE_MIRROR=${ALPINE_MIRROR} --build-arg NPM_MIRROR=${NPM_MIRROR}

# --no-cache --progress=plain
build:
	docker        build . -t ${tag_full}                         ${build_proxy_clean} --pull --progress=plain --build-arg IMAGE_MIRROR=${IMAGE_MIRROR} --build-arg APT_REPOSITORY=${APT_REPOSITORY} --build-arg ALPINE_MIRROR=${ALPINE_MIRROR} --build-arg NPM_MIRROR=${NPM_MIRROR}

check:
	docker run -it --rm ${check_docker_args_clean} ${tag_full} sh -c "$(CHECK_CMD)"
