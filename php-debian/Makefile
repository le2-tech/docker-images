
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}php

will-php82-fpm:
	curl -s 'https://registry.hub.docker.com/v2/repositories/library/php/tags/?page_size=100&name=8.2.&ordering=last_updated' \
	 | jq '[.results[] | select(.name | contains("-fpm")) | {name: .name, last_updated: .last_updated}]'

will-php83-fpm:
	${host_proxy_clean} curl -s 'https://registry.hub.docker.com/v2/repositories/library/php/tags/?page_size=100&name=8.3.&ordering=last_updated' \
	 | jq '[.results[] | select(.name | contains("-fpm")) | {name: .name, last_updated: .last_updated}]'


check-php82-fpm:
	@docker run -it --rm ${IMAGE_NS}php-fpm:8.2-dev sh -c " \
		php -v ;\
	"

check-php83-fpm:
	@docker run -it --rm ${IMAGE_NS}php-fpm:8.3-dev sh -c " \
		php -v ;\
	"

## php74

buildx-php74-fpm:
	docker buildx build . -t ${tag}:7.4-fpm-dev ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-fpm0 --build-arg DOCKER_ENV=dev
	docker buildx build . -t ${tag}:7.4-fpm     ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-fpm0

buildx-php74-cli:
	docker buildx build . -t ${tag}:7.4-cli-dev ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli0 --build-arg DOCKER_ENV=dev
	docker buildx build . -t ${tag}:7.4-cli     ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli0

## php82

buildx-php82-fpm-dev:
	docker buildx build . ${build_proxy_clean} -t ${tag}:8.2-fpm-dev ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.2-fpm --build-arg DOCKER_ENV=dev


buildx-php82-fpm:
	docker buildx build . ${build_proxy_clean} -t ${tag}:8.2-fpm     ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.2-fpm


buildx-php82-cli-dev:
	docker buildx build . ${build_proxy_clean} -t ${tag}:8.2-cli-dev ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.2-cli --build-arg DOCKER_ENV=dev


buildx-php82-cli:
	docker buildx build . ${build_proxy_clean} -t ${tag}8.2-cli     ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.2-cli

## php83

buildx-php83: buildx-php83-fpm-dev buildx-php83-fpm buildx-php83-cli-dev buildx-php83-cli

buildx-php83-fpm-dev:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag}:8.3-fpm-dev ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.3-fpm --build-arg DOCKER_ENV=dev

buildx-php83-fpm:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag}:8.3-fpm     ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.3-fpm

buildx-php83-cli-dev:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag}:8.3-cli-dev ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.3-cli --build-arg DOCKER_ENV=dev

buildx-php83-cli:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag}:8.3-cli     ${buildx_suffix_clean} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.3-cli

build-test:
	# ${host_proxy_clean} docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4 --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli ${build_proxy_clean} --progress=plain
	# ${host_proxy_clean} docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:8.2 --build-arg BASE_IMAGE=${REGISTRY_HOST}php            --build-arg BASE_IMAGE_TAG=8.2-cli ${build_proxy_clean} --progress=plain
	${host_proxy_clean} docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:8.3 --build-arg BASE_IMAGE=${REGISTRY_HOST}php            --build-arg BASE_IMAGE_TAG=8.3-cli ${build_proxy_clean} --progress=plain
