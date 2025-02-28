
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

tag := ${REGISTRY_HOST}${IMAGE_NS}php

will-php82-fpm:
	curl -s 'https://registry.hub.docker.com/v2/repositories/library/php/tags/?page_size=100&name=8.2.&ordering=last_updated' \
	 | jq '[.results[] | select(.name | contains("-fpm")) | {name: .name, last_updated: .last_updated}]'

will-php83-fpm:
	${host_proxy} curl -s 'https://registry.hub.docker.com/v2/repositories/library/php/tags/?page_size=100&name=8.3.&ordering=last_updated' \
	 | jq '[.results[] | select(.name | contains("-fpm")) | {name: .name, last_updated: .last_updated}]'


check-php82-fpm:
	@docker run -it --rm ${IMAGE_NS}php-fpm:8.2 sh -c " \
		php -v ;\
	"

check-php83-fpm:
	@docker run -it --rm ${IMAGE_NS}php-fpm:8.3 sh -c " \
		php -v ;\
	"


## php83

buildx-php83: buildx-php83-fpm buildx-php83-cli

buildx-php83-fpm:
	${host_proxy} docker buildx build . ${build_proxy} -t ${tag}:8.3-fpm     ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.3-fpm

buildx-php83-cli:
	${host_proxy} docker buildx build . ${build_proxy} -t ${tag}:8.3-cli     ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.3-cli

build-test:
	# ${host_proxy} docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4 --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli ${build_proxy} --progress=plain
	# ${host_proxy} docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:8.2 --build-arg BASE_IMAGE=${REGISTRY_HOST}php            --build-arg BASE_IMAGE_TAG=8.2-cli ${build_proxy} --progress=plain
	${host_proxy} docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:8.3 --build-arg BASE_IMAGE=${REGISTRY_HOST}php            --build-arg BASE_IMAGE_TAG=8.3-cli ${build_proxy} --progress=plain
