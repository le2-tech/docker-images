
.PHONY: 
.DEFAULT_GOAL := build

tag := backup-debian

CHECK_CMD := set -eux; ossutil version ; psql -V ; mc --version ; supercronic -version ; pg_dump --version

include ../Makefile
