-- NOTE: connect as passdata user
-- Changes to our tenant, "suppliers"
-- Allow NULLs for new_data since it could be deleted
CREATE TABLE IF NOT EXISTS supplier_data_changes (
  id BIGSERIAL PRIMARY KEY,
  supplier_id BIGINT, -- FK when available
  table_name TEXT NOT NULL,
  operation_type TEXT NOT NULL,  -- SQL operation: 'INSERT', 'UPDATE', 'DELETE'
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  old_data JSONB,                -- stores old data in case of UPDATE/DELETE
  new_data JSONB                 -- stores new data in case of INSERT/UPDATE
);

-- TG_OP: The SQL operation
-- TG_TABLE_NAME: The table name related to the trigger
-- NEW: reference to the new row
-- OLD: reference to the old row
-- Returns nothing: "void"
--
CREATE OR REPLACE FUNCTION log_supplier_data_changes()
RETURNS TRIGGER AS $$
DECLARE
    supplier_id BIGINT;
    column_exists BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE TG_TABLE_NAME = table_name
    AND column_name = 'supplier_id'
  ) INTO column_exists;

  IF column_exists THEN
    supplier_id = OLD.supplier_id;
  ELSE
    supplier_id = NULL;
  END IF;

  IF (TG_OP = 'DELETE') THEN
    -- Log the deleted row
    INSERT INTO supplier_data_changes(supplier_id, table_name, operation_type, old_data)
    VALUES (supplier_id, TG_TABLE_NAME, 'DELETE', row_to_json(OLD)::jsonb);

  ELSIF (TG_OP = 'UPDATE') THEN
    -- Log the updated row, with both old and new data
    INSERT INTO supplier_data_changes(supplier_id, table_name, operation_type, old_data, new_data)
    VALUES (supplier_id, TG_TABLE_NAME, 'UPDATE', row_to_json(OLD)::jsonb, row_to_json(NEW)::jsonb);

  ELSIF (TG_OP = 'INSERT') THEN
    -- Log the inserted row
    INSERT INTO supplier_data_changes(supplier_id, table_name, operation_type, new_data)
    VALUES (supplier_id, TG_TABLE_NAME, 'INSERT', row_to_json(NEW)::jsonb);
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Trigger "log_changes"
-- Calls function "log_changes()" for table "suppliers"
CREATE TRIGGER log_changes_suppliers
AFTER INSERT OR UPDATE OR DELETE ON suppliers
FOR EACH ROW EXECUTE FUNCTION log_supplier_data_changes();

CREATE TRIGGER log_changes_customers
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW EXECUTE FUNCTION log_supplier_data_changes();

CREATE TRIGGER log_changes_orders
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW EXECUTE FUNCTION log_supplier_data_changes();

-- Initially empty
select * from supplier_data_changes;

-- Make some changes:
UPDATE suppliers SET name = name || '-v2' where id = 1;

UPDATE customers SET name = name || ' AdditionalSurname' where id = 1;

-- Churned customer, archive then delete their orders
UPDATE suppliers SET name = name || ' (Deleted)' where id = (select id from suppliers where name = 'Jett.com');
SELECT * FROM suppliers;

DELETE FROM suppliers WHERE name LIKE '%(Deleted)';

-- Update an order quantity
UPDATE orders SET quantity = quantity + 1 where id = (select max(id) from orders);


SELECT * from supplier_data_changes;

-- Could pluck out the supplier specific ones
-- To get an operations count per supplier
-- For example:

SELECT
    old_data,
    new_data
FROM
    supplier_data_changes
WHERE
    table_name = 'suppliers'
    AND old_data ->> 'id' = '1';


-- Use JSON_TABLE
-- Extract and present regular fields
SELECT
    id,
    old_name,
    new_name
FROM
    supplier_data_changes,
    JSON_TABLE (old_data, '$' COLUMNS (name text PATH '$.name')) AS old_name,
    JSON_TABLE (new_data, '$' COLUMNS (name text PATH '$.name')) AS new_name
WHERE
    table_name = 'suppliers'
    AND old_data ->> 'id' = '1';
