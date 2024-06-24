
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

will-php82-fpm:
	curl -s 'https://registry.hub.docker.com/v2/repositories/library/php/tags/?page_size=100&name=8.2.&ordering=last_updated' \
	 | jq '[.results[] | select(.name | contains("-fpm")) | {name: .name, last_updated: .last_updated}]'

check-php82-fpm:
	@docker run -it --rm ${IMAGE_NS}php-fpm:8.2-dev sh -c " \
		php -v ;\
	"

buildx_suffix := --pull --platform linux/amd64,linux/arm64 --push

buildx-php74-fpm:
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}php-fpm:7.4-dev ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-fpm --build-arg DOCKER_ENV=dev
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}php-fpm:7.4     ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-fpm


buildx-php74-cli:
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4-dev ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli --build-arg DOCKER_ENV=dev
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4     ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli


buildx-php82-fpm-dev:
	docker buildx build . ${build_proxy} -t ${REGISTRY_HOST}${IMAGE_NS}php-fpm:8.2-dev ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.2-fpm --build-arg DOCKER_ENV=dev


buildx-php82-fpm:
	docker buildx build . ${build_proxy} -t ${REGISTRY_HOST}${IMAGE_NS}php-fpm:8.2     ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.2-fpm


buildx-php82-cli-dev:
	docker buildx build . ${build_proxy} -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:8.2-dev ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.2-cli --build-arg DOCKER_ENV=dev


buildx-php82-cli:
	docker buildx build . ${build_proxy} -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:8.2     ${buildx_suffix} --build-arg BASE_IMAGE=${REGISTRY_HOST}php --build-arg BASE_IMAGE_TAG=8.2-cli


build-cli:
	${host_proxy} docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4 --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli ${build_proxy} --progress=plain
	# ${host_proxy} docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:8.2 --build-arg BASE_IMAGE=${REGISTRY_HOST}php            --build-arg BASE_IMAGE_TAG=8.2-cli ${build_proxy} --progress=plain
