
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t registry.le2.tech/le2/awscli ${build_proxy}

check:
	docker run -it --rm registry.le2.tech/le2/awscli aws --version
	docker run -it --rm registry.le2.tech/le2/awscli mysql -V

