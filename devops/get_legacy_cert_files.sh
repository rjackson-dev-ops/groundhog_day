#!/bin/bash

DECRYPT_PASSWORD=$(keystore.rb retrieve --table=$key_table --keyname="CERTIFICATE_DECRYPTION_PASSWORD" )

# loop through all files passed as arguments

for cert_file  in "$@"
do
  out_file="${cert_file%????}"

  echo "Pulling down legacy cert - ${cert_file}"

  aws s3 cp  s3://vis-certs/$cert_file .

  openssl enc -d -aes-256-cbc -k $DECRYPT_PASSWORD -in $cert_file -out $out_file

  rm $cert_file
done

