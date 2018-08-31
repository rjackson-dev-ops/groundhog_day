#!/bin/bash

prop() {
    grep "${1}" ${PROPERTY_FILE}|cut -d'=' -f2
}

call_pgdump() {
  PGPASSWORD="$4" pg_dump -Fc  \
    -h $1 \
    -U $2 \
     $3 > $3.dump

  psql_exit_status=$?

  if [ $psql_exit_status != 0 ]; then
    fail_stamp=failure-$(date +%Y-%m-%d-%Hh-%Mm-%Ss-%Nns)
    echo "pg_dump failed while trying to dump $3 database at $fail_stamp with failure $psql_exit_status " 1>&2
    exit $psql_exit_status
   fi
}

call_pgrestore() {
  PGPASSWORD="$4" pg_restore -Fc  \
    -h $1 \
    -U $2 \
    -n public \
    -d $3 \
    $3.dump

  psql_exit_status=$?

  if [ $psql_exit_status != 0 ]; then
    fail_stamp=failure-$(date +%Y-%m-%d-%Hh-%Mm-%Ss-%Nns)
    echo "pg_restore failed while trying to restore $3 database at $fail_stamp with failure $psql_exit_status " 1>&2
    exit $psql_exit_status
   fi
}

call_psql() {
  PGPASSWORD="$5" psql \
    -X \
    -U $4 \
    -h $1 \
    --echo-all \
    --set AUTOCOMMIT=on \
    --set ON_ERROR_STOP=on \
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
if [ $# != 3 ]; then
   echo "please enter property file name, source password, dest password: psql_migrate.sh demo.properties source_passwd1 dest_passwd2"
   exit 1
fi

PROPERTY_FILE=$1

DBSOURCE_HOST=$(prop 'DBSOURCE_HOST')
DBSOURCE_USER=$(prop 'DBSOURCE_USER')
DBSOURCE_PASSWD=$2

DBDEST_HOST=$(prop 'DBDEST_HOST')
DBDEST_USER=$(prop 'DBDEST_USER')
DBDEST_PASSWD=$3

DATABASES=$(prop 'DATABASES')

echo "Databases is set to $DATABASES"

# Create "SOURCE" user in "DEST" instance

db_sql="
DROP USER dbuser;
CREATE USER $DBSOURCE_USER WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  VALID UNTIL 'infinity';

  GRANT rds_superuser TO $DBSOURCE_USER;

  ALTER USER $DBSOURCE_USER PASSWORD '$DBSOURCE_PASSWD'; "

  echo "adding Source user to Dest instance."

database='postgres'
call_psql $DBDEST_HOST $database  "$db_sql"  $DBDEST_USER $DBDEST_PASSWD

# for the remainer of the script use source user/password
DBUSER=$DBSOURCE_USER
DBPASSWD=$DBSOURCE_PASSWD

# create databases in dest instance
IFS=, read -a DATABASE_ARRAY <<< "${DATABASES%;}"

for next_database in "${DATABASE_ARRAY[@]}"
do
  echo "creating database in dest: $next_database"
  db_sql="
    DROP DATABASE $next_database;
    CREATE DATABASE $next_database;"

   call_psql $DBDEST_HOST $database  "$db_sql"  $DBUSER $DBPASSWD

done

for next_database in "${DATABASE_ARRAY[@]}"
do
  # Dump databases from source
  echo "dumping database from source: $next_database"
  call_pgdump $DBSOURCE_HOST $DBUSER $next_database $DBPASSWD
done

# restore tables to dest instance

for next_database in "${DATABASE_ARRAY[@]}"
do
  # restore databases from source
  echo "restoring database in dest: $next_database"
  call_pgrestore $DBDEST_HOST $DBUSER $next_database $DBPASSWD
done

echo "Completed database migration"