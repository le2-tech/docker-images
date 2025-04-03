.PHONY: 
.DEFAULT_GOAL := _

_: clean clone git_patch_use buildx-fpm buildx-cli

include ../_env/Makefile

clone:
	${host_proxy_clean} git clone https://github.com/docker-library/php.git github \
	&& cd github \
	&& git checkout 20ebff40bb865416f3767540df06ad1df384337d

# https://github.com/docker-library/php/commits/master/?after=9cf25725489ff2dd1197d885455d77bbe93a3e8f+349
# 搜索 EOL,复制下一个commit

clean:
	rm -fr github

git_patch_make:
	set -eux; \
	cd github; \
	git diff > 1.patch; \
	mv 1.patch ../

git_patch_use:
	set -eux; \
	cp 1.patch github/; \
	cd github; \
	git checkout .; \
	git apply 1.patch; \
	rm 1.patch; \
	git status;

docker_image := ${REGISTRY_HOST}${IMAGE_NS}php

buildx-fpm:
	cd github/7.2/alpine3.12/fpm/ \
	&& docker buildx build . -t ${docker_image}:7.2-fpm-alpine ${build_proxy_clean} ${buildx_suffix}

buildx-cli:
	cd github/7.2/alpine3.12/cli/ \
	&& docker buildx build . -t ${docker_image}:7.2-cli-alpine ${build_proxy_clean} ${buildx_suffix}

build-cli:
	cd github/7.2/alpine3.12/cli/ \
	&& docker build . -t ${docker_image}:7.2-cli-alpine ${build_proxy_clean}
