
.PHONY: 
.DEFAULT_GOAL := build

tag := libreoffice
check_docker_args := -v $(CURDIR)/sample:/sample
CHECK_CMD := libreoffice --version ; rm -f /sample/sample.pdf ; soffice --headless --nologo --nofirststartwizard --invisible --norestore --nodefault --convert-to pdf:writer_pdf_Export --outdir /sample /sample/sample.docx ; test -s /sample/sample.pdf ; ls -lh /sample/sample.pdf ;

include ../Makefile
