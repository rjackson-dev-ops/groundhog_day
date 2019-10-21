#!/bin/bash

cert_file=$1

echo "Searching certs for ${cert_file}"

aws s3 ls s3://vis-certs | grep -i $cert_file
