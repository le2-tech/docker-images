
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${NAMESPACE}/schemaspy

check:
	docker run -it --rm ${NAMESPACE}/awscli aws --version
	docker run -it --rm ${NAMESPACE}/awscli mysql -V
