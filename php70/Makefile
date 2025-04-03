.PHONY: 
.DEFAULT_GOAL := _

_: clean clone git_patch_use buildx-fpm buildx-cli

include ../_env/Makefile

clone:
	${host_proxy_clean} git clone https://github.com/docker-library/php.git github \
	&& cd github \
	&& git checkout 0e5c984e02d9027c25794bfb5002a2f9da26a7ec

# https://github.com/docker-library/php/commits/master/?after=e5d6f311d3162ef1440914c05130a4280a719f52+559
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

tag := ${REGISTRY_HOST}${IMAGE_NS}php


buildx-fpm:
	cd github/7.0/alpine3.7/fpm/ \
	&& docker buildx build . -t ${tag}:7.0-fpm-alpine ${build_proxy_clean} ${buildx_suffix}

buildx-cli:
	cd github/7.0/alpine3.7/cli/ \
	&& docker buildx build . -t ${tag}:7.0-cli-alpine ${build_proxy_clean} ${buildx_suffix}

build-cli:
	cd github/7.0/alpine3.7/cli/ \
	&& docker build . -t ${tag}:7.0-cli-alpine ${build_proxy_clean}
