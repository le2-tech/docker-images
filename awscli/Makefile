
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

build:
	docker build . -t ${IMAGE_NS}/awscli ${build_proxy} --pull

check:
	docker run -it --rm ${IMAGE_NS}/awscli aws --version
	docker run -it --rm ${IMAGE_NS}/awscli mysql -V

buildx:
	${host_proxy} docker buildx build --platform linux/amd64,linux/arm64 -t ${REGISTRY_HOST}${IMAGE_NS}/awscli . --push ${build_proxy}
