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
    echo "Stack does not exist in this profile"
    exit 0
fi


echo "Deleting stack $stack_name"
sleep 5

aws cloudformation delete-stack  \
--region $AWS_REGION --profile $AWS_PROFILE  \
--stack-name $stack_name

    # Wait for complete
aws cloudformation wait stack-delete-complete \
    --region $AWS_REGION --profile $AWS_PROFILE \
    --stack-name $stack_name 

set +x

status=`aws cloudformation describe-stacks \
    --region $AWS_REGION --profile $AWS_PROFILE  \
    --stack-name $stack_name | jq --raw-output ".Stacks[0].StackStatus"`

echo "Status is: $status"