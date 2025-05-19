
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}python-pdf-api

check:
	@docker run -it --rm ${tag} sh -c " \
		python --version ;\
	"

buildx:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag} ${buildx_suffix_clean} 
