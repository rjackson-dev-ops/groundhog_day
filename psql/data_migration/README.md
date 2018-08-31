The psql_migrate script copies databases from a source PostgreSQL instance to Destination Instance.

psql_migrate.sh - script to copy data
demo.properties - property file

You'll want to make sure one or both databases have backups or snapshots in case things don't go as planned.

The current script also copies the source user to the dest instance. You'll need to setup a properties file and 
call the script as follows:

_psql_migrate.sh demo.properties source_passwd1 dest_passwd2_