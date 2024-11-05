--
-- Connect as superuser
-- \! clear
-- NOTE: superusers override RLS
-- To test, connect as regular user, or use SET ROLE
--
CREATE USER bob;
CREATE USER jane;
CREATE SCHEMA my_schema;
GRANT USAGE ON SCHEMA my_schema TO bob;
GRANT USAGE ON SCHEMA my_schema TO jane;

ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO bob;

ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO jane;

SET search_path = my_schema, public;

-- postgres
SELECT CURRENT_USER;

CREATE TABLE IF NOT EXISTS my_schema.users (
  user_id serial PRIMARY KEY,
  username text UNIQUE NOT NULL
);
INSERT INTO my_schema.users (username)
VALUES ('bob'), ('jane');

CREATE TABLE my_schema.user_data (data TEXT, user_id INTEGER);

GRANT SELECT ON my_schema.users TO bob;
GRANT SELECT ON my_schema.users TO jane;

SELECT has_table_privilege('bob', 'my_schema.users', 'SELECT') AS can_read;
SELECT has_table_privilege('jane', 'my_schema.users', 'SELECT') AS can_read;


-- As the postgres user
-- Create this function in the public schema
-- Get the users 'id' value
CREATE OR REPLACE FUNCTION current_user_id() RETURNS int AS $$
DECLARE
found_user_id int;
BEGIN
  SELECT user_id INTO found_user_id FROM my_schema.users WHERE username = CURRENT_USER;
  RETURN found_user_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN NULL; -- or raise an exception, depending on your requirements
END;
$$ LANGUAGE plpgsql STABLE;

-- No user id for postgres, not in users table
select current_user_id();

-- Try again for bob and jane
SET ROLE bob;
select current_user_id();

-- Imagine Bob and Jane writing data into the table
INSERT INTO user_data (data, user_id)
VALUES ('bob data', current_user_id());

SET ROLE jane;
select current_user_id();
INSERT INTO user_data (data, user_id)
VALUES ('jane data', current_user_id());

select current_user;
SET ROLE postgres;

-- Must be owner of table
-- Enable for user_data
ALTER TABLE user_data DISABLE ROW LEVEL SECURITY;

-- As the postgres role:
-- Policy for user_data
CREATE POLICY select_user_own_data_policy ON user_data
FOR SELECT
  USING (user_id = current_user_id());

-- Make sure it's set to ON
SET row_security TO ON;

-- As postgres superuser:
-- Can still see all data
-- Also: RLS is disabled
select * from user_data;

-- Enable RLS as postgres
set role postgres;
ALTER TABLE user_data ENABLE ROW LEVEL SECURITY;

-- Now set role to Bob
-- Now we should only see Bob's data
set role bob;
select * from user_data;

set role jane;
select * from user_data;

SELECT polname, polcmd, pg_get_expr(polqual, polrelid), pg_get_expr(polwithcheck, polrelid)
FROM pg_policy
WHERE polrelid = 'user_data'::regclass;
