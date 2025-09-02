#!/bin/bash

DB_SUPERUSER="postgres"
DB_POSTGRES="postgres"
DB_SUPERUSER_PWD="postgres"
DB_HOST="localhost"
DB_PORT="15432"

DB_USER="pgconf"
DB_PASSWORD="pgconf"
DB_NAME="pgconf"
DB_SCHEMA="pgconf"

connect_superuser() {
  PGPASSWORD=$DB_SUPERUSER_PWD psql \
    -U $DB_SUPERUSER \
    -h $DB_HOST \
    -p $DB_PORT \
    -d $DB_NAME
}

connect_superuser
# psql> SET search_path = pgconf, public;
