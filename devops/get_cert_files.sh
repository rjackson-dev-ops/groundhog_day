#!/bin/bash

for file in "$@"
do

  echo "Pulling down certficate - ${file}"
	crossing get -b vis-certs -f ${file}
done
