#!/bin/bash

search_parameter=$1

#set -x
aws dynamodb scan \
    --table-name $key_table \
    --scan-filter "{
        \"ParameterName\":{
            \"AttributeValueList\":[ {\"S\": \"${search_parameter}\"} ],
            \"ComparisonOperator\": \"CONTAINS\"
        }
    }" --query 'Items[*].{ParameterName:ParameterName}' --output=text | sort -k 2 | \
      while read a b; do echo "${a}: ${b} "; keystore.rb retrieve --table=$key_table --keyname="$b" 2>/dev/null ;done
#set +x
