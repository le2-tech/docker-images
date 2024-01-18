
.PHONY: 
.DEFAULT_GOAL := build

include ../.env

USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)
OS := $(shell uname -s)

build: ## build
ifeq ($(OS),Linux)
	docker build . -t le2/php:7.4-fpm --pull --build-arg DOCKER_ENV=${DOCKER_ENV} --build-arg USER_ID=$(USER_ID) --build-arg GROUP_ID=$(GROUP_ID)
else ifeq ($(OS),Darwin)
	docker build . -t le2/php:7.4-fpm --pull --build-arg DOCKER_ENV=${DOCKER_ENV} ${build_proxy}
else
	@echo "This is neither Linux nor Mac"
endif

buildx:
	docker buildx build --platform linux/amd64,linux/arm64 --build-arg DOCKER_ENV=${DOCKER_ENV} --build-arg USER_ID=$(USER_ID) --build-arg GROUP_ID=$(GROUP_ID) -t registry.le2.tech/le2/php:8.2-fpm . --push
