#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
   echo "Please enter get_ecs_service_by_name.sh <partial service name>"
   exit 1
fi

cluster_name=`aws ecs list-clusters --query "clusterArns[?contains(@, 'VIS-INTERNAL')]" --output=text`

service_name=$1

set -x
aws ecs describe-services --cluster $cluster_name --services $service_name \
  --query "services[*].{Status:status,Pending_Count:pendingCount,Desired_Count:desiredCount,Running_Count:runningCount}"

#--query "serviceArns[?contains(@, '${service_name}') || contains(@, '${service_name_upper}')]"