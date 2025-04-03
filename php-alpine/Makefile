
.PHONY: 
.DEFAULT_GOAL := 

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}php

will-fpm:
	${host_proxy_clean} curl -s 'https://registry.hub.docker.com/v2/repositories/library/php/tags/?page_size=100&name=7.2&ordering=last_updated' \
	 | jq '[.results[] | select(.name | contains("-fpm-alpine")) | {name: .name, last_updated: .last_updated}]'


check-fpm:
	docker run -it --rm ${tag}:7.2-fpm-dev sh -c " \
		php -v ;\
	"

buildx-fpm-70-dev:
	docker buildx build . -t ${tag}:7.0-fpm-alpine-dev ${buildx_suffix} ${build_proxy_clean} --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.0-fpm-alpine --build-arg DOCKER_ENV=dev
buildx-fpm-70:
	docker buildx build . -t ${tag}:7.0-fpm-alpine     ${buildx_suffix} ${build_proxy_clean} --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.0-fpm-alpine
buildx-fpm-72-dev:
	docker buildx build . -t ${tag}:7.2-fpm-alpine-dev ${buildx_suffix} ${build_proxy_clean} --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.2-fpm-alpine --build-arg DOCKER_ENV=dev
buildx-fpm-72:
	docker buildx build . -t ${tag}:7.2-fpm-alpine     ${buildx_suffix} ${build_proxy_clean} --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.2-fpm-alpine


build-fpm-70:
	docker build . -t ${tag}:7.0-fpm-dev --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.0-fpm-alpine --build-arg DOCKER_ENV=dev --progress=plain ${build_proxy_clean}


build-fpm-72:
	docker build . -t ${tag}:7.2-fpm-dev --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.2-fpm-alpine --build-arg DOCKER_ENV=dev --progress=plain ${build_proxy_clean}

