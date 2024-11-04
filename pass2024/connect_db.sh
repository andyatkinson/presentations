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

connect_pass() {
  PGPASSWORD=$DB_PASSWORD psql \
    -U $DB_USER \
    -h $DB_HOST \
    -p $DB_PORT \
    -d $DB_NAME
}

connect_superuser() {
  PGPASSWORD=$DB_SUPERUSER_PWD psql \
    -U $DB_SUPERUSER \
    -h $DB_HOST \
    -p $DB_PORT \
    -d $DB_NAME
}

# Connect as regular user
# connect_pass

connect_superuser
# psql> SET search_path = passdata, public;
