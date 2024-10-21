-- Changes to our tenant, "suppliers"
-- Allow NULLs for new_data since it could be deleted
CREATE TABLE data_changes (
  id BIGSERIAL PRIMARY KEY,
  table_name TEXT NOT NULL,
  operation_type TEXT NOT NULL,  -- 'INSERT', 'UPDATE', 'DELETE'
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
CREATE OR REPLACE FUNCTION log_data_changes()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    -- Log the deleted row
    INSERT INTO data_changes(table_name, operation_type, old_data)
    VALUES (TG_TABLE_NAME, 'DELETE', row_to_json(OLD)::jsonb);

  ELSIF (TG_OP = 'UPDATE') THEN
    -- Log the updated row, with both old and new data
    INSERT INTO data_changes(table_name, operation_type, old_data, new_data)
    VALUES (TG_TABLE_NAME, 'UPDATE', row_to_json(OLD)::jsonb, row_to_json(NEW)::jsonb);

  ELSIF (TG_OP = 'INSERT') THEN
    -- Log the inserted row
    INSERT INTO data_changes(table_name, operation_type, new_data)
    VALUES (TG_TABLE_NAME, 'INSERT', row_to_json(NEW)::jsonb);
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Trigger "log_changes"
-- Calls function "log_changes()" for table "suppliers"
CREATE TRIGGER log_changes_suppliers
AFTER INSERT OR UPDATE OR DELETE ON suppliers
FOR EACH ROW EXECUTE FUNCTION log_data_changes();

CREATE TRIGGER log_changes_customers
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW EXECUTE FUNCTION log_data_changes();


-- Make some changes:

UPDATE suppliers SET name = name || '-v2' where id = 1;
UPDATE suppliers SET name = name || '-v2' where id = 1;
UPDATE suppliers SET name = name || '-v2' where id = 1;
UPDATE suppliers SET name = name || '-v2' where id = 1;

UPDATE customers SET name = name || ' AdditionalSurname' where id = 1;

SELECT * from data_changes;

-- Could pluck out the supplier specific ones
-- To get an operations count per supplier
-- For example:

SELECT * from data_changes where table_name = 'suppliers' and old_data ->> 'id' = '1';
