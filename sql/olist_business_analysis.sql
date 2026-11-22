CREATE DATABASE ecommerce_analytics;

USE ecommerce_analytics;

SHOW DATABASES;

drop database ecommerce_analytics;

SELECT COUNT(*) 
FROM customers;

SELECT COUNT(*)
FROM orders;

SELECT COUNT(*)
FROM order_items;

SELECT COUNT(*)
FROM products;

SELECT
    COUNT(*) AS total_rows,
    COUNT(product_id) AS non_null_ids,
    COUNT(DISTINCT product_id) AS unique_products
FROM products;
SELECT COUNT(*) 
FROM olist_products_check;


SHOW WARNINGS;


SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;


USE ecommerce_analytics;

CREATE TABLE products_full_check LIKE products;

LOAD DATA LOCAL INFILE
'C:/Ecommerce-sales-Customer_analysis/data/raw/olist_products_dataset.csv'
INTO TABLE products_full_check
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'local_infile';

USE ecommerce_analytics;

LOAD DATA LOCAL INFILE
'C:/Ecommerce-sales-Customer_analysis/data/raw/olist_products_dataset.csv'
INTO TABLE products_full_check
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;

SELECT COUNT(*) AS total_products
FROM products_full_check;

SELECT
    SUM(product_name_lenght = 0) AS zero_name_length,
    SUM(product_description_lenght = 0) AS zero_description,
    SUM(product_photos_qty = 0) AS zero_photos,
    SUM(product_weight_g = 0) AS zero_weight
FROM products_full_check;

CREATE TABLE products_clean LIKE products_full_check;

LOAD DATA LOCAL INFILE
'C:/Ecommerce-sales-Customer_analysis/data/raw/olist_products_dataset.csv'
INTO TABLE products_clean
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    @category,
    @name_len,
    @desc_len,
    @photos,
    @weight,
    @length,
    @height,
    @width
)
SET
    product_category_name = NULLIF(@category, ''),
    product_name_lenght = NULLIF(@name_len, ''),
    product_description_lenght = NULLIF(@desc_len, ''),
    product_photos_qty = NULLIF(@photos, ''),
    product_weight_g = NULLIF(@weight, ''),
    product_length_cm = NULLIF(@length, ''),
    product_height_cm = NULLIF(@height, ''),
    product_width_cm = NULLIF(@width, '');
    
    SELECT COUNT(*) AS total_products
FROM products_clean;

SELECT
    COUNT(*) AS total_rows,
    SUM(product_name_lenght IS NULL) AS missing_name_length,
    SUM(product_description_lenght IS NULL) AS missing_description,
    SUM(product_photos_qty IS NULL) AS missing_photos,
    SUM(product_weight_g IS NULL) AS missing_weight
FROM products_clean;

SELECT
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_name_lenght IS NULL) AS missing_name,
    SUM(product_description_lenght IS NULL) AS missing_description,
    SUM(product_photos_qty IS NULL) AS missing_photos,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height,
    SUM(product_width_cm IS NULL) AS missing_width
FROM products_clean;

SELECT COUNT(*)
FROM order_payments;

SELECT COUNT(*)
FROM reviews;


DESCRIBE reviews_full_check;
drop table reviews;


USE ecommerce_analytics;

LOAD DATA LOCAL INFILE
'C:/Ecommerce-sales-Customer_analysis/data/raw/olist_order_reviews_dataset.csv'
INTO TABLE reviews_full_check
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_reviews
FROM reviews_full_check;

SELECT COUNT(*)
FROM sellers;

USE ecommerce_analytics;

SHOW TABLES;

SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers;

SELECT COUNT(*)
FROM reviews_full_check;

SELECT 'products' AS tbl, COUNT(*) AS total FROM products
UNION ALL
SELECT 'products_clean', COUNT(*) FROM products_clean
UNION ALL
SELECT 'products_full_check', COUNT(*) FROM products_full_check
UNION ALL
SELECT 'olist_products_check', COUNT(*) FROM olist_products_check;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products
FROM products_full_check;

SELECT
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(product_category_name IS NULL) AS missing_category
FROM products_full_check;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_reviews
FROM reviews_full_check;

SELECT
    COUNT(*) AS total_rows,
    SUM(review_id IS NULL) AS missing_review_id,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(review_score IS NULL) AS missing_score
FROM reviews_full_check;

SELECT
    review_id,
    COUNT(*) AS occurrences
FROM reviews_full_check
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

SELECT *
FROM reviews_full_check
WHERE review_id = 'c444278834184f72b1484dfe47de7f97';


SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    COUNT(*) AS occurrences
FROM reviews_full_check
GROUP BY
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
HAVING COUNT(*) > 1;

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

SELECT COUNT(*)
FROM geolocation;

LOAD DATA LOCAL INFILE 'C:/Ecommerce-sales-Customer_analysis/data/raw/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

LOAD DATA LOCAL INFILE 'C:/Ecommerce-sales-Customer_analysis/data/raw/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*)
FROM product_category_name_translation;

SELECT COUNT(*)
FROM product_category_name_translation;

use ecommerce_analytics;
SHOW DATABASES;

DESCRIBE customers;

DESCRIBE order_items;
DESCRIBE orders;

SELECT
    COUNT(*) AS total_rows,
    COUNT(MyUnknownColumn) AS unknown_1,
    COUNT(`MyUnknownColumn_[0]`) AS unknown_2,
    COUNT(`MyUnknownColumn_[1]`) AS unknown_3
FROM customers;

SELECT
    COUNT(*) AS total_rows,
    COUNT(MyUnknownColumn) AS unknown_1,
    COUNT(`MyUnknownColumn_[0]`) AS unknown_2
FROM order_items;

SELECT
    MyUnknownColumn,
    `MyUnknownColumn_[0]`,
    `MyUnknownColumn_[1]`
FROM customers
LIMIT 10;

SELECT
    MyUnknownColumn,
    `MyUnknownColumn_[0]`
FROM order_items
LIMIT 10;

CREATE TABLE customers_backup AS
SELECT * FROM customers;

CREATE TABLE order_items_backup AS
SELECT * FROM order_items;

ALTER TABLE customers
DROP COLUMN MyUnknownColumn,
DROP COLUMN `MyUnknownColumn_[0]`,
DROP COLUMN `MyUnknownColumn_[1]`;

ALTER TABLE order_items
DROP COLUMN MyUnknownColumn,
DROP COLUMN `MyUnknownColumn_[0]`;

DESCRIBE customers;
SHOW INDEX FROM customers;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_ids,
    SUM(customer_id IS NULL) AS missing_ids
FROM customers;

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE customers
MODIFY customer_id VARCHAR(50) NOT NULL;

SELECT COUNT(*) AS unmatched_orders




ALTER TABLE orders
MODIFY customer_id VARCHAR(50) NOT NULL;

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);



SELECT COUNT(*) AS unmatched_orders
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

ALTER TABLE order_items
MODIFY order_id VARCHAR(50) NOT NULL;

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_ids,
    SUM(order_id IS NULL) AS missing_ids
FROM orders;

ALTER TABLE orders
MODIFY order_id VARCHAR(50) NOT NULL;

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

SELECT COUNT(*) AS unmatched_payments
FROM order_payments op
LEFT JOIN orders o
ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

ALTER TABLE order_payments
MODIFY order_id VARCHAR(50) NOT NULL;

ALTER TABLE order_payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

SELECT COUNT(*) AS unmatched_reviews
FROM reviews_full_check r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

ALTER TABLE reviews_full_check
MODIFY order_id VARCHAR(50) NOT NULL;

ALTER TABLE reviews_full_check
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

SELECT COUNT(*) AS unmatched_products
FROM order_items oi
LEFT JOIN products_clean p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_ids,
    SUM(product_id IS NULL) AS missing_ids
FROM products_clean;

ALTER TABLE products_clean
MODIFY product_id VARCHAR(50) NOT NULL;

ALTER TABLE products_clean
ADD PRIMARY KEY (product_id);

ALTER TABLE order_items
MODIFY product_id VARCHAR(50) NOT NULL;

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id)
REFERENCES products_clean(product_id);

SHOW INDEX FROM products_clean;

SELECT COUNT(*) AS unmatched_sellers
FROM order_items oi
LEFT JOIN sellers s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_ids,
    SUM(seller_id IS NULL) AS missing_ids
FROM sellers;

ALTER TABLE sellers
MODIFY seller_id VARCHAR(50) NOT NULL;

ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);

ALTER TABLE order_items
MODIFY seller_id VARCHAR(50) NOT NULL;

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);