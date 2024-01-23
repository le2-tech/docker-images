
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t registry.cn-hongkong.aliyuncs.com/le2/mysql:5.7

check:
	

buildx:
	docker buildx build --platform linux/arm64 -t registry.cn-hongkong.aliyuncs.com/le2/mysql:5.7 . --push
