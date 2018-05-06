 files=( client-build.crt  client-preprod.crt   server-build.crt  server-preprod.crt \
   client-build.pem  client-preprod.pem  server-build.pem  server-preprod.pem )

 for filename in "${files[@]}"
 do
   crossing put -b cert_folder -f ${filename} -k <key>
 done
