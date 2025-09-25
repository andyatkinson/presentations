#!/bin/bash

DB_HOST="localhost"
DB_PORT="15432"
DB_USER="pgconf"
DB_PASSWORD="pgconf"
DB_NAME="pgconf"

connect_user() {
  PGPASSWORD=$DB_PASSWORD psql \
    -U $DB_USER \
    -h $DB_HOST \
    -p $DB_PORT \
    -d $DB_NAME
}

# Connect as regular user
connect_user
