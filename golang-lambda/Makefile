
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${REGISTRY_HOST}${NAMESPACE}/golang-lambda

check:
	

buildx:
	docker buildx build --platform linux/amd64,linux/arm64 -t ${REGISTRY_HOST}${NAMESPACE}/golang-lambda . --push
