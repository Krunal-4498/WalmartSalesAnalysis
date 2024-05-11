CREATE DATABASE WalmartSales;
 
CREATE TABLE IF NOT EXISTS Sales(
invoice varchar(30) NOT NULL primary key,
branch  varchar(5) NOT NULL,
city  varchar(30) NOT NULL,
customer_type varchar(30) NOT NULL,
gender varchar(10) NOT NULL,
product_line varchar(100) NOT NULL,
unit_price decimal(10,2) NOT NULL,
quantity int NOT NULL,
VAT float(6,4) NOT NULL,
total decimal(12,4) NOT NULL,
_date datetime NOT NULL,
_Time Time NOT NULL,
payment_method varchar(15) NOT NULL,
cogs decimal(10,2) NOT NULL,
gross_margin_pct Float(11,9),
gross_income Decimal(12,4) NOT NULL,
Rating float(2,1)
);

SELECT * FROM sales;
-- -----------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------- Feature Engineering -------------------------------------------------------------
-- time_of_date

SELECT 
    _time,
    CASE
        WHEN _time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN _time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_date
FROM
    sales;
ALTER TABLE sales ADD COLUMN time_of_date varchar(20);

SET Sql_safe_updates = 0;       -- Disabled sql safe update mode

Update Sales
SET time_of_date = ( CASE
        WHEN _time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN _time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);                                                             -- updated time_of_date column with case statement values
    
    
-- day_name

Select dayname(_date) from sales;

ALter table sales 
add column day_name varchar(10);

Update sales 
Set day_name = dayname(_date);

-- month_name
Select monthname(_date) from sales;
 ALTER TABLE Sales ADD COLUMN month_name varchar(10);
 
 Update Sales 
 set month_name = monthname(_date);
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------ Exploratory Data Analysis (EDA) --------------------------------------------------------------
-- ------------------------------------------------- Generic Question ----------------------------------------------------------------------
-- How many unique cities does the data have?
Select distinct city as unique_cities from sales;

-- Which Baranch is in which city?
select distinct city,branch from sales;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- Products ----------------------------------------------------------------------
-- Q. How many unique product line does the data have?
Select Count( distinct product_line) productline_count from sales;

-- Q. what is the most common payment method?
Select payment_method,count(*) as count_of_pay_method from sales group by payment_method order by count_of_pay_method desc;

-- Q. Which is the most selling productline     
Select product_line,count(*) as product_line_count  from sales group by product_line order by product_line_count  desc;

-- Q What is the total revenue by month?
 Select month_name as Month, sum(total) as Revenue from sales group by month_name order by Revenue desc;

-- Q What month had the lasrgest cogs?
 Select month_name as Month, sum(cogs) as Total_cogs  from sales group by month_name order by  Total_cogs desc;
 
 -- Q What product line had the largest revenue ?
 Select product_line, Sum(total) as Revenue  from sales group by product_line order by Revenue desc;

-- Q What is the city with largest revenue ?
Select branch, city, Sum(total) as revenue from sales group by branch, city order by revenue desc;

-- Q What product line had the largest VAT?
 Select product_line, Avg(VAT) as   Avg_tax from sales group by  product_line order by Avg_tax desc; 
 
 -- Q Fetch each product line and add column to those product line showing "Good" or "Bad"good if its greater than average sales
 



-- Q which branch sold more products than the average product sold in all branches?
SELECT 
    branch, SUM(quantity) AS Qty_sold
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT SUM(quantity) / COUNT(DISTINCT branch) FROM sales);


-- Q Wht is the most common product line by gender ?

Select gender,product_line,count(gender) as gender_count from sales group by gender,product_line order by gender_count desc;

-- Q What is the average of each product line?
Select product_line, Round(Avg(Rating),2) as Rating from sales group by product_line order by Avg(Rating) desc;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- Sales ----------------------------------------------------------------------
-- Q1 Number of sales made in each time of the day per weekday

SELECT 
    time_of_date, day_name, COUNT(*) AS Sales_count
FROM
    sales
GROUP BY time_of_date , day_name
ORDER BY Sales_count DESC;


-- Q2 Which of the customer types brings the most revenue?

Select customer_type, Sum(total) as revenue from sales group by customer_type order by revenue desc;


-- Q3 Which city has the largest tax percent/ VAT (Value Added Tax)?

Select city, round(Avg(VAT),2) as  VAT from sales group by city order by VAT desc;

-- Q4 Which customer type pays the most in VAT?

Select customer_type, Avg(VAT) as VAT from sales group by customer_type;


-- ------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- Customers ----------------------------------------------------------------------

-- Q1 How many unique customer types does the data have?
 
SELECT 
    COUNT(DISTINCT customer_type) unique_cust_type
FROM
    sales;
 
 -- Q2 How many unique payment methods does the data have?

SELECT 
    COUNT(DISTINCT payment_method) unique_pay_method
FROM
    sales;

-- Q3 What is the most common customer type?
SELECT 
    customer_type, COUNT(*) AS cust_type_count
FROM
    sales
GROUP BY customer_type
ORDER BY cust_type_count DESC;

-- Q4 Which customer type buys the most?
SELECT 
    customer_type, SUM(quantity) AS Total_qty
FROM
    Sales
GROUP BY customer_type
ORDER BY Total_qty DESC;
 
-- Q5 What is the gender of most of the customers?
SELECT 
    gender, COUNT(*) AS Count
FROM
    sales
GROUP BY gender;
 
 
 -- Q6 What is the gender distribution per branch?
SELECT 
    branch, gender, COUNT(*) AS Count
FROM
    sales
GROUP BY branch , gender
ORDER BY branch , count DESC;
 
 -- Q7 Which time of the day do customers give most ratings?
 
SELECT 
    time_of_date, ROUND(AVG(Rating), 2) AS Rating
FROM
    sales
GROUP BY time_of_date
ORDER BY Rating DESC;
 
 -- Q8 Which time of the day do customers give most ratings per branch?
 
SELECT 
    time_of_date, branch, ROUND(AVG(Rating), 2) AS Rating
FROM
    sales
GROUP BY time_of_date , branch
ORDER BY time_of_date , Rating DESC;

-- Q 9 Which time of the day do customers give most ratings per branch?
SELECT 
    day_name, AVG(rating) AS Ratings
FROM
    sales
GROUP BY day_name
ORDER BY Ratings desc;


-- Q10 Which day of the week has the best average ratings per branch?
SELECT 
    day_name, branch, AVG(Rating) AS Ratings
FROM
    sales
GROUP BY day_name , branch
ORDER BY day_name , Ratings DESC;



 
 