#!/bin/bash

# check parameters
if [ $# -ne  1 ]; then
   echo "Please enter get_stack_by_id.sh <stack_id>"
   exit 1
fi

stack_id=$1

echo "Stack Id values is $stack_id"
aws cloudformation describe-stacks --stack-name $stack_id 
