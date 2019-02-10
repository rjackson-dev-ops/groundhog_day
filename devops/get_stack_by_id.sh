#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
   echo "Please enter get_stack_by_id.sh <partial stack_id>"
   exit 1
fi

stack_id=$1


set -x
aws cloudformation describe-stacks  --stack-name $stack_id \
  --query "Stacks[*].[CreationTime, StackName, StackStatus] " \
  --output=text | sort
