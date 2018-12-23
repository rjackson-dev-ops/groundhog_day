#!/bin/bash

rds_instance_identifier=$1
snapshot_date=`date +%Y-%m-%d-%H%M%S`
snapshot_identifier="${rds_instance_identifier}-snapshot-${snapshot_date}"

echo "RDS Instance Identifier - $rds_instance_identifier"
echo "Snapshot Instance Identifier - $snapshot_identifier"

set -x
aws rds create-db-snapshot \
--db-instance-identifier $rds_instance_identifier \
--db-snapshot-identifier $snapshot_identifier

