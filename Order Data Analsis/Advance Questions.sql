-- 1. Identify loss-making orders where profit is negative and analyze which categories have the most losses.  
Select * from df_orders
Where profit<0;

Select category,sum(profit) as Profit from df_orders
Where profit<0
Group by category Order by Profit DESC Limit 1;

-- 2. Determine the profit margin (profit/sale_price) for each product and rank them.  
SELECT 
    category, 
    ROUND((SUM(profit) / SUM(sale_price) * 100)::numeric, 2) AS profit_margin_percentage,
    RANK() OVER (ORDER BY SUM(profit) / SUM(sale_price) DESC) AS rank
FROM df_orders
GROUP BY category;

-- 3. Find the highest-selling product in each category.
SELECT category, product_id, SUM(quantity) AS total_quantity
FROM df_orders
GROUP BY category, product_id
HAVING SUM(quantity) = (
    SELECT MAX(total_quantity) 
    FROM (SELECT category, product_id, SUM(quantity) AS total_quantity
          FROM df_orders 
          GROUP BY category, product_id) subquery
    WHERE subquery.category = df_orders.category
);

-- 4. Analyze which region has the highest discount rates and its impact on profit. 
SELECT region, 
       ROUND(AVG(discount)::numeric, 2) AS avg_discount, 
       ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM df_orders
GROUP BY region
ORDER BY avg_discount DESC;

-- 5. find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
WITH cte AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS order_year,
        EXTRACT(MONTH FROM order_date) AS order_month,
        SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
)
SELECT 
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte 
GROUP BY order_month
ORDER BY order_month;


-- 6. Find yearly sales growth by comparing total sales year-over-year.  
SELECT 
    EXTRACT(YEAR FROM order_date) AS year, 
    SUM(sale_price) AS total_sales, 
    LAG(SUM(sale_price)) OVER (ORDER BY EXTRACT(YEAR FROM order_date)) AS previous_year_sales,
    ROUND(((SUM(sale_price) - LAG(SUM(sale_price)) OVER (ORDER BY EXTRACT(YEAR FROM order_date))) / 
          NULLIF(LAG(SUM(sale_price)) OVER (ORDER BY EXTRACT(YEAR FROM order_date)), 0) * 100)::NUMERIC, 2) 
          AS sales_growth_percentage
FROM df_orders
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;


-- 7. find top 5 highest selling products in each region
with cte as (
select region,product_id,sum(sale_price) as sales
from df_orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=5

-- 8. Find the average number of orders placed per customer per month (if customer data is available).  
-- 9. Identify the most profitable shipping mode based on total profit.  
SELECT ship_mode, 
       SUM(profit) AS total_profit
FROM df_orders
GROUP BY ship_mode
ORDER BY total_profit DESC
LIMIT 1;

-- 10. Determine the sales contribution of each category as a percentage of total sales.
SELECT category, 
       ROUND((SUM(sale_price) / (SELECT SUM(sale_price) FROM df_orders) * 100)::numeric, 2) AS sales_contribution_percentage
FROM df_orders
GROUP BY category
ORDER BY sales_contribution_percentage DESC;

-- 11.for each category which month had highest sales 
WITH cte AS (
    SELECT 
        category,
        TO_CHAR(order_date, 'YYYYMM') AS order_year_month, -- Fixed date formatting
        SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY category, TO_CHAR(order_date, 'YYYYMM') -- Fixed GROUP BY
)
SELECT * FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) AS rn
    FROM cte
) a
WHERE rn = 1;
