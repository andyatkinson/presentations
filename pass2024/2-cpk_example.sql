-- Expects create_tables.sql was run earlier
---
-- Change from Single column PK to CPK
-- Drop single column PK
ALTER TABLE orders DROP CONSTRAINT orders_pkey;

-- Create CPK
ALTER TABLE orders
ADD CONSTRAINT orders_cpk
PRIMARY KEY (id, supplier_id);

-- Alternative:
-- Create CPK from start
CREATE TABLE orders_with_cpk (
  id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  supplier_id BIGINT NOT NULL,
  CONSTRAINT orders_pkey_cpk
    PRIMARY KEY (id, supplier_id)
);
