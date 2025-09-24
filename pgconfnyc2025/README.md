# PGConf NYC 2025

```sh
marp --pdf --html --author "Andrew Atkinson" --allow-local-files pgconf2025.md
```

## Multitenancy Patterns Community Postgres
Created using:
- Docker Desktop for MacOS
- Postgres 18 RC1
- `create_db.sh` script

## Run Postgres 18 on Docker
```sh
docker pull postgres:18rc1

# Map local port 15432->5432

# https://github.com/docker-library/postgres/issues/177#issuecomment-422053654
docker run -p 15432:5432 --name pg18 -e POSTGRES_PASSWORD=postgres -d postgres:18rc1 \
-c shared_preload_libraries='pg_stat_statements' \
-c pg_stat_statements.max=10000 \
-c pg_stat_statements.track=all

docker exec -it pg18 psql -U postgres
```
```sql
postgres=# select version();
                                                             version
----------------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 18rc1 (Debian 18~rc1-1.pgdg13+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 14.2.0-19) 14.2.0, 64-bit
```

## pg_stat_statements
```sh
sh connect_superuser.sh
```
```sql
CREATE EXTENSION IF NOT EXISTS pg_stat_statements SCHEMA pgconf;
SELECT * FROM pgconf.pg_stat_statements;
select pgconf.pg_stat_statements_reset();
```
```sh
sh connect_user.sh
```

## Create DB
```sh
sh create_db.sh
```

## Connect DB
```sh
sh connect_superuser.sh
sh connect_user.sh
```

## Reset DB
```sh
sh teardown.sh
```
