#!/bin/bash

set -x
aws ec2 describe-instances --query "Reservations[].Instances[].{Name:Tags[?Key=='Name'] \
| [0].Value,PrivateIpAddress:PrivateIpAddress,VpcId:VpcId,InstanceId:InstanceId,ImageId:ImageId,SubnetId:SubnetId,Status:State.Name}"
