#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
   echo "Please enter get_ecs_service_by_name.sh <partial service name>"
   exit 1
fi

cluster_name=`aws ecs list-clusters --query "clusterArns[?contains(@, 'VIS-INTERNAL')]" --output=text`

service_name=$1
service_name_upper=`echo $service_name | awk '{print toupper($0)}'`

echo "ECS service name query values are $service_name, $service_name_upper"

set -x
aws ecs list-services --cluster $cluster_name --query "serviceArns[?contains(@, '${service_name}') || contains(@, '${service_name_upper}')]"