
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t le2/lambda-go

check:
	

buildx:
	docker buildx build --platform linux/amd64,linux/arm64 -t registry.le2.tech/le2/golang-lambda . --push
