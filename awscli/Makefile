
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${REGISTRY_HOST}le2/awscli ${build_proxy}

check:
	docker run -it --rm ${REGISTRY_HOST}le2/awscli aws --version
	docker run -it --rm ${REGISTRY_HOST}le2/awscli mysql -V

