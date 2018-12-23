#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
   echo "Please enter delete_stack_by_name.sh stack_names..."
   exit 1
fi

set -x

for stack in "$@"
do

  echo "Deleting stack $stack"
  sleep 5
  aws cloudformation delete-stack  \
   --stack-name $stack

done