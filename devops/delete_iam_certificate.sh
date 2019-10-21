#!/bin/bash

echo    # Deleting certifciate in AWS IAM

read -p "certficate name: " certificate_name


echo "Certificate Name: ${certificate_name}"

set -x
aws iam delete-server-certificate \
  --server-certificate-name $certificate_name

set +x
