-- Add:
-- PgBouncer
-- https://www.pgbouncer.org
--
-- Set an application_name from from client app
-- Visibile in pg_stat_activity
--
-- Param Tuning

-- sh create_db.sh

-- Use a stored virtual column supplier_id

select * from suppliers;
select * from customers;
select * from orders; -- 100K
