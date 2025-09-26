--
-- Connect as superuser
-- \! clear
-- NOTE: superusers override RLS
-- To test, connect as regular user, or use SET ROLE

-- We'll create a shared app schema for all suppliers
-- However, suppliers within the shared schema will only be able to
-- access their own row data
--
SET search_path = pgconf, public;

-- Create usernames that match suppliers.username
-- Connect as superuser
CREATE USER bigriverst; -- <-- "username" from suppliers
CREATE USER redcircles;

-- Shared schema
CREATE SCHEMA IF NOT EXISTS pgconf;

GRANT USAGE ON SCHEMA pgconf TO bigriverst;
GRANT USAGE ON SCHEMA pgconf TO redcircles;

ALTER DEFAULT PRIVILEGES IN SCHEMA pgconf
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO bigriverst;

ALTER DEFAULT PRIVILEGES IN SCHEMA pgconf
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO redcircles;

-- postgres
SELECT CURRENT_USER;

-- The suppliers table should exist from earlier and have records
-- CREATE TABLE IF NOT EXISTS suppliers (
--   id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--   name text UNIQUE NOT NULL,
--   supplier_id BIGINT NOT NULL GENERATED ALWAYS AS (id) STORED
-- );
-- select * from pgconf.suppliers;

-- Create supplier-specific data in a table called "supplier_data"
CREATE TABLE pgconf.supplier_data (data TEXT, supplier_id BIGINT);

-- Allow new users to select from existing suppliers table
GRANT SELECT ON pgconf.suppliers TO bigriverst;
GRANT SELECT ON pgconf.suppliers TO redcircles;

-- We want "t" here, both can read from the existing suppliers table
SELECT has_table_privilege('bigriverst', 'pgconf.suppliers', 'SELECT') AS can_read;
SELECT has_table_privilege('redcircles', 'pgconf.suppliers', 'SELECT') AS can_read;


-- As the postgres user
-- Create this function in the public schema
-- Get the suppliers supplier_id value
CREATE OR REPLACE FUNCTION current_supplier_id() RETURNS BIGINT AS $$
DECLARE
found_supplier_id BIGINT;
BEGIN
  SELECT supplier_id INTO found_supplier_id FROM pgconf.suppliers WHERE username = CURRENT_USER;
  RETURN found_supplier_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN NULL; -- or raise an exception, depending on your requirements
END;
$$ LANGUAGE plpgsql STABLE;

-- No supplier id for postgres, not in suppliers table
select current_supplier_id();

-- Try again for bigriver and redcircle
SET ROLE bigriverst;
select current_supplier_id();

SET ROLE redcircles;
select current_supplier_id();

-- bigriver and redcircle writing data into the supplier data table
set role bigriverst;
INSERT INTO supplier_data (data, supplier_id)
VALUES ('bigriver data', current_supplier_id());

SET ROLE redcircles;
INSERT INTO supplier_data (data, supplier_id)
VALUES ('redcircle data', current_supplier_id());

-- Currently all suppliers can see all supplier_data
select * from supplier_data;
select current_user;

SET ROLE postgres;

-- Must be owner of table
-- Enable for supplier_data
-- Explicit disable, then enable
ALTER TABLE supplier_data DISABLE ROW LEVEL SECURITY;

-- ===================
-- POLICY for table: supplier_data
-- SELECT rows
-- =========
-- As the postgres role:
-- Policy for supplier_data
CREATE POLICY select_supplier_own_data_policy ON supplier_data
FOR SELECT
  USING (supplier_id = current_supplier_id());

-- Make sure it's set to ON
SET row_security TO ON;

-- As postgres superuser:
-- Can still see all data
-- Also: RLS is disabled
SELECT * FROM supplier_data;

---
-- NOW WE ENABLE IT HERE
-- Enable RLS as postgres
---
set role postgres;
ALTER TABLE supplier_data ENABLE ROW LEVEL SECURITY;

-- Now set role to bigriverst
-- Now we should only see bigriver's data
set role bigriverst;
select * from supplier_data;

-- We can see it in the query execution plan
explain analyze
select * from supplier_data;

-- Sample for red circle
set role redcircles;
select * from supplier_data;

-- View the policy defined for the table
-- System view: pg_policy
SELECT polname, polcmd, pg_get_expr(polqual, polrelid), pg_get_expr(polwithcheck, polrelid)
FROM pg_policy
WHERE polrelid = 'supplier_data'::regclass;
