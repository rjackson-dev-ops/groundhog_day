#!/bin/bash

db_identifier=$1


get_rds_tags.sh $db_identifier

read -p "Are you sure? We are going to terminate the database identified by ${db_identifier}
and it's snapshots, no backup, all out of mercy!! (y/n)" -n 1 -r

echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo " "
    # do dangerous stuff
    set -x
    aws rds delete-db-instance --db-instance-identifier $db_identifier --skip-final-snapshot
fi