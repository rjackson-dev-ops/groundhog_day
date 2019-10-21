#!/bin/bash

echo    # Creating a new certifciate in AWS IAM

read -p "certficate file name (e.g. app-notifications), don't include
file extension. It's assumsed certifcate and key will be name alike
(app-notification.crt, app-notifications.pem): " file_name

read -p "Certificate version (default no version): " version_number

file_crt_name="${file_name}.crt"

echo "The certificate file root name is: $file_name"
echo "The certificate file name is: $file_crt_name"
echo "The version number is: $version_number"

if [ -n "$version_number" ]
then
echo "Its set"
  version_string="_v_${version_number}"
else
  version_string=''
fi

certificate_name="${file_name}${version_string}"

echo "Certificate Name: ${certificate_name}"

set -x
aws iam upload-server-certificate \
  --server-certificate-name $certificate_name  \
  --certificate-body file://$file_name.crt  \
  --private-key file://$file_name.pem

set +x
