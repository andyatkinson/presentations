# Presentations

## PASS Data Community Summit

`./pass2024`

### Create DB
```sh
sh create_db.sh
```

## Run Postgres 17 on Docker
```sh
docker pull postgres:17

# Map local port 15432->5432
docker run -p15432:5432 --name pg17 -e POSTGRES_PASSWORD=postgres -d postgres:17

docker exec -it pg17 psql -U postgres

psql -U postgres -h localhost -p 15432
```


## PASS DB

- Tested on Postgres 17
- Creates pass user
- DB
- Schema within DB
- Creates some schema items
- Populates some data
