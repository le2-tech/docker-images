
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t registry.cn-hongkong.aliyuncs.com/le2/awscli ${build_proxy}

check:
	docker run -it --rm registry.cn-hongkong.aliyuncs.com/le2/awscli aws --version
	docker run -it --rm registry.cn-hongkong.aliyuncs.com/le2/awscli mysql -V

