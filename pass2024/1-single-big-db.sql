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
set search_path = 'passdata,public';

select * from passdata.suppliers;
select * from passdata.customers;
select * from passdata.orders; -- 100K
select * from passdata.orders where supplier_id = 1;
select * from passdata.orders where supplier_id = 2;
select * from passdata.orders where supplier_id = 3;


select * from public.pg_stat_statements;

-- PGSS has instance wide stats

\! clear
