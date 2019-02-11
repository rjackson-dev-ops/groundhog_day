#!/bin/bash

instance_id=$1

set -x
aws ec2 stop-instances --instance-ids $1
