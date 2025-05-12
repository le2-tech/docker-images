
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}libreoffice

check:
	@docker run -it --rm ${tag} sh -c " \
		libreoffice --version ;\
	"

buildx:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag} ${buildx_suffix_clean} 
