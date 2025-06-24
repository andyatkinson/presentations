# PASS 2024

## Multitenancy Patterns
- Use Docker Postgres 17
- `create_db.sh` script
- DB: Creates pass user, explicit grants
- DB: Creates App-Schema
- Populates data


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

## pg_stat_statements
```sql
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

SELECT * FROM pg_stat_statements;

select pg_stat_statements_reset();
```

## Create DB
```sh
cd pass2024
sh create_db.sh
```

## Connect DB
```sh
cd pass2024
sh connect_superuser.sh
sh connect_user.sh
```
