#!/bin/bash

PS3='Please choose a Jenkins Instance: '
options=("Nonprod Jenkins" "DevOps Jenkins" "Prod Jenkins" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Nonprod Jenkins")
           jenkins_stack_search_string='non-prod-jenkins-elb'
           jenkins_url=non-prod-jenkins.org
            ;;
        "DevOps Jenkins")
            jenkins_stack_search_string='devops-jenkins-elb'
            jenkins_url=devops-jenkins.org
            ;;
        "Prod Jenkins")
            jenkins_stack_search_string='prod-jenkins-elb'
            jenkins_url=prod-jenkins.org
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
  break
done

jenkins_stack_name=$(aws cloudformation describe-stacks  \
  --query "Stacks[?contains(StackName, '${jenkins_stack_search_string}')].[StackName] " \
  --output=text)

echo "ALB Stack Name is $jenkins_stack_name"

# Get ALB from stack

alb_id=$(aws cloudformation describe-stack-resources --stack-name $jenkins_stack_name \
  --query "StackResources[?contains(ResourceType, 'AWS::ElasticLoadBalancing::LoadBalancer')].PhysicalResourceId" \
 --output=text)

echo "Verfication of URL $jenkins_url"
echo "Dig Jekins URL"
dig +short $jenkins_url

echo "The ALB URL is $alb_id"

#set -x

dns_name=$(aws elb describe-load-balancers \
  --load-balancer-names $alb_id --query LoadBalancerDescriptions[*].DNSName --output=text)

echo "DNS_NAME: $dns_name"

instance=$(aws elb describe-load-balancers \
  --load-balancer-names $alb_id --query LoadBalancerDescriptions[*].Instances[*].InstanceId --output=text)

echo "The instance_id is $instance"
echo "The instance information is:"

aws ec2 describe-instances --instance-ids $instance \
 --query "Reservations[*].Instances[*].{Instance_Name:Tags[?Key=='Name'],State:[State.Name], \
  IP_Address:NetworkInterfaces[*].PrivateIpAddress}" --output=text

echo "Health Status from ALB"
aws elb describe-instance-health --load-balancer-name $alb_id