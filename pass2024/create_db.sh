#!/bin/bash

DB_SUPERUSER="postgres"
DB_POSTGRES="postgres"
DB_SUPERUSER_PWD="postgres"
DB_HOST="localhost"
DB_PORT="15432"

DB_USER="passdata"
DB_PASSWORD="pass1234"
DB_NAME="passdata"
DB_SCHEMA="passdata"

run_psql_superuser() {
  local sql_query=$1
  echo "Running as superuser=$DB_SUPERUSER SQL=$sql_query" >&2

  PGPASSWORD=$DB_SUPERUSER_PWD psql \
    -U $DB_SUPERUSER \
    -h $DB_HOST \
    -p $DB_PORT \
    -c "$sql_query"
}

run_psql_sql() {
  local sql_query=$1
  echo "Running as user=$DB_USER SQL=$sql_query"

  PGPASSWORD=$DB_PASSWORD psql \
    -U $DB_USER \
    -h $DB_HOST \
    -p $DB_PORT \
    -c "$sql_query"
}

run_psql_file() {
  local file_path=$1
  echo "Got file: $file_path"

  PGPASSWORD=$DB_PASSWORD psql \
    -U $DB_USER \
    -h $DB_HOST \
    -p $DB_PORT \
    -f "$file_path"
}

connect_pass() {
  PGPASSWORD=$DB_PASSWORD psql \
    -U $DB_USER \
    -h $DB_HOST \
    -p $DB_PORT \
    -d $DB_NAME
}

check_db_exists() {
  if PGPASSWORD=$DB_SUPERUSER_PWD psql \
    -U $DB_SUPERUSER \
    -h $DB_HOST \
    -p $DB_PORT -lqt | cut -d \| -f 1 | grep -qw "$1"; then
    return 0
  else
    return 1
  fi
}

# Run as Superuser
# CREATE ROLE/USER/OWNER of DB IF NOT EXISTS
create_user_ddl=$(cat <<EOF
CREATE ROLE $DB_USER WITH
  LOGIN
  ENCRYPTED PASSWORD '$DB_PASSWORD';

ALTER ROLE $DB_USER SET search_path TO $DB_SCHEMA;
EOF
)
USER_EXISTS=$(run_psql_superuser "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'")
if [ "$USER_EXISTS" == "1" ]; then
  echo "User '$DB_USER' exists."
else
  run_psql_superuser "$create_user_ddl"
  echo "User '$DB_USER' created."
fi

# Run as Superuser
# CREATE DATABASE WITH OWNER $DB_USER IF NOT EXISTS
create_db_ddl=$(cat <<EOF
CREATE DATABASE $DB_NAME WITH OWNER $DB_USER;
EOF
)
if check_db_exists "$DB_NAME"; then
  echo "Database exists"
else
  run_psql_superuser "$create_db_ddl"
  echo "Created database"
fi


#
# Run as regular user
# CREATE SCHEMA IN DB IF NOT EXISTS
#
create_schema="CREATE SCHEMA IF NOT EXISTS $DB_SCHEMA"
run_psql_sql "$create_schema"

#
# Run as regular user
# CREATE the tables
#
run_psql_file "create_tables.sql"

#
# Run as regular user
# Change to use composite primary key design
#
run_psql_file "2-cpk_example.sql"

#
# Run as regular user
# Populate some data
run_psql_file "populate_data.sql"


# Connect as regular user
connect_pass
