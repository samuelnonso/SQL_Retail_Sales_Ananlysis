-- Create a database
CREATE DATABASE sql_project1;

-- Create Table 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);
-- see total numnber of data imported 
SELECT COUNT(*)
FROM retail_sales
;

-- display the first 10 rows 
SELECT *
FROM retail_sales
LIMIT 10;

-- DATA CLEANING
-- check for null values 
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;

SELECT *
FROM retail_sales
WHERE sale_date IS NULL;

-- instead of checking for null values one by one, do all columns once 
SELECT *
FROM retail_sales
WHERE 
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL
    ;
    
DELETE
FROM retail_sales
WHERE 
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL
    ;

-- DATA EXPLORATION

-- How many sales we have?
SELECT COUNT(*) AS total_sale
FROM retail_sales;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE ?
SELECT  COUNT(DISTINCT customer_id)
FROM retail_sales;

-- HOW MANY UNIQUE CATEGORIES WE HAVE ?
SELECT  COUNT(DISTINCT category)
FROM retail_sales;

-- SEE THE LIST OF CATEGORY WE HAVE 
SELECT  DISTINCT category
FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE
	category = 'Clothing'
    AND
	DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND
    quantity >= 4; 
    

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, 
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;   


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT  
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender,
	COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- TOTAL TRANSACTION DONE BY EACH GENDER 
SELECT gender,
	SUM(total_sale) as total_tansac
    from retail_sales
    group by 1;




-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- GET AVERAGE SALE FOR EACH MONTH
SELECT 
  YEAR(sale_date) AS year,
  MONTH(sale_date) AS month,
  ROUND(AVG(total_sale)) AS average_sale
FROM retail_sales
GROUP BY 
  YEAR(sale_date), MONTH(sale_date)
ORDER BY 
  year, month;

-- BEST SELLING MONTH PER YEAR
SELECT 
  year,
  month,
  total_sale
FROM (
  SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sale) AS total_sale,
    RANK() OVER (
      PARTITION BY YEAR(sale_date)
      ORDER BY SUM(total_sale) DESC
    ) AS sale_rank
  FROM retail_sales
  GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_sales
WHERE sale_rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id,
SUM(total_sale) AS total_transaction
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category, 
	COUNT(DISTINCT customer_id) AS distinct_customer
FROM retail_sales
GROUP BY 1;



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT
    CASE 
        WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM 
    retail_sales
GROUP BY 
    shift;


-- 11."Write a SQL query that shows the number of orders placed during Morning (≤12), Afternoon (13–17), and Evening (>17) shifts, grouped by customer gender."

SELECT
    CASE 
        WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    gender,
    COUNT(*) AS number_of_orders
FROM 
    retail_sales
GROUP BY 
    shift, gender;

-- END

