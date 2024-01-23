
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t registry.cn-hongkong.aliyuncs.com/le2/golang

check:
	

buildx:
	docker buildx build --platform linux/amd64,linux/arm64 -t registry.cn-hongkong.aliyuncs.com/le2/golang . --push
