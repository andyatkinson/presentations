-- Clean up previous runs
DROP TABLE IF EXISTS orders_with_cpk;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS suppliers;

CREATE TABLE suppliers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text UNIQUE NOT NULL
);

CREATE TABLE customers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text UNIQUE NOT NULL,
  email text UNIQUE NOT NULL
);

-- single column primary key
CREATE TABLE orders (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  supplier_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  CONSTRAINT fk_supplier_id
    FOREIGN KEY (supplier_id)
    REFERENCES suppliers(id),
  CONSTRAINT fk_customer_id
    FOREIGN KEY (customer_id)
    REFERENCES customers(id)
);

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
