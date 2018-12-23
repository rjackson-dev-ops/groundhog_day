#!/bin/bash

db_identifier=$1
set -x
aws rds describe-db-snapshots --include-shared --include-public  \
  --query "DBSnapshots[?contains(DBInstanceIdentifier, '$db_identifier')].DBSnapshotIdentifier" \
  --output=text