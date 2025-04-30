.PHONY: 
.DEFAULT_GOAL := _

_: clean clone buildx-fpm buildx-cli

include ../_env/Makefile

clone:
	${host_proxy_clean} git clone https://github.com/docker-library/php.git github \
	&& cd github \
	&& git checkout 1361ba95d80570e3984f9de9f765948246191557

# https://github.com/docker-library/php/commits?before=2a7223d7ad5e6fb1423c52db134339b20bbc7177+35
# 搜索 EOL,复制下一个commit

clean:
	rm -fr github

tag := ${REGISTRY_HOST}${IMAGE_NS}php


buildx-fpm:
	cd github/7.4/bullseye/fpm/ \
	&& docker buildx build . -t ${tag}:7.4-fpm ${build_proxy_clean} ${buildx_suffix_clean}

buildx-cli:
	cd github/7.4/bullseye/cli/ \
	&& docker buildx build . -t ${tag}:7.4-cli ${build_proxy_clean} ${buildx_suffix_clean}

build-cli:
	cd github/7.4/bullseye/cli/ \
	&& docker build . -t ${tag}:7.4-cli ${build_proxy_clean}
