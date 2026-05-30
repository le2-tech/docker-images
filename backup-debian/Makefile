
.PHONY: 
.DEFAULT_GOAL := build

tag := backup-debian

CHECK_CMD := ossutil version ; psql -V ; mc --version ; busybox --list | grep -x crond ;

include ../Makefile
