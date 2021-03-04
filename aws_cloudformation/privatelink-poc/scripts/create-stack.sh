#!/bin/bash


while [ -n "$1" ]; do # while loop starts
	case "$1" in

	-p)
		AWS_PROFILE="$2"
		shift
		;;

	-r)
		AWS_REGION="$2"
		shift
		;;

	-n)
		stack_name="$2"
		shift
		;;

	-m)
		parameters="$2"
		shift
		;;

	-t)
		tags="$2"
		shift
		;;

	-b)
		body="$2"
		shift
		;;

	*) echo "Invalid Option $1"
    ;;

	esac

	shift

done

set -x

# check for existing stack
status=`aws cloudformation describe-stacks \
    --region $AWS_REGION --profile $AWS_PROFILE  \
    --stack-name $stack_name | jq --raw-output ".Stacks[0].StackStatus"`

if [[ -z "$status" ]]; then

    # Create Empty Stack first
    aws cloudformation create-stack \
        --region $AWS_REGION --profile $AWS_PROFILE  \
        --stack-name $stack_name \
        --template-body file://Cloudformation/empty_stack.yml\
        --tags $tags \
        --capabilities CAPABILITY_IAM  CAPABILITY_NAMED_IAM 

    # Wait for complete
    aws cloudformation wait stack-create-complete \
        --region $AWS_REGION --profile $AWS_PROFILE \
        --stack-name $stack_name 
fi

# check for parameters
if [[ -z "${parameters}" ]]; then
  PARAMETER_STRING=""
else
  PARAMETER_STRING="--parameters ${parameters} "
fi


# Validate template

aws cloudformation validate-template \
	--template-body $body 	

# Update stack with real values
aws cloudformation update-stack \
    --region $AWS_REGION --profile $AWS_PROFILE \
    --stack-name $stack_name \
    --template-body $body \
    ${PARAMETER_STRING} \
    --tags $tags \
    --capabilities CAPABILITY_IAM  CAPABILITY_NAMED_IAM 

# Wait for complete
aws cloudformation wait stack-update-complete \
    --region $AWS_REGION --profile $AWS_PROFILE \
    --stack-name $stack_name 

set +x

status=`aws cloudformation describe-stacks \
    --region $AWS_REGION --profile $AWS_PROFILE  \
    --stack-name $stack_name | jq --raw-output ".Stacks[0].StackStatus"`

echo "Status is: $status"