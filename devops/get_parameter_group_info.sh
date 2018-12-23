#!/bin/bash

parameter_group_name=$1

echo "Parameter group - $parameter_group_name"
echo "Parameters"
aws rds describe-db-parameters --db-parameter-group-name $parameter_group_name \
    --query "Parameters[?ParameterValue!=null && ParameterName!='rds.extensions'].[ParameterName,ParameterValue]" --output=text | sort

