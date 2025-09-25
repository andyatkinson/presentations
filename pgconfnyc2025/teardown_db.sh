#!/bin/bash

DB_SUPERUSER="postgres"
DB_SUPERUSER_PWD="postgres"
DB_HOST="localhost"
DB_PORT="15432"
DB_NAME="pgconf"

run_psql_superuser() {
  local sql_query=$1
  echo "Running as superuser=$DB_SUPERUSER SQL=$sql_query" >&2

  PGPASSWORD=$DB_SUPERUSER_PWD psql \
    -U $DB_SUPERUSER \
    -h $DB_HOST \
    -p $DB_PORT \
    -c "$sql_query"
}

# Run as Superuser
# CREATE DATABASE WITH OWNER $DB_USER IF NOT EXISTS
drop_db_ddl=$(cat <<EOF
DROP DATABASE IF EXISTS $DB_NAME
EOF
)
run_psql_superuser "$drop_db_ddl"
echo "Dropped database"
