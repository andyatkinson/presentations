-- Add:
-- PgBouncer
-- https://www.pgbouncer.org
--
-- Set an application_name from from client app
-- Visibile in pg_stat_activity
--
-- Param Tuning

-- sh create_db.sh

-- Connect as superuser
-- sh connect_db.sh
set search_path = passdata, public;

\l

\dn

\dt



-- NOTE: Switch to the superuser
set search_path = passdata, public;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
select pg_stat_statements_reset();
select * from pg_stat_statements;

-- ISSUE #1: PGSS has instance wide stats
-- ISSUE #2: Removes critical supplier_id info
select * from passdata.suppliers;
select * from passdata.customers;
select * from passdata.orders where supplier_id = 1;
select * from passdata.orders where supplier_id = 2;
select * from passdata.orders where supplier_id = 3;

\! clear
