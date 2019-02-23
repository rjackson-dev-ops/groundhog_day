#!/bin/bash

ip_address=$1

for ip_address in "$@"
do
  aws ec2 describe-instances  \
  --query "Reservations[*].Instances[?PrivateIpAddress=='$ip_address'][][][].\
  {Instance_Name:Tags[?Key=='Name'].Value,State:[State.Name],InstanceId:InstanceId,IP_Address:NetworkInterfaces[*].PrivateIpAddress,LaunchTime:LaunchTime}"
done