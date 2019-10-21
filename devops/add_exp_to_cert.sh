#!/bin/bash

echo    # Adding expiration date to certificate file names

read -p "certficate file name (e.g. svs-notifications), don't include
file extension. It's assumsed certifcate and key will be name alike
(svs-notification.crt, svs-notifications.pem): " file_name

read -p "Certificate version (default no version): " version_number

file_crt_name="${file_name}.crt"
file_pem_name="${file_name}.pem"
file_csr_name="${file_name}.csr"

echo "The certificate file root name is: $file_name"
echo "The certificate file name is: $file_crt_name"
echo "The pem file name is: $file_pem_name"
echo "The csr file name is: $file_csr_name"
echo "The version number is: $version_number"

# Get the certificate end date
end_date=`get_certificate_enddate.sh $file_crt_name`

echo "Then end date is $end_date"

if [ -n "$version_number" ]
then
echo "Its set"
  version_string="_v_${version_number}"
else
  version_string=''
fi

new_base_file="${file_name}_exp_${end_date}${version_string}"

new_crt_file_name="${new_base_file}.crt"
new_pem_file_name="${new_base_file}.pem"
new_csr_file_name="${new_base_file}.csr"

# move files

mv $file_crt_name $new_crt_file_name
mv $file_pem_name $new_pem_file_name
mv $file_csr_name $new_csr_file_name

bucket="vis-certs"

echo "Run these commands to upload files to the certs bucket: $bucket"
echo "crossing put --file $new_crt_file_name --bucket $bucket --kmskeyid \$kms_key_id"
echo "crossing put --file $new_pem_file_name --bucket $bucket --kmskeyid \$kms_key_id"
echo "crossing put --file $new_csr_file_name --bucket $bucket --kmskeyid \$kms_key_id"
