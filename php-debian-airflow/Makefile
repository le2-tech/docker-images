
.PHONY: 
.DEFAULT_GOAL := build

include ../.env_Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}php

buildx-php83-airflow-dev:
	docker buildx build . -t ${tag}:8.3-airflow-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.3-cli-dev ${buildx_suffix} ${build_proxy_clean} 

buildx-php83-airflow:
	docker buildx build . -t ${tag}:8.3-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.3-cli     ${buildx_suffix} ${build_proxy_clean} 

buildx-php82-airflow:
	docker buildx build . -t ${tag}:8.2-airflow-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.2-cli-dev ${buildx_suffix} ${build_proxy_clean} 
	docker buildx build . -t ${tag}:8.2-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.2-cli     ${buildx_suffix} ${build_proxy_clean} 

build-php74-airflow:
	docker build . -t ${tag}:7.4-airflow-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli-dev
  # docker build . -t ${tag}:7.4-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli

build-php82-airflow:
	docker build . -t ${tag}:8.2-airflow-dev --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=8.2-cli-dev ${build_proxy_clean} --progress=plain
  # docker build . -t ${tag}:7.4-airflow     --build-arg BASE_IMAGE=${REGISTRY_HOST}${IMAGE_NS}php --build-arg BASE_IMAGE_TAG=7.4-cli

