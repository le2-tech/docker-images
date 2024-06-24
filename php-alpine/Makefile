
.PHONY: 
.DEFAULT_GOAL := 

include ../.env

_tag72 := ${REGISTRY_HOST}${IMAGE_NS}php-fpm:7.2
_tag70 := ${REGISTRY_HOST}${IMAGE_NS}php-fpm:7.0


will-fpm:
	${host_proxy} curl -s 'https://registry.hub.docker.com/v2/repositories/library/php/tags/?page_size=100&name=7.2&ordering=last_updated' \
	 | jq '[.results[] | select(.name | contains("-fpm-alpine")) | {name: .name, last_updated: .last_updated}]'


check-fpm:
	docker run -it --rm ${_tag72}-dev sh -c " \
		php -v ;\
	"
buildx_suffix := --pull --platform linux/amd64,linux/arm64 --push

buildx-fpm-70-dev:
	docker buildx build . -t ${_tag70}-dev ${buildx_suffix} --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.0-fpm-alpine --build-arg DOCKER_ENV=dev
buildx-fpm-70:
	docker buildx build . -t ${_tag70}     ${buildx_suffix} --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.0-fpm-alpine 

buildx-fpm-72-dev:
	docker buildx build . -t ${_tag72}-dev ${buildx_suffix} --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.2-fpm-alpine --build-arg DOCKER_ENV=dev
buildx-fpm-72:
	docker buildx build . -t ${_tag72}     ${buildx_suffix} --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.2-fpm-alpine


build-fpm-70:
	${host_proxy} docker build . -t ${_tag70}-dev --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.0-fpm-alpine --build-arg DOCKER_ENV=dev --progress=plain ${build_proxy}


build-fpm-72:
	${host_proxy} docker build . -t ${_tag72}-dev --build-arg BASE_IMAGE=${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.2-fpm-alpine --build-arg DOCKER_ENV=dev --progress=plain ${build_proxy}

