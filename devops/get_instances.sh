#!/bin/bash

aws ec2 describe-instances --query 'Reservations[].Instances[].[Tags[?Key==`Name`]   | [0].Value,PublicIpAddress,PrivateIpAddress,Placement.AvailabilityZone,InstanceId,InstanceType,State.Name]' --output text | sort
