#!/bin/bash

call_psql()
{
  psql \
    -X \
    -U MyName \
    -h $1 \
    --echo-all \
    --set AUTOCOMMIT=on \
    --set ON_ERROR_STOP=off \
    $2 <<EOF
$3
EOF

  psql_exit_status=$?

  if [ $psql_exit_status != 0 ]; then
    fail_stamp=failure-$(date +%Y-%m-%d-%Hh-%Mm-%Ss-%Nns)
    echo "psql failed while trying to run this sql script at $fail_stamp with failure $psql_exit_status " 1>&2
    #exit $psql_exit_status
   fi
}
set -e
set -u
if [ $# != 1 ]; then
   echo "please enter a db host"
   exit 1
fi

export DBHOST=$1

db_sql="CREATE DATABASE my_database"
database='postgres'

call_psql $DBHOST $database  "$db_sql" 

echo "Created database my_database"

database='my_database'
db_sql="CREATE TABLE
    my_database.public.my_table
    (
        id serial NOT NULL,
        name VARCHAR NOT NULL,
        PRIMARY KEY (id)
    );"

call_psql $DBHOST $database  "$db_sql" 

echo "Created my_table"

while :
do
  name=myname-$(date +%Y-%m-%d-%Hh-%Mm-%Ss-%Nns)

  db_sql="insert into my_table (name) values ('$name');"

  echo "inserting $name into my_table"
  call_psql $DBHOST $database  "$db_sql" 
  sleep 1
done

exit 0
