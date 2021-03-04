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

# check for parameters
if [[ -z "${parameters}" ]]; then
  PARAMETER_STRING=""
else
  PARAMETER_STRING="--parameters ${parameters} "
fi

RANDOM=$$

changeset_name="changeset-${RANDOM}"
#Update stack with real values
aws cloudformation create-change-set \
    --change-set-name $changeset_name \
    --region $AWS_REGION --profile $AWS_PROFILE \
    --stack-name $stack_name \
    --template-body $body \
    ${PARAMETER_STRING} \
    --tags $tags \
    --capabilities CAPABILITY_IAM  CAPABILITY_NAMED_IAM 

# # Wait for complete
aws cloudformation wait change-set-create-complete \
    --change-set-name $changeset_name \
    --stack-name $stack_name \
    --region $AWS_REGION --profile $AWS_PROFILE 

# # Print changes
aws cloudformation describe-change-set \
    --region $AWS_REGION --profile $AWS_PROFILE \
    --stack-name $stack_name \
    --change-set-name $changeset_name  

echo -n "Apply the changset (y/n)? "
read answer


# ${answer#[Nn]} uses parameter expansion to remove
# Y or y from the beginning of $answer, causing an
# inequality when either is present

if [ "$answer" != "${answer#[Nn]}" ] ;then
    echo "Not applying changeset"
    exit 0
fi

echo "Apply changeset"

aws cloudformation execute-change-set \
    --region $AWS_REGION --profile $AWS_PROFILE \
    --stack-name $stack_name \
    --change-set-name $changeset_name 

# # Wait for complete
aws cloudformation wait stack-update-complete \
    --region $AWS_REGION --profile $AWS_PROFILE \
    --stack-name $stack_name

set +x

status=`aws cloudformation describe-stacks \
    --region $AWS_REGION --profile $AWS_PROFILE  \
    --stack-name $stack_name | jq --raw-output ".Stacks[0].StackStatus"`

echo "Status is: $status"