#!/bin/bash
instance=$1
aws ec2 describe-instances --instance-id $instance --query "Reservations[].Instances[].{Name:Tags[?Key=='Name'] \
| [0].Value,PrivateIpAddress:PrivateIpAddress,VpcId:VpcId,InstanceId:InstanceId,ImageId:ImageId,SubnetId:SubnetId,Status:State.Name}"