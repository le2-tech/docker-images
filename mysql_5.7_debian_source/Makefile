
.PHONY: 
.DEFAULT_GOAL := build
tag := mysql:5.7-debian

include ../_env/Makefile



build-client:
	docker build . -t ${tag}-client ${build_proxy_clean} -f Dockerfile.client.debian --progress=plain --build-arg BASE_IMAGE=bullseye-slim
