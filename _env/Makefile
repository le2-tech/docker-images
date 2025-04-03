CURRENT_MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

BASE_DIR := $(abspath $(CURRENT_MAKEFILE_DIR)/../)

include ${BASE_DIR}/.env
include ${BASE_DIR}/_env/${BASIC_ENV}.env

build_proxy_clean := $(subst ",,$(build_proxy))
host_proxy_clean := $(subst ",,$(host_proxy))
buildx_suffix_clean := $(subst ",,$(buildx_suffix))