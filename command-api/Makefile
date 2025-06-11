
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}command-api

docker-build:
	docker build . -t ${tag}

docker-buildx:
	${host_proxy_clean} docker buildx build . -t ${tag} ${buildx_suffix_clean} ${build_proxy_clean}


build0:
	CGO_ENABLED=0 go build
	ls -lh command-api

build:
	CGO_ENABLED=0 go build -trimpath -ldflags="-s -w"
	ls -lh command-api
	#strip -u -r command-api
	#upx --best --lzma --force-macos command-api
	ls -lh command-api
	file command-api