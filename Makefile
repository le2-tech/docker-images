CURRENT_MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

BASE_DIR := $(abspath $(CURRENT_MAKEFILE_DIR))

-include ${BASE_DIR}/.env
-include ${BASE_DIR}/.env.${BASIC_ENV}

export

buildx_suffix :=--pull --platform linux/amd64,linux/arm64 --push

tag_full := ${REGISTRY_HOST}${IMAGE_NS}${tag}

bash:
	docker run -it --rm ${tag_full} bash

buildx:
	docker buildx build . -t ${tag_full} ${buildx_suffix} --build-arg https_proxy=${_https_proxy} --build-arg http_proxy=${_http_proxy} --build-arg IMAGE_MIRROR=${IMAGE_MIRROR} --build-arg APT_REPOSITORY=${APT_REPOSITORY} --build-arg ALPINE_MIRROR=${ALPINE_MIRROR} --build-arg NPM_MIRROR=${NPM_MIRROR}

# --no-cache --progress=plain
build:
	docker        build . -t ${tag_full}                         --build-arg https_proxy=${_https_proxy} --build-arg http_proxy=${_http_proxy} --pull --progress=plain --build-arg IMAGE_MIRROR=${IMAGE_MIRROR} --build-arg APT_REPOSITORY=${APT_REPOSITORY} --build-arg ALPINE_MIRROR=${ALPINE_MIRROR} --build-arg NPM_MIRROR=${NPM_MIRROR}

DOCKER_RUN_FLAGS ?= -it

check:
	docker run ${DOCKER_RUN_FLAGS} --rm ${check_docker_args} ${tag_full} sh -c "$(CHECK_CMD)"
