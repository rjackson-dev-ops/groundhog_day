#!/bin/bash

# This script pull the tags for  AWS RDS Identifiers

account=`aws sts get-caller-identity --query "Account" --output=text`
identifier=$1

resource_name=arn:aws:rds:us-east-1:$account:db:$identifier
aws rds list-tags-for-resource  --resource-name $resource_name --output=text