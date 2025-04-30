
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}ssh-debian


will:
	${host_proxy_clean} curl -s 'https://registry.hub.docker.com/v2/repositories/library/debian/tags/?page_size=100&name=bookworm&ordering=last_updated' \
	 | jq '[.results[] | select(.name | contains("bookworm-")) | {name: .name, last_updated: .last_updated}]'


check:
	@${host_proxy_clean} docker run -it --rm ${tag} sh -c " \
		ssh -V ;\
	"

## ssh-debian
buildx:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag}:latest ${buildx_suffix_clean}

