
.PHONY: 
.DEFAULT_GOAL := build

tag := awscli
CHECK_CMD := aws --version ; session-manager-plugin --version ;

include ../Makefile

will:
	https_proxy=${__https_proxy} curl -s https://api.github.com/repos/aws/aws-cli/tags | jq -r '.[].name' | sort -V | tail -n1
	https_proxy=${__https_proxy} wget -qO- https://packages.debian.org/sid/mysql-client | grep 'Package: mysql-client' -A 1
