INSERT INTO suppliers (name)
VALUES ('Big River Store');
SELECT * FROM suppliers;

INSERT INTO suppliers (name)
VALUES ('Red Circle Store');
SELECT * FROM suppliers;

INSERT INTO suppliers (name)
VALUES ('Big-Mart Store');
SELECT * FROM suppliers;

INSERT INTO suppliers (name)
VALUES ('Jett.com');
SELECT * FROM suppliers;

INSERT INTO customers (name, email)
VALUES
('Andrew Atkinson', 'customer1@example.com'),
('Jane Example', 'customer2@example.com');
SELECT * FROM customers;


INSERT INTO customers(
  name,
  email
)
SELECT
  'fname' || seq || 'lname' || seq AS name,
  'user_' || seq || '@' || (
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'gmail'
      WHEN 1 THEN 'hotmail'
      WHEN 2 THEN 'yahoo'
    END
  ) || '.com' AS email
FROM GENERATE_SERIES(1, 100) seq;


-- Hard-coding for simplicity, assuming we've dropped
-- the tables every time before running, and they're getting "1" for PKs
INSERT INTO orders (supplier_id, customer_id, quantity)
VALUES (1, 1, 1), (1, 2, 1);
SELECT * FROM orders;


INSERT INTO orders (supplier_id, customer_id, quantity)
SELECT
  s.id,                                        -- Random supplier_id from suppliers table
  (10 + random() * 50)::int AS customer_id,            -- Random customer_id
  (1 + random() * 10)::int AS quantity                  -- Random quantity
FROM generate_series(1, 100000) AS g                       -- Generate 100 rows
CROSS JOIN LATERAL (SELECT id FROM suppliers ORDER BY random() LIMIT 1) AS s;


-- Insert orders
INSERT INTO orders_with_cpk (supplier_id, customer_id, quantity)
SELECT
  s.id,                                        -- Random supplier_id from suppliers table
  (10 + random() * 50)::int AS customer_id,            -- Random customer_id
  (1 + random() * 10)::int AS quantity                  -- Random quantity
FROM generate_series(1, 100000) AS g                       -- Generate 100 rows
CROSS JOIN LATERAL (SELECT id FROM suppliers ORDER BY random() LIMIT 1) AS s;
