#!/bin/bash

# check parameters
if [ $# -ne  1 ]; then
   echo "Please enter get_stack_outputs.sh <stack_name>"
   exit 1
fi

stack_name=$1

echo "Stack Name values is $stack_name"
aws cloudformation describe-stacks --query "Stacks[?contains(StackName, '${stack_name}')]"
