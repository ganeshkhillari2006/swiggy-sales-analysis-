-- ============================================================
-- Swiggy SQL queries  (table name: swiggy_data)
-- Columns: State, City, Order_Date, Restaurant_Name, Location,
--          Category, Dish_Name, Price_INR, Rating, Rating_Count, Sales
-- Sales = Price_INR * Rating_Count
-- Each block below = one output file (used by swiggy_split.py)
-- ============================================================

-- name: sales_by_state
SELECT State,
       COUNT(*)                      AS total_rows,
       SUM(Sales)                    AS total_sales,
       ROUND(AVG(Rating), 2)         AS avg_rating,
       SUM(Rating_Count)             AS total_rating_count
FROM swiggy_data
GROUP BY State
ORDER BY total_sales DESC;

-- name: top5_cities_by_rating
SELECT City, ROUND(AVG(Rating), 2) AS avg_rating
FROM swiggy_data
WHERE Rating > 0
GROUP BY City
ORDER BY avg_rating DESC
LIMIT 5;

-- name: last5_cities_by_rating
SELECT City, ROUND(AVG(Rating), 2) AS avg_rating
FROM swiggy_data
WHERE Rating > 0
GROUP BY City
ORDER BY avg_rating ASC
LIMIT 5;

-- name: sales_by_category
SELECT Category,
       COUNT(*)      AS total_rows,
       SUM(Sales)    AS total_sales,
       ROUND(AVG(Price_INR), 2) AS avg_price
FROM swiggy_data
GROUP BY Category
ORDER BY total_sales DESC;

-- name: monthly_sales
SELECT strftime('%Y-%m', Order_Date) AS month,
       SUM(Sales)                    AS total_sales,
       COUNT(*)                      AS total_rows
FROM swiggy_data
GROUP BY month
ORDER BY month;

-- name: top10_restaurants
SELECT Restaurant_Name, City,
       SUM(Sales)            AS total_sales,
       ROUND(AVG(Rating), 2) AS avg_rating
FROM swiggy_data
GROUP BY Restaurant_Name, City
ORDER BY total_sales DESC
LIMIT 10;

-- name: top10_dishes
SELECT Dish_Name,
       SUM(Rating_Count)     AS total_orders_rated,
       SUM(Sales)            AS total_sales
FROM swiggy_data
GROUP BY Dish_Name
ORDER BY total_sales DESC
LIMIT 10;

-- Example: one state to its own file (pandas script loops over every state)
-- SELECT * FROM swiggy_data WHERE State = 'Karnataka';
