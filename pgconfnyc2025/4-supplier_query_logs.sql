-- PGSS isn’t broken down by tenant_id, but we can wrap SELECT with a function and log data

-- Run through PGSS setup:
-- select * from pg_stat_statements where query LIKE 'select * from orders%';
--
-- Gist of implementation is to use a function to select: select_from_table()
-- Which acts as a hook point to collect some data (watch out for scalability)
--
CREATE TABLE supplier_query_logs (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supplier_id bigint NOT NULL, -- FK
    query_text text NOT NULL,
    rows_result int,
    exec_time interval
);


CREATE OR REPLACE FUNCTION supplier_query(query_text text)
    RETURNS SETOF RECORD
    AS $$
DECLARE
    _rows_result int;
    supplier_id bigint;
    regex_result text[];
    start_time timestamp;
    end_time timestamp;
    _exec_time interval;
BEGIN
    -- Use a regular expression to extract the supplier_id
    regex_result := regexp_matches(query_text, 'supplier_id\s*=\s*(\d+)', 'g');

    IF array_length(regex_result, 1) > 0 THEN
        -- Extract supplier_id
        supplier_id := regex_result[1]::bigint;
        RAISE NOTICE 'Extracted supplier_id: %', supplier_id;

    -- Capture the start time before executing the query
    start_time := clock_timestamp();

    RETURN QUERY EXECUTE query_text;

    end_time := clock_timestamp();

    -- Calculate the execution time
    _exec_time:= end_time - start_time;

    GET DIAGNOSTICS _rows_result = ROW_COUNT;

    INSERT INTO supplier_query_logs (supplier_id, query_text, rows_result, exec_time)
        VALUES (supplier_id, query_text, _rows_result, _exec_time);

    END IF;
END
$$
LANGUAGE plpgsql;


-- We're going to need to change our queries.
-- Here's the original SQL query:
-- For "Fulfillment"
-- No usage of functions or PL/pgSQL
--
-- Let's reset (as superuser):
-- select pgconf.pg_stat_statements_reset();
-- Let's run 'em:
SELECT
  id AS order_id,
  customer_id,
  quantity
FROM orders WHERE supplier_id = 1;

SELECT
  id AS order_id,
  customer_id,
  quantity
FROM orders WHERE supplier_id = 2;

SELECT
  id AS order_id,
  customer_id,
  quantity
FROM orders WHERE supplier_id = 3;


--
-- Let's now use the new function
-- Same query, but inside of a supplier_query() function
--
SELECT * FROM supplier_query('SELECT id AS order_id, customer_id, quantity FROM orders WHERE supplier_id = 1')
AS t(order_id bigint, customer_id bigint, quantity int);

SELECT * FROM supplier_query('SELECT id AS order_id, customer_id, quantity FROM orders WHERE supplier_id = 2')
AS t(order_id bigint, customer_id bigint, quantity int);

SELECT * FROM supplier_query('SELECT id AS order_id, customer_id, quantity FROM orders WHERE supplier_id = 3')
AS t(order_id bigint, customer_id bigint, quantity int);

select * from supplier_query_logs;
