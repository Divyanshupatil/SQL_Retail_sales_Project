--Retail database Creation--

Create Database Retail_Data;

-- Create Table--

DROP TABLE IF EXISTS Retail_sales;
Create Table Retail_sales
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

SELECT * FROM Retail_sales;

SELECT COUNT(*) FROM Retail_sales;

--Data Cleaning--

SELECT * FROM Retail_sales
WHERE
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR
	 quantity IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL

	 --DELETE NULL VALUE ROWS--

	 DELETE FROM Retail_sales
	 WHERE
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR
	 quantity IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL


-- DATA EXPLORATION--

--HOW MANY SALES WE HAVE ?

SELECT COUNT(*) as total_sales FROM Retail_sales;

--HOW MANY UNIQUE CUSTOMERS WE HAVE ?

SELECT COUNT(DISTINCT customer_id) as unique_customers FROM Retail_sales;

--HOW MANY CATEGORY WE HAVE ?

SELECT CATEGORY FROM Retail_sales GROUP BY category;



--DATA ANALYSIS & BUSINESS KEY PROBLEMS


--Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM Retail_sales WHERE sale_date = '2022-11-05';


--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT * FROM retail_sales WHERE category = 'Clothing' AND EXTRACT(MONTH FROM sale_date) = 11 
AND EXTRACT(YEAR FROM sale_date) = 2022 AND quantity >=4;


--Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
SUM(total_sale) as total_sales,
COUNT(quantity) as total_orders
FROM Retail_sales
GROUP BY 1;


--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2) as avg_age FROM Retail_sales WHERE category = 'Beauty';


--Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *  FROM Retail_sales WHERE total_sale >1000;


--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,
gender,
COUNT(transactions_id) as count_transactions_id
FROM Retail_sales
GROUP BY category, gender
ORDER BY 3;


--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT year,month,avg_total_sale,rank
FROM

(SELECT 
     EXTRACT(YEAR FROM sale_date) as year,
	 EXTRACT (MONTH FROM sale_date) as month,
	 AVG(total_sale) as avg_total_sale,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) as rank
	 FROM Retail_sales
	 GROUP BY 1,2
) as t1
WHERE rank = 1


--Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id,SUM(total_sale) AS total_sales 
FROM Retail_sales GROUP BY 1 
Order by 2 DESC 
LIMIT 5


--Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT * FROM Retail_sales

SELECT 
     category,
	 COUNT(DISTINCT customer_id) AS unique_customer_id
	 FROM Retail_sales
	 GROUP BY 1


--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

SELECT * FROM Retail_sales

WITH hourly_sale AS
(
SELECT total_sale,
       CASE 
	       WHEN EXTRACT (HOUR FROM sale_time)<12 THEN 'Morning'
	       WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	       ELSE 'Evening'
	   END AS SHIFT
FROM Retail_sales
)
SELECT 
    shift,
    COUNT(total_sale) as total_orders    
FROM hourly_sale
GROUP BY shift
