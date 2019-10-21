!/bin/bash

csplit -b %02d.pem -z certificates/rds-combined-ca-bundle-from-aws.pem -f rds-unbundled-ca-from-aws /-----BEGIN/ {*}
counter=0

for next_file in rds-unbundled-ca-from-aws*.pem; do
  echo "Importing  ${next_file} into the trustore"

  keytool -import -alias aws-rds-ssl-root-ca-$counter -keystore cacerts -file $next_file -storepass "password"

let counter=counter+1

done