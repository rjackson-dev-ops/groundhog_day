#!/bin/bash

agrumentNumber=$#

if [ $agrumentNumber -eq "1" ]; then
		projectName=$1
		profile="lqnonprod"
elif [ $agrumentNumber -eq "2" ]; then
		projectName=$1
		profile=$2
else
		echo "Usage is get_project_swagger_urls.sh <project_name> <optional aws profile>"
    exit
fi

# Replace "-" with "_"
#projectName="${projectName//-/_}"

echo ""
echo "The project name is ${projectName}"
echo "The profile is ${profile}"
echo ""

ipAddress=`aws ec2 describe-instances --profile $profile --filters "Name=tag:Name,Values=${projectName}_batch_services"   --query 'Reservations[].Instances[].[PrivateIpAddress]' --output text `


echo call-center-services: http://${ipAddress}:9001/callcenterservices/swagger/index.html
echo property-event-listener: http://${ipAddress}:9002/propertyeventlistener/swagger/index.html

