#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
   echo "Please enter build_delete_stack_by_name.sh <partial stack_name>"
   exit 1
fi

delete_file="temp_file"

stack_name=$1
stack_name_upper=`echo $stack_name | awk '{print toupper($0)}'`

echo "Stack Name query values are $stack_name, $stack_name_upper"

stack_ouput=`aws cloudformation describe-stacks  \
  --query "Stacks[?contains(StackName, '${stack_name}') || contains(StackName, '${stack_name_upper}')].[StackName] " \
  --output=text | sed -e s/APP-SHARED-BASTION-SECURITY-GROUP//g | sed -e s/APP-IAM-ROLE-BASTION//g`

echo $stack_ouput >>  $delete_file

delete_fixed="delete_stack.sh"

fmt -1 < $delete_file | awk '{print "delete_stack_by_name.sh " $0;}' > $delete_fixed

(echo "#!/bin/bash" && cat $delete_fixed) > temp_file && mv temp_file $delete_fixed

echo "The ${delete_fixed} file contains:"

cat $delete_fixed