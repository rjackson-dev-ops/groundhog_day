#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
   echo "Please enter get_stack_by_name.sh <partial stack_name>"
   exit 1
fi

declare -u stack_name_upper

stack_name=$1
stack_name_upper=$stack_name

echo "Stack Name query values are $stack_name, $stack_name_upper"

#echo "aws cloudformation describe-stacks \\" 
#echo " --query \"Stacks[?contains(StackName, '${stack_name}') || contains(StackName, '${stack_name_upper}')].[CreationTime, StackName]\"  \\"
#echo " --output=text | sort"

set -x
aws cloudformation describe-stacks  \
  --query "Stacks[?contains(StackName, '${stack_name}') || contains(StackName, '${stack_name_upper}')].[CreationTime, StackName, StackStatus] " \
  --output=text | sort
