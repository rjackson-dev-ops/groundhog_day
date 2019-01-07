#!/bin/bash
regions=`aws ec2 describe-regions --query "Regions[*].RegionName | sort(@)" --output=text`

FS=$'\t'
region_array=($regions)

for region in "${region_array[@]}"
do
  echo $region
done