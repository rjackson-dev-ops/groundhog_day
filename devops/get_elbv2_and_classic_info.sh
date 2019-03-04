#!/bin/bash
elb_name=$1

set -i
echo "Attempting elbv2 query"

aws elbv2 describe-load-balancers  --query "LoadBalancers[?contains(LoadBalancerName,'${elb_name}')]\
  ..{LoadBalancerName:LoadBalancerName,LoadBalancerArn:LoadBalancerArn,State:State.Code, CreatedTime:CreatedTime, SecurityGroups:SecurityGroups,DNSName:DNSName}"

echo "Attemptig classic elb query "
aws elb describe-load-balancers  --query "LoadBalancerDescriptions[?contains(LoadBalancerName,'${elb_name')]\
  .{VPCId:VPCId,DNSName:DNSName,CreatedTime:CreatedTime,SourceSecurityGroup:SourceSecurityGroup,Policies:Policies }