-- check SQL Version
SELECT @@version

--to prevent duplicate count, use DISTINCT

SELECT * FROM pizza_sales

----------------------------------------------------AVG amount spend per ORDER
SELECT SUM(total_price) / COUNT(DISTINCT ORDER_id) AS AVG_Order_Value FROM pizza_sales

-----------------------------------------------------total pizza sold
SELECT SUM(quantity) AS Total_Pizza_Sold FROM pizza_sales

--------------------------------------------------------Total number of ORDER
SELECT COUNT(DISTINCT ORDER_id) AS Total_ORDERs FROM pizza_sales

---------------------------------------- Format a Number------------add instead of 0 (#) decimals e.g. 2 or 3
SELECT top 5 pizza_category, format(SUM(total_price), 'N0') AS Total_Price FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Price
----------------------------------------------------------

----------------------------------------------------AVG number of  pizza sold per ORDER AS decimal. Use CASt for numerator/denominator & for ratio) count upto 10 digit & display only 2 digits
SELECT CAST(CAST(SUM(quantity) AS decimal(10,2)) / 
CAST(COUNT(DISTINCT ORDER_id) AS decimal(10,2)) AS decimal(10,2)) AS AVG_Pizza_perOrder FROM pizza_sales

----------------------------------------------------daily trend for ORDER. DateName function is used to drive day of the week
SELECT DATENAME(DW, ORDER_date) AS Order_Day, COUNT(DISTINCT ORDER_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(DW, ORDER_date)

---------------------------------------------------Monthly Trend per Order
SELECT DATENAME(MONTH, ORDER_date) AS Order_Month, COUNT(DISTINCT ORDER_id) AS Total_Order
FROM pizza_sales
GROUP BY DATENAME(MONTH, ORDER_date)
ORDER BY Total_Order DESC

---------------------------------------------------Percentage of sales by pizza category filtered by month
SELECT pizza_category AS Pizza_Category,  SUM(total_price) AS Total_Sales, 
SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(ORDER_date)=1) AS PCT
FROM pizza_sales 
WHERE MONTH(ORDER_date) = 1
GROUP BY pizza_category

----------------------------------------------Percentage of sales by pizza size filtered by month
SELECT pizza_size As Pizza_Size, CAST(SUM(total_price) AS decimal(10,2)) AS Total_Sales, CAST(SUM(total_price) * 100 / 
(SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(quarter, ORDER_date) = 1) AS Decimal(10, 2)) AS PCT FROM pizza_sales
WHERE DATEPART(quarter, ORDER_date) = 1
GROUP BY pizza_size
ORDER BY PCT ASC

-----------------------------------------------Top 5 best seller
SELECT TOP 5 pizza_name, CAST(SUM(total_price) AS decimal(10, 2)) AS Total_Reve FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Reve DESC

----------------------------------------------Bottom 5 best seller only change the ORDER
SELECT TOP 5 pizza_name, CAST(SUM(total_price) AS decimal(10, 2)) AS Total_Reve FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Reve ASC

----------------------------------------------------------------Top 5 best quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC

----------------------------------------Top 5 BY total ORDER
SELECT TOP 5 pizza_name, COUNT(DISTINCT ORDER_id) AS Total_Order FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Order

SELECT * FROM pizza_sales
------------------------------------------


