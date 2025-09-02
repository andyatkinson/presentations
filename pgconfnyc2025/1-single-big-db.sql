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
SET search_path = pgconf, public;

\l

\dn

\dt


-- NOTE: Switch to the superuser
set search_path = pgconf, public;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
select pg_stat_statements_reset();
select * from pg_stat_statements;

-- ISSUE #1: PGSS has instance wide stats
-- ISSUE #2: Removes critical supplier_id info
select * from pgconf.suppliers;
select * from pgconf.customers;
select * from pgconf.orders where supplier_id = 1;
select * from pgconf.orders where supplier_id = 2;
select * from pgconf.orders where supplier_id = 3;

\! clear
