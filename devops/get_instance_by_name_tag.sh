#!/bin/bash

instance_name=$1

set -x
aws ec2 describe-instances  \
--query "Reservations[*].Instances[?Tags[?Key=='Name' &&  contains(Value, '${instance_name}')][]][].\
{Instance_Name:Tags[?Key=='Name'],State:[State.Name],InstanceId:InstanceId,IP_Address:NetworkInterfaces[*].PrivateIpAddress}"