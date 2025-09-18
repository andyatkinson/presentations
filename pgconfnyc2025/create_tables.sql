-- Clean up previous runs
DROP TABLE IF EXISTS orders_with_cpk;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS suppliers;

CREATE TABLE suppliers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text UNIQUE NOT NULL,
  supplier_id BIGINT NOT NULL GENERATED ALWAYS AS (id) STORED
);

CREATE TABLE customers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text NOT NULL,
  email text UNIQUE NOT NULL,
  supplier_id BIGINT NOT NULL
  -- We'd want this FK to enforce referential integrity
  -- CONSTRAINT fk_supplier_id
  --   FOREIGN KEY (supplier_id)
  --   REFERENCES suppliers(id)
);

-- single column primary key
CREATE TABLE orders (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  supplier_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  quantity INTEGER NOT NULL,
  CONSTRAINT fk_supplier_id
    FOREIGN KEY (supplier_id)
    REFERENCES suppliers(id),
  CONSTRAINT fk_customer_id
    FOREIGN KEY (customer_id)
    REFERENCES customers(id)
);
