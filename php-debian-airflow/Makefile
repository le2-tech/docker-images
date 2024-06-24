
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

buildx_suffix := --pull --platform linux/amd64,linux/arm64 --push

buildx-php82-airflow:
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}php-airflow:8.2-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php-cli --build-arg BASE_IMAGE_TAG=8.2-dev ${buildx_suffix} ${build_proxy} 
	docker buildx build . -t ${REGISTRY_HOST}${IMAGE_NS}php-airflow:8.2     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php-cli --build-arg BASE_IMAGE_TAG=8.2     ${buildx_suffix} ${build_proxy} 

build-php74-airflow:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-airflow:7.4-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php-cli --build-arg BASE_IMAGE_TAG=7.4-dev
  # docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php-cli --build-arg BASE_IMAGE_TAG=7.4

build-php82-airflow:
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-airflow:8.2-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php-cli --build-arg BASE_IMAGE_TAG=8.2-dev ${build_proxy} --progress=plain
  # docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php-cli --build-arg BASE_IMAGE_TAG=7.4

