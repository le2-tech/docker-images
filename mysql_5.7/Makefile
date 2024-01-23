
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t registry.le2.tech/le2/mysql:5.7

check:
	

buildx:
	docker buildx build --platform linux/arm64 -t registry.le2.tech/le2/mysql:5.7 . --push
