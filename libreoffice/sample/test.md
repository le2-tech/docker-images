
curl -N -X POST http://libreoffice-api:8080/execute \
	  -H 'Content-Type: application/json' \
	  -d '{"cmd":"soffice","args":["--headless","--convert-to","pdf:writer_pdf_Export","--outdir","/app/tmp/","/app/tmp/sample.docx"]}'

time soffice \
    --headless \
    --nologo \
    --nofirststartwizard \
    --invisible \
    --norestore \
    --nodefault \
    --convert-to pdf:writer_pdf_Export \
    --outdir /_/tmp/ \
    /_/tmp/sample.docx

time soffice \
    --headless \
    --convert-to pdf:writer_pdf_Export \
    --outdir ./ \
    /root/_/sample.docx

time soffice \
    --headless \
    --convert-to pdf:writer_pdf_Export \
    /root/_/sample.docx
