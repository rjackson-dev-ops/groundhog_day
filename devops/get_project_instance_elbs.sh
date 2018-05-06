#!/bin/bash

agrumentNumber=$#

if [ $agrumentNumber -eq "1" ]; then
		instanceId=$1 	
		profile="lqnonprod"    
elif [ $agrumentNumber -eq "2" ]; then
		instanceId=$1
		profile=$2
else
		echo "Usage is get_project_instance_elbs.sh <instanceId> <optional aws profile>"
    exit
fi

echo ""
echo "The instanceId is ${instanceId}"
echo "The profile is ${profile}"
echo ""

aws elb describe-load-balancers --profile $profile --query \
"LoadBalancerDescriptions[?Instances[?InstanceId=='${instanceId}']].[LoadBalancerName,DNSName] "
