
.PHONY: 
.DEFAULT_GOAL := build

include ../_env/Makefile

tag := ${REGISTRY_HOST}${IMAGE_NS}poppler

check:
	@docker run -it --rm ${tag} sh -c " \
		pdftotext -v ;\
	"

buildx:
	${host_proxy_clean} docker buildx build . ${build_proxy_clean} -t ${tag} ${buildx_suffix_clean} 
