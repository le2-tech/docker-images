
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${NAMESPACE}/awscli ${build_proxy} --pull

check:
	docker run -it --rm ${NAMESPACE}/awscli aws --version
	docker run -it --rm ${NAMESPACE}/awscli mysql -V

buildx:
	${host_proxy} docker buildx build --platform linux/amd64,linux/arm64 -t ${REGISTRY_HOST}${NAMESPACE}/awscli . --push ${build_proxy}
