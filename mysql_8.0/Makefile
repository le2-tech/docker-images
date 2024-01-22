
.PHONY: 
.DEFAULT_GOAL := _

include ../.env

_: clean clone build

clone:
	${host_proxy} git clone https://github.com/docker-library/mysql.git source -b master

clean:
	rm -fr source

build:
	cd source/8.0 \
		&& docker build . -t mysql-8.0:local -f Dockerfile.oracle --pull

