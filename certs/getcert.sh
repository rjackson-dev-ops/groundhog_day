 files=( "test.crt" "test.pem" )

 key=I-Like-Big-Keys

 for filename in "${files[@]}"
 do
   aws s3 cp s3://example-certs/${filename}.enc .
   openssl enc -d -aes-256-cbc -k $key -in ${filename}.enc -out ${filename}
 done


