
.PHONY: 
.DEFAULT_GOAL := clean clone build

include ../.env

clone:
	${host_proxy} git clone https://github.com/docker-library/mysql.git source -b master --depth 1

clean:
	rm -fr source

build:
	# cd source/8.0 \
	# 	&& docker build . -t mysql:8.0-oracle -f Dockerfile.oracle --pull
	# cd source/8.0 \
	# 	&& docker build . -t mysql:8.0-debian -f Dockerfile.debian --pull --progress=plain

