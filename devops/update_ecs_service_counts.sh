#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
   echo "Please enter service_name desired count"
   exit 1
fi

cluster_name=`aws ecs list-clusters --query "clusterArns[?contains(@, 'VIS-INTERNAL')]" --output=text`

service_name=$1
desired_count=$2

echo "Ready to udpate service: $service_name desired count to: $desired_count"
echo ""

read -p "Are you sure? (y/n)" -n 1 -r

echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo " "
    # do dangerous stuff

    set -x
    aws ecs update-service --cluster $cluster_name --service $service_name \
      --desired-count  $desired_count
fi