 files=( svs-client-buildtest.crt  svs-client-preprod.crt   svs-server-buildtest.crt  svs-server-preprod.crt \
 svs-client-buildtest.pem  svs-client-preprod..pem  svs-server-buildtest.pem  svs-server-preprod.pem \
 svs-client-icamtest.crt   svs-client-preview.crt   svs-server-icamtest.crt   svs-server-preview.crt \
 svs-client-icamtest.pem   svs-client-preview.pem   svs-server-icamtest.pem   svs-server-preview.pem \
 svs-client-nonprod.crt    svs-client-prod.crt      svs-server-nonprod.crt    svs-server-prod.crt \
 svs-client-nonprod.pem    svs-client-prod.pem      svs-server-nonprod.pem    svs-server-prod.pem )

 for filename in "${files[@]}"
 do
   crossing put -b vis-certs -f ${filename} -k <key>
 done
