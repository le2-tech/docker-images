
.PHONY: 
.DEFAULT_GOAL := build

tag := awscli2
CHECK_CMD := aws --version ; session-manager-plugin ; mysql --version ;

include ../_env/Makefile

will:
	${host_proxy_clean} curl -s https://api.github.com/repos/aws/aws-cli/tags | jq -r '.[].name' | sort -V | tail -n1
	${host_proxy_clean} wget -qO- https://packages.debian.org/sid/mysql-client | grep 'Package: mysql-client' -A 1
