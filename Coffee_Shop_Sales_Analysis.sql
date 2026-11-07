
# New Database

CREATE DATABASE Coffee_Shop_Performance;

USE Coffee_Shop_Performance;

#Create Table

CREATE TABLE coffee_sales (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    transaction_time TIME,
    product_category VARCHAR(50),
    product_type VARCHAR(100),
    product_detail VARCHAR(150),
    transaction_qty INT,
    unit_price DECIMAL(10,2),
    store_id INT
);

#Store Details

CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50)
);

# INsert Sales Data

INSERT INTO coffee_sales VALUES
(1,'2023-01-01','08:30:00','Coffee','Espresso','Regular Espresso',2,120,1),
(2,'2023-01-01','09:15:00','Coffee','Latte','Vanilla Latte',1,180,1),
(3,'2023-01-02','10:00:00','Tea','Green Tea','Hot Green Tea',2,100,2),
(4,'2023-01-02','11:30:00','Coffee','Cappuccino','Classic Cappuccino',3,150,1),
(5,'2023-01-03','14:00:00','Coffee','Mocha','Dark Chocolate Mocha',1,200,2),
(6,'2023-01-03','16:30:00','Tea','Black Tea','Hot Black Tea',2,80,1),
(7,'2023-01-04','08:45:00','Coffee','Latte','Vanilla Latte',2,180,2),
(8,'2023-01-04','18:00:00','Coffee','Espresso','Regular Espresso',1,120,1),
(9,'2023-01-05','09:00:00','Coffee','Americano','Classic Americano',3,130,2),
(10,'2023-01-05','12:30:00','Tea','Green Tea','Hot Green Tea',1,100,1),
(11,'2023-01-06','10:30:00','Coffee','Cappuccino','Classic Cappuccino',2,150,2),
(12,'2023-01-06','17:00:00','Coffee','Mocha','Dark Chocolate Mocha',2,200,1),
(13,'2023-01-07','08:00:00','Tea','Black Tea','Hot Black Tea',3,80,2),
(14,'2023-01-07','13:00:00','Coffee','Latte','Vanilla Latte',2,180,1),
(15,'2023-01-08','15:30:00','Coffee','Americano','Classic Americano',1,130,2);

INSERT INTO stores VALUES
(1,'Coffee House Pune','Pune'),
(2,'Coffee House Mumbai','Mumbai');

# View  & Check Data

SELECT * FROM coffee_sales;

SELECT * FROM stores;

SELECT COUNT(*) AS total_records
FROM coffee_sales;

# Data Cleaning

SELECT *
FROM coffee_sales
WHERE transaction_date IS NULL
   OR product_type IS NULL
   OR transaction_qty IS NULL
   OR unit_price IS NULL;
   
   SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM coffee_sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;

SELECT *
FROM coffee_sales
WHERE unit_price <= 0;

SELECT *
FROM coffee_sales
WHERE transaction_qty <= 0;

SELECT *
FROM coffee_sales
WHERE store_id NOT IN (
    SELECT store_id FROM stores
);

# Basic Queries

SELECT
    SUM(transaction_qty * unit_price) AS total_sales
FROM coffee_sales;

SELECT COUNT(DISTINCT transaction_id) AS total_orders
FROM coffee_sales;

SELECT SUM(transaction_qty) AS total_quantity
FROM coffee_sales;

SELECT ROUND(AVG(unit_price),2) AS average_price
FROM coffee_sales;

# Sales Analysis 

SELECT
    product_category,
    SUM(transaction_qty * unit_price) AS total_sales
FROM coffee_sales
GROUP BY product_category
ORDER BY total_sales DESC;

SELECT
    transaction_id,
    product_type,
    transaction_qty * unit_price AS total_amount
FROM coffee_sales
ORDER BY total_amount DESC
LIMIT 1;

SELECT
    ROUND(
        SUM(transaction_qty * unit_price) /
        COUNT(DISTINCT transaction_id), 2
    ) AS average_order_value
FROM coffee_sales;

SELECT
    product_category,
    ROUND(
        SUM(transaction_qty * unit_price) * 100 /
        (SELECT SUM(transaction_qty * unit_price)
         FROM coffee_sales), 2
    ) AS sales_percentage
FROM coffee_sales
GROUP BY product_category;

# Product Analysis

SELECT
    product_type,
    SUM(transaction_qty) AS total_quantity
FROM coffee_sales
GROUP BY product_type
ORDER BY total_quantity DESC
LIMIT 5;

SELECT
    product_type,
    SUM(transaction_qty * unit_price) AS revenue
FROM coffee_sales
GROUP BY product_type
ORDER BY revenue DESC;

SELECT
    product_type,
    MAX(unit_price) AS highest_price
FROM coffee_sales
GROUP BY product_type
ORDER BY highest_price DESC
LIMIT 1;

SELECT
    product_type,
    ROUND(AVG(unit_price),2) AS average_price
FROM coffee_sales
GROUP BY product_type;

SELECT
    transaction_date,
    SUM(transaction_qty * unit_price) AS daily_sales
FROM coffee_sales
GROUP BY transaction_date
ORDER BY transaction_date;


# Monthly & Daily Analysis

SELECT
    MONTH(transaction_date) AS month_number,
    SUM(transaction_qty * unit_price) AS monthly_sales
FROM coffee_sales
GROUP BY MONTH(transaction_date)
ORDER BY month_number;

SELECT
    DAYNAME(transaction_date) AS weekday,
    SUM(transaction_qty * unit_price) AS total_sales
FROM coffee_sales
GROUP BY DAYNAME(transaction_date)
ORDER BY total_sales DESC;

SELECT
    HOUR(transaction_time) AS sales_hour,
    SUM(transaction_qty * unit_price) AS total_sales
FROM coffee_sales
GROUP BY HOUR(transaction_time)
ORDER BY total_sales DESC;

# Store Performance 

SELECT
    s.store_name,
    s.city,
    SUM(c.transaction_qty * c.unit_price) AS total_revenue
FROM coffee_sales c
JOIN stores s
ON c.store_id = s.store_id
GROUP BY s.store_id, s.store_name, s.city
ORDER BY total_revenue DESC;

SELECT
    s.store_name,
    COUNT(c.transaction_id) AS total_orders
FROM coffee_sales c
JOIN stores s
ON c.store_id = s.store_id
GROUP BY s.store_id, s.store_name;

SELECT
    s.store_name,
    SUM(c.transaction_qty * c.unit_price) AS revenue
FROM coffee_sales c
JOIN stores s
ON c.store_id = s.store_id
GROUP BY s.store_id, s.store_name
ORDER BY revenue DESC
LIMIT 1;

# Joins & Subquries 

SELECT
    c.transaction_id,
    c.product_type,
    s.store_name,
    s.city
FROM coffee_sales c
INNER JOIN stores s
ON c.store_id = s.store_id;

SELECT
    s.store_name,
    c.transaction_id,
    c.product_type
FROM stores s
LEFT JOIN coffee_sales c
ON s.store_id = c.store_id;

SELECT
    product_type,
    unit_price
FROM coffee_sales
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM coffee_sales
);

SELECT
    product_type,
    revenue
FROM (
    SELECT
        product_type,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_sales
    GROUP BY product_type
) AS product_revenue
WHERE revenue > 500;

# Common Table Expression

WITH product_sales AS (
    SELECT
        product_type,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_sales
    GROUP BY product_type
)
SELECT *
FROM product_sales
ORDER BY revenue DESC;

WITH product_sales AS (
    SELECT
        product_type,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_sales
    GROUP BY product_type
)
SELECT *
FROM product_sales
WHERE revenue > 400;
WITH store_revenue AS (
    SELECT
        store_id,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_sales
    GROUP BY store_id
)
SELECT *
FROM store_revenue
ORDER BY revenue DESC;

# Window Function

SELECT
    transaction_id,
    product_type,
    transaction_qty,
    ROW_NUMBER() OVER (
        ORDER BY transaction_qty DESC
    ) AS row_num
FROM coffee_sales;

SELECT
    product_type,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS sales_rank
FROM (
    SELECT
        product_type,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_sales
    GROUP BY product_type
) AS sales_data;

SELECT
    product_type,
    revenue,
    DENSE_RANK() OVER (
        ORDER BY revenue DESC
    ) AS product_rank
FROM (
    SELECT
        product_type,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_sales
    GROUP BY product_type
) AS sales_data;

SELECT
    transaction_date,
    transaction_id,
    transaction_qty * unit_price AS sales,
    SUM(transaction_qty * unit_price) OVER (
        ORDER BY transaction_date, transaction_id
    ) AS running_total
FROM coffee_sales;

# Advanced Business Analysis 

SELECT
    CASE
        WHEN HOUR(transaction_time) < 12 THEN 'Morning'
        WHEN HOUR(transaction_time) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_period,
    SUM(transaction_qty * unit_price) AS total_sales
FROM coffee_sales
GROUP BY time_period
ORDER BY total_sales DESC;

SELECT
    product_category,
    SUM(transaction_qty * unit_price) AS revenue,
    SUM(transaction_qty) AS quantity_sold
FROM coffee_sales
GROUP BY product_category;

SELECT
    s.city,
    SUM(c.transaction_qty * c.unit_price) AS revenue
FROM coffee_sales c
JOIN stores s
ON c.store_id = s.store_id
GROUP BY s.city
ORDER BY revenue DESC
LIMIT 1;

WITH daily_sales AS (
    SELECT
        transaction_date,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_sales
    GROUP BY transaction_date
)
SELECT
    transaction_date,
    revenue,
    SUM(revenue) OVER (
        ORDER BY transaction_date
    ) AS cumulative_sales
FROM daily_sales;

# Final Sql Report

SELECT *
FROM Final_Coffee_Sales_Report;

SELECT
    COUNT(DISTINCT transaction_id) AS total_orders,
    SUM(transaction_qty) AS total_quantity,
    SUM(total_revenue) AS total_revenue,
    ROUND(AVG(total_revenue),2) AS average_order_value
FROM Final_Coffee_Sales_Report;