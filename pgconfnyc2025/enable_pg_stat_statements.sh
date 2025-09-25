docker exec -it pg17 psql -U postgres

docker run -it --rm -v postgres:17 \
  -c shared_preload_libraries='pg_stat_statements' \
  -c pg_stat_statements.max=10000 \
  -c pg_stat_statements.track=all

create extension if not exists pg_stat_statements;
