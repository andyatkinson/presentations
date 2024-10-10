INSERT INTO suppliers (name)
VALUES ('Big River Store');
SELECT * FROM suppliers;

INSERT INTO customers (name, email)
VALUES
('Andrew Atkinson', 'customer1@example.com'),
('Jane Example', 'customer2@example.com');
SELECT * FROM customers;

-- Hard-coding for simplicity, assuming we've dropped
-- the tables every time before running, and they're getting "1" for PKs
INSERT INTO orders (supplier_id, customer_id)
VALUES (1, 1), (1, 2);
SELECT * FROM orders;
