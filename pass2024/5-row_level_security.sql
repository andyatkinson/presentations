--
-- NOTE: superusers override RLS
-- Create less priviledged users to test with
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

SET search_path = 'my_schema, public';

-- postgres
SELECT CURRENT_USER;

CREATE TABLE my_schema.users (
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
CREATE OR REPLACE FUNCTION public.current_user_id() RETURNS int AS $$
DECLARE
found_user_id int;
BEGIN
  SELECT user_id INTO found_user_id FROM my_schema.users WHERE username = CURRENT_USER;
  RETURN found_user_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN NULL; -- or raise an exception, depending on your requirements
END;
$$ LANGUAGE plpgsql STABLE;

select current_user_id();
-- None for postgres
-- try bob and jane


-- Imagine Bob and Jane writing data into the table
SET ROLE bob;
select current_user_id();
INSERT INTO user_data (data, user_id)
VALUES ('bob data', current_user_id());

SET ROLE jane;
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

-- Can still see all data though because RLS is disabled:
select * from user_data;

-- Now we can enable RLS
set role postgres;
ALTER TABLE user_data ENABLE ROW LEVEL SECURITY;

-- Now we should only see Bob's data as bob
set role bob;
select * from user_data;

set role jane;
select * from user_data;

SELECT polname, polcmd, pg_get_expr(polqual, polrelid), pg_get_expr(polwithcheck, polrelid)
FROM pg_policy
WHERE polrelid = 'user_data'::regclass;
