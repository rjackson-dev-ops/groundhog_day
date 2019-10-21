#!/bin/bash

echo    # Deleting certifciate in AWS IAM

read -p "Listener ARN: " listener_arn
read -p "Cert ARN: " certificate_arn


echo "Listener ARN: ${listener_arn}"
echo "Certificate Arn: ${certificate_arn}"

set -x
aws elbv2 remove-listener-certificates \
  --listener-arn "${listener_arn}" \
  --certificates CertificateArn="${certificate_arn}"

set +x
