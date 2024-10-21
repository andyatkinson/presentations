# Presentations

## Multitenancy Patterns

- Tested on Postgres 17
- Creates pass user
- DB
- Schema within DB
- Creates some schema items
- Populates some data


## Run Postgres 17 on Docker
```sh
docker pull postgres:17

# Map local port 15432->5432

# https://github.com/docker-library/postgres/issues/177#issuecomment-422053654
docker run -p 15432:5432 --name pg17 -e POSTGRES_PASSWORD=postgres -d postgres:17 \
-c shared_preload_libraries='pg_stat_statements' \
-c pg_stat_statements.max=10000 \
-c pg_stat_statements.track=all

docker exec -it pg17 psql -U postgres
```

## Create DB
```sh
sh create_db.sh
```

## pg_stat_statements

```sql
create extension if not exists pg_stat_statements;

select * from pg_stat_statements;
```
