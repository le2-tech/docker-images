
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)
OS := $(shell uname -s)

build: ## build
ifeq ($(OS),Linux)
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4-dev --pull --build-arg DOCKER_ENV=dev --build-arg USER_ID=$(USER_ID) --build-arg GROUP_ID=$(GROUP_ID)
else ifeq ($(OS),Darwin)
	docker build . -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4-dev --pull --build-arg DOCKER_ENV=dev ${build_proxy}
else
	@echo "This is neither Linux nor Mac"
endif

buildx:
	docker buildx build --platform linux/amd64,linux/arm64 --build-arg DOCKER_ENV=dev -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4-dev . --push
	docker buildx build --platform linux/amd64,linux/arm64                            -t ${REGISTRY_HOST}${IMAGE_NS}php-cli:7.4     . --push
