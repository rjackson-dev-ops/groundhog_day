#!/bin/bash

# I could not quite get this script to work with pagination
# so I just redid it in ruby use this one delete_rds_snapshots.rb

IFS=$'\t'
set -x

rds_snapshots=$(aws rds describe-db-snapshots --include-shared --include-public  \
  --query "DBSnapshots[?contains(DBInstanceIdentifier, 'svs-ev-api-permanent-rds')].DBSnapshotIdentifier" \
  --output=text
)

echo "RDS snapshots "

for snapshot in ${rds_snapshots[@]}
do
  echo "Next snapshot $snapshot"
  #aws rds delete-db-snapshot --db-snapshot-identifier $snapshot
  sleep 5
done
