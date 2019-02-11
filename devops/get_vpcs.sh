#!/bin/bash
set -x

aws ec2 describe-vpcs \
  --query "Vpcs[].{Default:IsDefault,State:State,VpcId:VpcId,CidrBlock:CidrBlock,Tags:Tags}"