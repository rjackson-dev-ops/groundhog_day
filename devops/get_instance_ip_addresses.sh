#!/bin/bash
instances=( "i-02302e08bc0ff01b2" "i-04d31f8b78f614136" "i-0ad6f093582e00fc1"  "i-0da5910bdc8d27dd8" ) 
 for instance in "${instances[@]}" 
 do 
   aws ec2 describe-instances --instance-id $instance --query 'Reservations[].Instances[].[InstanceId, PrivateIpAddress]' --output text
 done