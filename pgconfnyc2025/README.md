# PGConf NYC 2025

## Multitenancy Patterns Community Postgres
Created using:
- Docker Desktop for MacOS
- Postgres 18 Beta 3
- `create_db.sh` script

## Run Postgres 18 on Docker
```sh
docker pull postgres:18beta3

# Map local port 15432->5432

# https://github.com/docker-library/postgres/issues/177#issuecomment-422053654
docker run -p 15432:5432 --name pg18 -e POSTGRES_PASSWORD=postgres -d postgres:18beta3 \
-c shared_preload_libraries='pg_stat_statements' \
-c pg_stat_statements.max=10000 \
-c pg_stat_statements.track=all

docker exec -it pg18 psql -U postgres
```
```sql
postgres=# select version();
                                                             version
----------------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 18beta3 (Debian 18~beta3-1.pgdg130+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 14.2.0-19) 14.2.0, 64-bit
```

## pg_stat_statements
```sql
CREATE EXTENSION IF NOT EXISTS pg_stat_statements SCHEMA pgconf;
SELECT * FROM pg_stat_statements;
select pg_stat_statements_reset();
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
