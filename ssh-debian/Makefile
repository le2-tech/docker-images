
.PHONY: 
.DEFAULT_GOAL := build
tag := ssh-debian:latest
CHECK_CMD := ssh -V ;

include ../_env/Makefile

will:
	${host_proxy_clean} curl -s 'https://registry.hub.docker.com/v2/repositories/library/debian/tags/?page_size=100&name=bookworm&ordering=last_updated' \
	 | jq '[.results[] | select(.name | contains("bookworm-")) | {name: .name, last_updated: .last_updated}]'
