-- 1. Find the total sales and profit for each category.
Select category, sum(sale_price) as Sale_Price from df_orders
Group by category;
Select category, sum(profit) as Profit from df_orders
Group by category;

-- 2. List the top 5 most profitable products based on total profit.
Select sub_category, sum(profit) as Profit from df_orders
Group by sub_category
Order by Profit DESC Limit 5;

-- 3. Retrieve monthly sales trends (total sales per month).
SELECT DATE_PART('month', order_date) AS month, SUM(sale_price) AS total_sales 
FROM df_orders 
GROUP BY month
ORDER BY month;

-- 4. Find total orders placed in each region and sort them in descending order.
SELECT region AS region, count(*) AS total_order
FROM df_orders 
GROUP BY region
ORDER BY total_order Desc;

-- 5. Identify the top 3 cities with the highest total sales.
Select city, sum(sale_price) as Sales from df_orders
Group by city
Order by Sales DESC Limit 3;

-- 6. Calculate the average discount offered per category.
Select category, avg(discount) as Average_Discount from df_orders
Group by category;

-- 7. Find the percentage of orders that received a discount.
SELECT 
    (COUNT(CASE WHEN discount > 0 THEN 1 END) * 100.0) / COUNT(*) AS discount_percentage
FROM df_orders;


-- 8. Retrieve total sales and total profit for each state.
Select state, sum(sale_price) as Sale_Price from df_orders
Group by state Order by Sale_Price DESC;
Select state, sum(profit) as Profit from df_orders
Group by state Order by Profit DESC;

-- 9. Find total quantity sold per sub-category and rank them.
SELECT 
    sub_category, 
    SUM(quantity) AS total_quantity,
    RANK() OVER (ORDER BY SUM(quantity) DESC) AS rank
FROM df_orders
GROUP BY sub_category;

-- 10. Determine the average profit margin (profit/sale_price) for each category.
SELECT 
    category, 
    ROUND(AVG(profit / quantity)::numeric, 2) AS average_profit_margin
FROM df_orders
GROUP BY category;

