drop table if exists zepto;

create table zepto(

sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPrecrnt NUMERIC(5,2),
avaliablityQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

-- data exploration

--count of rows

SELECT COUNT(*) FROM zepto; 

--sample data from table

SELECT * FROM zepto
ORDER BY sku_id DESC 
limit 5;

--null values

SELECT * FROM zepto WHERE 
category IS NULL
OR
name IS NULL
OR
mrp IS NULL
OR
discountPrecrnt IS NULL
OR
avaliablityQuantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL

--differnt product category

SELECT DISTINCT category FROM zepto
ORDER BY category;

--product in outofstock and in stock

SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock

--number of product names repeat in multiple times

SELECT name, COUNT(sku_id) as "Number Of SKU"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;

--data cleaning 

-- check for price = 0

SELECT * FROM zepto 
WHERE mrp = 0 OR discountedSellingPrice = 0

--delete zero price product

DELETE from zepto
WHERE mrp = 0

-- change the price from paise to ruppee

UPDATE zepto
SET mrp = mrp/100,
discountedSellingPrice = discountedSellingPrice/100

SELECT mrp,discountedSellingPrice from zepto

--top 10 high discount products

SELECT DISTINCT name, mrp, discountPrecrnt
from zepto
ORDER BY discountPrecrnt DESC 
LIMIT 10

--products with high mrp but out of stock

SELECT DISTINCT name, mrp, outOfStock
FROM zepto
WHERE outOfStock = true
ORDER BY mrp DESC

--estimated revenue for each category

SELECT category,
SUm(discountedSellingPrice*avaliablityQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue

--change column name

ALTER TABLE zepto
RENAME COLUMN avaliablityQuantity TO avaliableQuantity


ALTER TABLE zepto
RENAME COLUMN discountPrecrnt TO discountPercent

--products with mrp greater than 500 and discount is less than 10%

SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent < 10
ORDER BY mrp desc 

--top 5 categories with highest average discount

SELECT category, ROUND(AVG(discountPercent),2) AS discount_price
FROM zepto
GROUP BY category
ORDER BY category DESC 
LIMIT 5;

--price per 100g to find best value for money product

SELECT DISTINCT name, discountedSellingPrice, ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
Where weightInGms >= 100
ORDER BY price_per_gram

--group product categroy based on their wight

SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	 WHEN weightInGms <5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_categoty
FROM zepto