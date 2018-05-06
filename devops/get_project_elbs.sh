#!/bin/bash

agrumentNumber=$#

if [ $agrumentNumber -eq "1" ]; then
		projectName=$1 	
		profile="lqnonprod"    
elif [ $agrumentNumber -eq "2" ]; then
		projectName=$1
		profile=$2
else
		echo "Usage is get_project_elbs.sh <project_name> <optional aws profile>"
    exit
fi

echo ""
echo "The project name is ${projectName}"
echo "The profile is ${profile}"
echo ""

# Replace "_" with "-" for Elbs
projectName="${projectName//_/-}"

for app in ext-ws ext-site 
do
   aws elbv2 describe-load-balancers   --profile $profile  --query\
     "LoadBalancers[].[LoadBalancerName,DNSName,CreatedTime,SecurityGroups[*]] " --name "${projectName}-${app}" --output text

done

for app in int-ws roomready redeem publish points pel  ecommerce distributor callcenter brightside autoupgrade aem-author
do
   aws elb describe-load-balancers --profile $profile  --query\
     "LoadBalancerDescriptions[].[LoadBalancerName,DNSName,CreatedTime,SecurityGroups[*]] " --load-balancer-names "${projectName}-${app}" --output text

done


