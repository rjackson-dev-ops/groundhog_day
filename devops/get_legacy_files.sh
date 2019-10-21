#!/bin/bash

# This script pulls legacy files decrypts them

# VDM File Encryption - ENR_ENCRYPTION_PASSWORD
# Certificate Encryption - CERTIFICATE_DECRYPTION_PASSWORD

USAGE="Usage: $0 <s3 path> <encryption_key> file1 file2 ... fileN"

if [ "$#" -lt "3" ]; then
	echo "$USAGE"
	exit 1
fi

legacy_directory=$1
shift

encryption_key=$1
shift

DECRYPT_PASSWORD=$(keystore.rb retrieve --table=$inventory_store --keyname="${encryption_key}" )
echo "DECRYPT_PASSWORD - $DECRYPT_PASSWORD"

# loop through all files passed as arguments

for legacy_file  in "$@"
do
  out_file="${legacy_file%????}"

  echo "Pulling down legacy cert - ${legacy_file}"

  aws s3 cp  s3://$legacy_directory/$legacy_file .

  openssl enc -d -aes-256-cbc -k $DECRYPT_PASSWORD -in $legacy_file -out $out_file

  rm $legacy_file
done

