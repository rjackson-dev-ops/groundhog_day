#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
   echo "Please enter create_cloud9_environment.sh <subnet>"
   exit 1
fi

subnet=$1

set -x
aws cloud9 create-environment-ec2 --name rjackson_cloud9 \
  --description "Robert Jackson - demonstration development environment." \
 --instance-type t2.micro --subnet-id $subnet --automatic-stop-time-minutes 30