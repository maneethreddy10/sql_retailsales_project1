--table creation
drop table if exists retail_sales;
create table retail_sales
		( 
		transactions_id int PRIMARY KEY ,
		sale_date date,
		sale_time time,	
		customer_id	int,
		gender	varchar(50),
		age	int,
		category varchar(50),	
		quantity	int,
		price_per_unit	float,
		cogs	float,
		total_sale float
		);
select count (*) from retail_sales
select * from retail_sales
limit 10

-- data cleaning
select * from retail_sales
where transactions_id is null
	or
	sale_date is null
	and
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or 
	quantity is null
	or
	price_per_unit is null
	or 
	cogs is null
	or
	total_sale is null

delete from retail_sales
where transactions_id is null
	or
	sale_date is null
	and
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or 
	quantity is null
	or
	price_per_unit is null
	or 
	cogs is null
	or
	total_sale is null

	select count (*) from retail_sales

	
--data exploration
--How many sales do we have?
select count(*) as total_sale from retail_sales 
--how many unique customers do we have?
select count(distinct customer_id) as total_sales from retail_sales
--how many unique category we have?
select count(distinct category) as total_sales from retail_sales

--DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



--Q1Ans
SELECT total_sale FROM retail_sales where sale_date = '2022-11-05'

--Q2ans
SELECT * FROM retail_sales where category='Clothing' 
and 
quantity=> 3 
and 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

--Q3ans
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    
-- ORDER BY 1, 3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of project