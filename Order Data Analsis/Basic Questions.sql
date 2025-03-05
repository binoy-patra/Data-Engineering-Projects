-- 1.	Retrieve all records from the dataset.
Select * from df_orders;

-- 2.	Fetch all unique values for Ship Mode, Segment, Country, City, State, Region, and Category.
Select distinct(ship_mode) as Ship_Mode from df_orders; 
Select distinct(segment) as Segment from df_orders; 
Select distinct(city) as City from df_orders; 
Select distinct(country) as Country from df_orders; 
Select distinct(state) as State from df_orders; 
Select distinct(region) as Region from df_orders; 
Select distinct(category) as Category from df_orders; 

-- 3.	Find the total number of orders, total quantity sold, total sales, total profit, and average discount.
Select count(*) as Total_Order from df_orders;
Select sum(quantity) as Total_Quantity from df_orders;  
Select avg(discount) as Average_Discount from df_orders; 
Select sum(sale_price) as Total_Sales from df_orders; 
Select sum(profit) as Total_Profit from df_orders; 

-- 4.	Identify the earliest and latest order dates in the dataset.
Select min(order_date) as  Earliest_Order_Date from df_orders;
Select max(order_date) as Latest_Order_Dates from df_orders;

-- 5.	Retrieve all orders where the quantity ordered is more than 5.
Select * from df_orders Where quantity>5;

-- 6.	Retrieve all orders where the discount is greater than 20%.
Select * from df_orders Where discount>20;

-- 7.	Find the total number of unique products sold.
Select count(distinct(sub_category)) as Unique_Products from df_orders;

-- 8.	List all orders sorted by order date in ascending order.
Select * from df_orders Order by order_date ASC;

-- 9.	Count the number of orders placed in each region.
Select region as Region, count(*) as Total_Order from df_orders 
Group by region;

-- 10.	 List all orders where the sale price is greater than 500.
Select * from df_orders Where sale_price>500;