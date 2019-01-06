#!/bin/bash
# To use it, simply pass the full name of the image you want to find in each region. This must be unique or else it will just pick the first AMI. For example:

# ./find_ami.sh RHEL-7.4_HVM_GA-20170808-x86_64-2-Hourly2-GP2

if [ -z "$1" ] ; then
    echo "Please pass the name of the AMI"
    exit 1
fi

IMAGE_FILTER="${1}"

declare -a REGIONS=($(aws ec2 describe-regions --output json | jq '.Regions[].RegionName' | tr "\\n" " " | tr -d "\\""))
for r in "${REGIONS[@]}" ; do
    ami=$(aws ec2 describe-images --query 'Images[*].[ImageId]' --filters "Name=name,Values=${IMAGE_FILTER}" --region ${r} --output json | jq '.[0][0]')
    printf "\\"${r}\\" = ${ami}\\n"
done