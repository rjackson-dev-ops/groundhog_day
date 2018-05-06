#!/bin/bash

instanceName=$1
aws ec2 describe-instances --filters "Name=tag:Name,Values=${instanceName}**"   --query 'Reservations[].Instances[].[Tags[?Key==`Name`]   | [0].Value,PrivateIpAddress,Placement.AvailabilityZone,InstanceId,InstanceType,State.Name,LaunchTime,NetworkInterfaces[*].[NetworkInterfaceId,Groups]]'