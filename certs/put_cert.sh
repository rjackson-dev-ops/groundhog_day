 files=( "test.crt.enc" "test.pem.enc" )
 key=I-Like-Big-Keys

 do
   openssl enc -aes-256-cbc -k $key -in ${filename} -out ${filename}.enc
   aws s3 cp ${filename}.enc cp s3://example-certs/
 done
