# PGConf NYC 2025

```sh
marp --pdf --html --author "Andrew Atkinson" --allow-local-files pgconf2025.md
```

## Multitenancy Patterns Community Postgres
Created using:
- Docker Desktop for MacOS
- Postgres 18
- `create_db.sh` script

## Run Postgres 18 on Docker
```sh
docker pull postgres:18

# Map local port 15432->5432

# https://github.com/docker-library/postgres/issues/177#issuecomment-422053654
docker run -p 15432:5432 --name pg18 -e POSTGRES_PASSWORD=postgres -d postgres:18 \
-c shared_preload_libraries='pg_stat_statements' \
-c pg_stat_statements.max=10000 \
-c pg_stat_statements.track=all

docker exec -it pg18 psql -U postgres
```
```sql
postgres=# select version();
                                                             version
----------------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 18.0 (Debian 18.0-1.pgdg13+3) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 14.2.0-19) 14.2.0, 64-bit
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
