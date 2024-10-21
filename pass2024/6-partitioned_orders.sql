CREATE TABLE IF NOT EXISTS orders_part (
  supplier_id BIGINT NOT NULL, -- Skipping FK for example simplicity here
  customer_id BIGINT NOT NULL, -- Skipping FK here
  quantity INT NOT NULL
) PARTITION BY LIST (supplier_id);

CREATE TABLE orders_supplier_1 PARTITION OF orders_part
    FOR VALUES IN (1);

CREATE TABLE orders_supplier_2 PARTITION OF orders_part
    FOR VALUES IN (2);

CREATE TABLE orders_supplier_3 PARTITION OF orders_part
    FOR VALUES IN (3);

CREATE TABLE orders_default PARTITION OF orders_part
    DEFAULT;

INSERT INTO orders_part (supplier_id, customer_id, quantity)
SELECT
  s.id,                                        -- Random supplier_id from suppliers table
  (100 + random() * 50)::int AS customer_id,            -- Random customer_id
  (1 + random() * 10)::int AS quantity                  -- Random quantity
FROM generate_series(1, 100000) AS g                       -- Generate 100 rows
CROSS JOIN LATERAL (SELECT id FROM suppliers ORDER BY random() LIMIT 1) AS s;

-- Count the distribution of orders in partitions
SELECT
    count(*) AS all_partitions,
    count(*) FILTER (WHERE supplier_id = 1) AS supplier_1,
    count(*) FILTER (WHERE supplier_id = 2) AS supplier_2,
    count(*) FILTER (WHERE supplier_id = 3) AS supplier_3,
    count(*) FILTER (WHERE supplier_id NOT IN (1, 2, 3)) AS no_supplier
FROM
    orders_part;
