#!/bin/bash

DB_SUPERUSER="andy"
DB_POSTGRES="postgres"

DB_USER="passdata"
DB_PASSWORD="pass1234"
DB_NAME="passdata"
DB_SCHEMA="passdata"

#
# CREATE ROLE/USER/OWNER of DB IF NOT EXISTS
#
create_user_ddl=$(cat <<EOF
CREATE ROLE $DB_USER WITH
  LOGIN
  ENCRYPTED PASSWORD '$DB_PASSWORD';

ALTER ROLE $DB_USER SET search_path TO $DB_SCHEMA;
EOF
)
USER_EXISTS=$(psql -U "$DB_SUPERUSER" -d "$DB_POSTGRES" -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'")
if [ "$USER_EXISTS" == "1" ]; then
  echo "User '$DB_USER' exists."
else
  psql -U "$SUPERUSER" -c "$create_user_ddl"
  echo "User '$DB_USER' created."
fi

# CREATE DATABASE WITH OWNER $DB_USER IF NOT EXISTS
create_db_ddl=$(cat <<EOF
CREATE DATABASE $DB_NAME WITH OWNER $DB_USER;
EOF
)
if psql -U "$DB_SUPERUSER" -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
  echo "Database $DB_NAME already exists"
else
  psql -U "$DB_SUPERUSER" -c "$create_db_ddl"
  echo "Created database: $DB_NAME"
fi


#
# CREATE SCHEMA IN DB IF NOT EXISTS
#
create_schema="CREATE SCHEMA IF NOT EXISTS $DB_SCHEMA"
psql -U $DB_USER -d $DB_NAME -c "$create_schema"


#
# CREATE the tables
#
psql -U $DB_USER -d $DB_NAME -f cpk_example.sql

# Connect
psql -U $DB_USER -d $DB_NAME
