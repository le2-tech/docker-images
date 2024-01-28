
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${NAMESPACE}/awscli ${build_proxy}

check:
	docker run -it --rm ${NAMESPACE}/awscli aws --version
	docker run -it --rm ${NAMESPACE}/awscli mysql -V

