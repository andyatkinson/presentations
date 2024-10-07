CREATE TABLE accounts (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text UNIQUE NOT NULL
);

-- single column primary key
CREATE TABLE orders_single_pk (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id INT NOT NULL,
  CONSTRAINT fk_account_id
    FOREIGN KEY (account_id)
    REFERENCES accounts(id)
);

-- Alternative with FK
CREATE TABLE orders_single_pk_fk (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id INT NOT NULL REFERENCES accounts(id)
);

-- Drop single column PK
ALTER TABLE orders_single_pk DROP CONSTRAINT orders_single_pk_pkey;

-- Add CPK to what was original a single column PK
ALTER TABLE orders_single_pk
ADD CONSTRAINT orders_single_pk_pkey2
PRIMARY KEY (id, account_id);

-- Create table with CPK from start
CREATE TABLE orders_cpk (
  id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  account_id INT NOT NULL,
  CONSTRAINT orders_pkey_cpk
    PRIMARY KEY (id, account_id)
);
