
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

tag := ${REGISTRY_HOST}${IMAGE_NS}php

buildx-php83-airflow-dev:
	docker buildx build . -t ${tag}:8.3-airflow-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.3-cli-dev ${buildx_suffix} ${build_proxy} 

buildx-php83-airflow:
	docker buildx build . -t ${tag}:8.3-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.3-cli     ${buildx_suffix} ${build_proxy} 

buildx-php82-airflow:
	docker buildx build . -t ${tag}:8.2-airflow-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.2-cli-dev ${buildx_suffix} ${build_proxy} 
	docker buildx build . -t ${tag}:8.2-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.2-cli     ${buildx_suffix} ${build_proxy} 

build-php74-airflow:
	docker build . -t ${tag}:7.4-airflow-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli-dev
  # docker build . -t ${tag}:7.4-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli

build-php82-airflow:
	docker build . -t ${tag}:8.2-airflow-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.2-cli-dev ${build_proxy} --progress=plain
  # docker build . -t ${tag}:7.4-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli

