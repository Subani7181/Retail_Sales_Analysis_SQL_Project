-- SQL Retail Sales Analysis - P1

CREATE DATABASE p1_retail_db;

-- Create Table
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

select *
from retail_sales
limit 10;


select count(*)
from retail_sales;


-- Data Cleaning

SELECT * FROM retail_sales
WHERE transaction_id IS NULL;


SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;


SELECT * FROM retail_sales
WHERE
transaction_id IS NULL
OR
sale_date is null
or
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
;


delete from retail_sales
where
transaction_id IS NULL
OR
sale_date is null
or
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
;

-- Data Exploration
select count(total_sale) as total_sale from retail_sales;

select count(distinct customer_id) as total_sales
from retail_sales;

select distinct category
from retail_sales;


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



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where
sale_date='2022-11-05';

select count(*) from retail_sales
where
sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
  
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select Category,sum(total_sale) as net_sale, count(*) as total_orders from retail_sales
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as Average_Age from retail_sales
where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;


select category,count(*) as total_sales from retail_sales
where total_sale > 1000
group by 1;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select Category,gender,count(*) as total_trans from retail_sales
group by
category,
gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select
	year,month,avg_sale
    from (
		select 
			extract(year from sale_date) as year,
            extract(month from sale_date) as month,
            round(avg(total_sale),2) as avg_sale,
            rank() over (
				partition by extract(year from sale_date)
                order by avg(total_sale) desc
			) as rnk
            from retail_sales
            group by extract(year from sale_date),extract(month from sale_date)
		) as t1
        where rnk=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id,sum(total_sale) as total_sales
	from retail_sales
    group by 1
	order by 2 desc
    limit 5;
    
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) as uni_cus
from retail_sales
group by 1;

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
GROUP BY shift;

-- End of the project