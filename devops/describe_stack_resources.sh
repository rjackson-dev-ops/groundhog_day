#!/bin/bash

# check parameters
if [ $# -ne  1 ]; then
   echo "Please enter describe_stack_resources.sh <stack_name>"
   exit 1
fi

stack_name=$1

echo "Stack Name values is $stack_name"
aws cloudformation describe-stack-resources --stack-name $stack_name
