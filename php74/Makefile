.PHONY: 
.DEFAULT_GOAL := _

include ../.env

_: clean clone buildx1 buildx2

clone:
	${host_proxy} git clone https://github.com/docker-library/php.git github \
	&& cd github \
	&& git checkout 1361ba95d80570e3984f9de9f765948246191557

# https://github.com/docker-library/php/commits?before=2a7223d7ad5e6fb1423c52db134339b20bbc7177+35
# 搜索 EOL,复制下一个commit

clean:
	rm -fr github

buildx-fpm:
	cd github/7.4/bullseye/fpm/ \
	&& docker buildx build . --platform linux/amd64,linux/arm64 -t ${REGISTRY_HOST}${IMAGE_NS}/php:7.4-fpm ${build_proxy} --push

buildx-cli:
	cd github/7.4/bullseye/cli/ \
	&& docker buildx build . --platform linux/amd64,linux/arm64 -t ${REGISTRY_HOST}${IMAGE_NS}/php:7.4-cli ${build_proxy} --push
