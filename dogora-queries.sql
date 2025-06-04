
			# DOGORA DATA ANALYSIS


# Create table to hold all the data across multiple years
# easy to add new data if columns match. Standardizes column names and data types
 DROP TABLE IF EXISTS sales_all;
	CREATE TABLE `sales_all` (
	`billing_country` TEXT,
    `billing_region` TEXT,
    `billing_city` TEXT,
    `product_type` TEXT,
    `product_title` TEXT,
    `product_variant_title` TEXT,
	`day` TEXT,
    `shipping_country` TEXT,
    `shipping_region` TEXT,
    `shipping_city` TEXT,
    `product_id` TEXT,
	`order_or_return` TEXT,
	`new_or_returning_customer` TEXT,
    `company_name` TEXT,
    `company_location_name` TEXT,
    `is_b2b_order` TEXT,
    `num_of_products_bought_together` INT,
    `order_id` BIGINT,
    `sale_id` BIGINT,
    `gross_sales` DOUBLE,
    `discounts` DOUBLE,
    `returns` DOUBLE,
    `net_sales` DOUBLE,
    `shipping_charges` DOUBLE,
    `taxes` DOUBLE,
    `total_sales` DOUBLE,
    `quantity_ordered` INT
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


# Append data from each year as necessary
INSERT INTO sales_all SELECT * FROM dogora.sales_2020;
INSERT INTO sales_all SELECT * FROM dogora.sales_2021;
INSERT INTO sales_all SELECT * FROM dogora.sales_2022;
INSERT INTO sales_all SELECT * FROM dogora.sales_2023;
INSERT INTO sales_all SELECT * FROM dogora.sales_2024;
INSERT INTO sales_all SELECT * FROM dogora.sales_2025;

INSERT INTO sales_all SELECT * FROM dogora.all_sales;


SELECT *
FROM sales_all;


# clean data from the 'product_title' column
SELECT DISTINCT(product_title)
FROM sales_all;

UPDATE sales_all
SET product_title = REGEXP_REPLACE(product_title, 'DOGORAâ„¢ Clinic Starter Kit', 'DOGORA Clinic Starter Kit'), 
product_title = REGEXP_REPLACE(product_title, 'High-Top Boots "\Don\'t Fall Off\"\"\"', 'High-Top Boots'),
product_title = REGEXP_REPLACE(product_title, 'High Top Boots \"Stay-On\"\" Technology\"', 'High-Top Boots'),
product_title = REGEXP_REPLACE(product_title, 'DOGORA High Top Boots', 'High-Top Boots'),
product_title = REGEXP_REPLACE(product_title, 'Vendor High-Top Boots', 'High-Top Boots'),
product_title = REGEXP_REPLACE(product_title, 'DOGORA 3 Season Heated Coat', '3 Season Heated Coat'),
product_title = REGEXP_REPLACE(product_title, 'Hoodiee', 'Hoodie'),
product_title = REGEXP_REPLACE(product_title, 'Custom Snuggie Reorder - West Orange Animal Hospital', 'Clinic Custom Order'),
product_title = REGEXP_REPLACE(product_title, 'Aldergrove Animal Hospital Custom', 'Clinic Custom Order'),
product_title = REGEXP_REPLACE(product_title, 'Seasons Veterinary Clinic', 'Clinic Custom Order'),
product_title = REGEXP_REPLACE(product_title, 'Vendors Medical Snuggie', 'Medical Snuggie'),
product_title = REGEXP_REPLACE(product_title, 'Vendor Medical Snuggie', 'Medical Snuggie'),
product_title = REGEXP_REPLACE(product_title, 'Clinic Order Medical Snuggie', 'Clinic Custom Order'),
product_title = REGEXP_REPLACE(product_title, 'Trench', 'Trench Coat'),
product_title = REGEXP_REPLACE(product_title, 'Trench Coat Coat', 'Trench Coat'),
product_title = REGEXP_REPLACE(product_title, 'Vendor Trench Coat', 'Trench Coat')
;


# Fill in 'billing_region' blanks for international purchases with the billing city name
UPDATE sales_all
SET billing_region = billing_city
WHERE billing_region = '';

# create new column with full location data
ALTER TABLE sales_all
ADD COLUMN location TEXT AFTER billing_city;

# combine billing location columns and populate the new column
UPDATE sales_all
SET location = CONCAT(billing_city,', ', billing_region, ', ', billing_country);

SELECT *
FROM sales_all;


# Create new table to hold final cleaned data
DROP TABLE IF EXISTS sales_cleaned;
	CREATE TABLE `sales_cleaned` (
	date DATE,
	order_id BIGINT,
    sale_id BIGINT,
    order_or_return TEXT,
	product_type TEXT,
    product_title TEXT,
    product_variant TEXT,
    quantity_ordered TEXT,
    billing_country TEXT,
    billing_region TEXT,
    billing_city TEXT,
    location TEXT,
    new_or_returning TEXT,
    gross_sales DOUBLE,
    discounts DOUBLE,
    returns DOUBLE,
    net_sales DOUBLE,
    shipping_charges DOUBLE,
    taxes DOUBLE,
    total_sales DOUBLE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;


# Insert data into final table, drop unneeded columns, change date to proper data 
# type, rename and sort columns
INSERT INTO sales_cleaned
SELECT CONVERT(day, DATE) AS date,
	order_id,
    sale_id,
    order_or_return,
	product_type,
    product_title,
    product_variant_title AS product_variant,
    quantity_ordered,
    billing_country,
    billing_region,
    billing_city,
    location,
    new_or_returning_customer AS new_or_returning,
    gross_sales,
    discounts,
    returns,
    net_sales,
    shipping_charges,
    taxes,
    total_sales
FROM sales_all
;


# Check final cleaned table and export
SELECT *
FROM sales_cleaned;
