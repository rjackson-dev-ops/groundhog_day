#!/bin/bash

echo    # List matching certifciates in AWS IAM

read -p "certficate search_string: " certificate_name

certificate_name_upper=`echo $certificate_name | awk '{print toupper($0)}'`
echo "Certificate Search Strings: ${certificate_name} or  ${certificate_name_upper}"

set -x

aws iam list-server-certificates --query "ServerCertificateMetadataList[?contains(ServerCertificateName,'${certificate_name}') ||\
  contains(ServerCertificateName,'${certificate_name_upper}')]"

set +x
