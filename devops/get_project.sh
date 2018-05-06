#!/bin/bash

agrumentNumber=$#

if [ $agrumentNumber -eq "1" ]; then
		project_name=$1
		profile="nonprod"
elif [ $agrumentNumber -eq "2" ]; then
		project_name=$1
		profile=$2
else
		echo "Usage is get_project <project_name> <optional aws profile>"
    exit
fi

echo "The project name is ${project_name}"
echo "The profile is ${profile}"
echo ""