#!/bin/bash

# This script pull the tags for  AWS RDS Identifiers

account=`aws sts get-caller-identity --query "Account" --output=text`

for identifier in "$@"
do

  resource_name=arn:aws:rds:us-east-1:$account:db:$identifier
  echo "Pulling tags for RDS resource name - ${resource_name}"
  aws rds list-tags-for-resource  --resource-name $resource_name --output=text

  engine_version=`aws rds describe-db-instances --db-instance-identifier \
    $identifier --query DBInstances[*].EngineVersion --output=text`

  echo "Engine version - $engine_version"

  parameter_group_name=`aws rds describe-db-instances --db-instance-identifier \
    $identifier --query DBInstances[*].DBParameterGroups[*].DBParameterGroupName --output=text`

  echo "Parameter group - $parameter_group_name"
  echo "Parameters"
  aws rds describe-db-parameters --db-parameter-group-name $parameter_group_name \
     --query "Parameters[?ParameterValue!=null && ParameterName!='rds.extensions'].[ParameterName,ParameterValue]" --output=text | sort | less

done
