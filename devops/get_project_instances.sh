#!/bin/bash

agrumentNumber=$#

if [ $agrumentNumber -eq "1" ]; then
		projectName=$1 	
		profile="lqnonprod"    
elif [ $agrumentNumber -eq "2" ]; then
		projectName=$1
		profile=$2
else
		echo "Usage is get_project_instances.sh <project_name> <optional aws profile>"
    exit
fi

# Replace "-" with "_"
#projectName="${projectName//-/_}"

echo ""
echo "The project name is ${projectName}"
echo "The profile is ${profile}"
echo ""

aws ec2 describe-instances --profile $profile --filters "Name=tag:Name,Values=${projectName}**"   --query 'Reservations[].Instances[].[Tags[?Key==`Name`]   | [0].Value,PrivateIpAddress,Placement.AvailabilityZone,InstanceId,InstanceType,State.Name,LaunchTime,NetworkInterfaces[*].[NetworkInterfaceId,Groups]]' --output text | sort
