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
-- sh connect_superuser.sh
SET search_path = pgconf, public;

\l -- list databases
\dn -- list schemata/namespaces
\dt -- list tables

-- We're going with integer primary keys to start, generated from sequences

-- Our tenants
select * from suppliers;
-- Their orders
select * from orders where supplier_id = 1;
select count(*) from orders where supplier_id = 1;
-- Their top customers
select
  customers.*,
  orders.supplier_id,
  count(orders.id) as total_orders,
  sum(orders.quantity) as total_quantity
from customers
join orders ON customers.id = orders.customer_id
where orders.supplier_id = 3 -- "Big-Mart" customer, generated data has orders
group by customers.id, orders.supplier_id
order by count(orders.id) desc;

-- All customer data is in the same DB, we rely on app-level
-- authentication and authorization to see data

-- Indexing: We can index the supplier_id column and other content
-- columns, depending on our queries (not the focus of this presentation)
create index idx_orders_supplier_id ON orders (supplier_id);


-- A non-superuser can query all supplier data,
-- we're relying on application level authentication and authorization

-- We don't have tenant-based write and read traffic information
-- We don't have tenant-based query performance information to help us manage our instance sizing

\! clear
