#!/bin/bash

cert_file=$1

echo "Here is the domain/expiration information for ${cert_file}"

openssl x509 -text < ${cert_file} | grep  -E 'DNS|CN|Not After|Not Before'
openssl x509 -noout -subject -issuer < ${cert_file}
