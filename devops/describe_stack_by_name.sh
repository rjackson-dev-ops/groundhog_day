#!/bin/bash

# check parameters
if [ $# -ne  1 ]; then
   echo "Please enter describe_stack_by_name.sh <stack_name>"
   exit 1
fi

stack_name=$1

echo "Stack Name values is $stack_name"
set -x
aws cloudformation describe-stacks --query "Stacks[?contains(StackName, '${stack_name}')]"
