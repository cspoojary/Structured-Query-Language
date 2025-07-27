USE MyDatabase

USE SalesDB

-- CHAPTER 1 = AGGREGATE FUNCTION

-- Find the total number orders
SELECT 
COUNT(*) AS Total_nmbr_orders
FROM orders

-- Find the total sales of all orders
SELECT SUM(sales) AS total_sales
FROM orders

-- Find the average sales of all orders
SELECT AVG(sales) AS avg_sales
FROM orders

-- Find the highest score among customers
SELECT MAX(sales) AS highest_sales
FROM orders

-- Find the lowest score among customers
SELECT MIN(sales) AS highest_sales
FROM orders


SELECT 
Customer_id,
COUNT(*) AS Total_nmbr_orders,
SUM(sales) AS total_sales,
AVG(sales) AS avg_sales,
MAX(sales) AS highest_sales,
MIN(sales) AS highest_sales
FROM orders
GROUP BY Customer_id

-- TASK = Analyse the score in customers table.
SELECT
*
FROM
customers

	-- Find the total number of customers

SELECT COUNT(*) AS Total_customers
FROM customers

SELECT *
FROM customers
WHERE SCORE > 600

-- WINDOW FUNCTION
USE SalesDB
-- Find the total sales across all orders.
SELECT 
SUM(sales) TotalSales
from Sales.Orders

-- Find the total sales for each product.
SELECT 
ProductID,
SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID

/* Find the total sales across all orders, Additionally provide details such order id & order date.*/

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER()TotalSales
FROM Sales.Orders

-- The Syntax
/* Find the total sales for each product,
   additionally providing details such as OrderID and OrderDate. */
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts
FROM Sales.Orders

-- Find the total sales across all orders
-- Find the total sales for each product
-- Find the total sales fro eacn combination of product and order status.
-- Additionally providing details such as OrderID and OrderDate.
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales, 
	SUM(Sales) OVER()TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductAndStatus
FROM Sales.Orders

-- ORDER BY
-- Rank each order by Sales from highest to lowest. Additionally provide deatils such order id and order date.
SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER (ORDER BY Sales ) Ranksales
FROM Sales.Orders

-- </> Window Syntax = AVG(Sales) OVER (PARTITION BY Category ORDER BY OrderDate ROWS UNBOUNDED PRECEDING)

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
FROM Sales.Orders

-- 4X Rules

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101, 102)

-- Rank Customers based on their total sales.
SELECT 
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID

-- </> Aggregate Function
-- Syntax =AVG(Sales) OVER (PARTITION BY ProductID ORDER BY Sales).

-- COUNT() = Returns nmbr of rows within a window.

-- Find the total numbers of orders.
-- FInd the total number of Ordera for each customers.
-- Additionally provide details such Order ID , Order Date
SELECT 
	OrderID, 
	OrderDate,
	CustomerID,
	COUNT(*) OVER() Totalorders,
	COUNT(*) OVER(PARTITION BY CustomerID) ordersByCustomers
FROM Sales.Orders

-- Find the total number of customers
-- Find total number of scores for the customers.
-- Additionally provides All customers Details.
SELECT 
*,
COUNT(*) OVER() TotalCustomers,
COUNT(1) OVER() TotalScores,
COUNT(Score) OVER() TotalScore,
COUNT(Country) OVER() TotalCountries
FROM Sales.Customers

-- Data Quality issue
-- Check whether the table ''Orders' contains any duplicates rows.
SELECT 
	OrderID,
	COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.OrdersArchive

SELECT
* 
FROM(
	SELECT 
		OrderID,
		COUNT(*) OVER (PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
)t WHERE CheckPK > 1

-- SUM() =Returns the sum of values within a window.

-- Find the total sales across all orders.
-- And the total sales for each product
-- Additionally provides details such order ID, order Date
SELECT 
	OrderID,
	OrderDate,
	Sales,
	PRODUCTID,
	SUM(Sales) OVER () TotalSales,
	SUM(Sales) OVER (PARTITION BY ProductID) SalesByProducts
FROM Sales.Orders

-- COMPARISION ANALYSIS = Compare the current value and aggregated value of window functions.

-- Find the Percentage Contribution of Each Product's Sales to the Total Sales.

SELECT
OrderID,
ProductID,
Sales,
SUM(Sales) OVER()  TotalSales,
ROUND (CAST (Sales AS Float) / SUM(Sales) OVER() * 100, 2) PercentageOfTotal-- Percentage Contribution
FROM Sales.Orders

-- AVG = Returns average of values within a window.

-- Find the Average Sales Across All Orders 
-- Find the Average Sales for Each Product
-- Additionally, Provide details such as Order ID and Order Date.

SELECT 
	OrderID,
	OrderDate,
	Sales,
	AVG(Sales) OVER() AvgSales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProducts
FROM Sales.Orders

-- Find the Average Scores of Customers
-- Additionally, Provide details such as Customer ID and Last Name.
SELECT
CustomerID,
LastName,
Score,
COALESCE(Score, 0) CustomerScore,
AVG (Score) OVER () AvgScore,
AVG(COALESCE (Score, 0)) OVER () AvgScoreWithoutNull
FROM Sales.Customers

-- Find all orders where Sales exceed the average Sales across all orders.

SELECT
*
FROM(
	SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER() AvgSales
	FROM Sales.Orders
)t WHERE Sales > AvgSales

-- MIN = Returns the lowest value within a window./ MAX =Returns the highest value within a window.

-- Find the Highest and Lowest Sales across all orders.
-- and the highest & lowest sales for each product.
-- Additionally, provide details such as order ID and order date.
SELECT
	OrderID, 
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HeighestSales,
	MIN(Sales) OVER() LowestSales,
	MAX(Sales) OVER(PARTITION BY ProductID) HeighestSales,
	MIN(Sales) OVER(PARTITION BY ProductID) LowestSales
FROM Sales.Orders

-- Show the employees with the highest salaries.
SELECT
*
FROM(
	SELECT
	*,
	MAX (Salary) OVER() HighestSalary
	FROM Sales.Employees
)t WHERE Salary = HighestSalary

-- Find the deviation of each Sale from the minimum and maximum Sales
SELECT
	OrderID, 
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HeighestSales,
	MIN(Sales) OVER() LowestSales,
	Sales - MIN(Sales) OVER() DeviationFromMin,
	MAX(Sales) OVER() - Sales DeviationFromMax
FROM Sales.Orders

-- RUNNING & ROLLING TOTAL = Tracking Current Sales With Target Sales. And Providing Insights into historical patterns.

-- Calculate the moving average of Sales for each Product over time.
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg
FROM Sales.Orders

-- Calculate the moving average of Sales for each Product over time, including only the next order.
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) MovingAvg
FROM Sales.Orders

-- 2. RANKING WINDOW FUNCTIONS
-- ROW_NUMBER() 
--   Rank Orders Based on Sales from Highest to Lowest.
SELECT 
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row
FROM Sales.Orders


-- RANK()
SELECT 
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row,
	RANK() OVER (ORDER BY Sales DESC) SalesRank_Rank
FROM Sales.Orders

-- DENSE_RANK
SELECT 
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row,
	RANK()       OVER (ORDER BY Sales DESC) SalesRank_Rank,
	DENSE_RANK() OVER (ORDER BY Sales DESC) SalesRank_Dense
FROM Sales.Orders

-- Use Case | Top-N Analysis: Find the Highest Sale for Each Product.
SELECT *
FROM (
SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
FROM Sales.Orders
)t WHERE RankByProduct = 1

-- Use Case | Bottom-N Analysis: Find the Lowest 2 Customers Based on Their Total Sales.
SELECT * 
FROM(
SELECT 
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER (ORDER BY SUM(Sales)) RankCustomers
FROM Sales.Orders
GROUP BY 
CustomerID
)t WHERE RankCustomers <= 2;

-- Use Case | Assign Unique IDs to the Rows of the 'Order Archive'
SELECT 
ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) UniqueID,
* 
FROM Sales.OrdersArchive

-- IDENTIFY DUPLICATES
--  Identify Duplicate Rows in 'Order Archive' and return a clean result without any duplicates.
SELECT * FROM (
SELECT 
ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
* 
FROM Sales.OrdersArchive
)t WHERE rn = 1

-- NTILE() = Divides the rows into a specified number of approximately equal groups.
SELECT
	OrderID,
	Sales,
NTILE(1) OVER (ORDER BY Sales DESC) OneBucket,
NTILE(2) OVER (ORDER BY Sales DESC) TwoBucket,
NTILE(3) OVER (ORDER BY Sales DESC) ThreeBucket,
NTILE(4) OVER (ORDER BY Sales DESC) FourBucket,
NTILE(5) OVER (ORDER BY Sales DESC) FiveBucket
FROM Sales.Orders

-- NTILE USE CASE
-- DATA SEGMENTATION = Divides a dataset into distinct subsets based on certain criteria.
-- Segment all Orders into 3 Categories: High, Medium, and Low Sales.
SELECT
*,
CASE WHEN Buckets = 1 THEN 'High'
	 WHEN Buckets = 2 THEN 'Medium'
	 WHEN Buckets = 3 THEN 'Low'
END SalesSegmentations
FROM (
	SELECT 
		OrderID,
		Sales,
		NTILE(3) OVER (ORDER BY Sales DESC) Buckets
	FROM Sales.Orders
)t

-- EQUALIZING LOAD
-- Divide Orders into 2 Groups for Processing.
SELECT
NTILE(4) OVER (ORDER BY OrderID) Buckets,
* 
FROM Sales.Orders 

-- PERCENTAGE BASED RANKING
-- CUME_DIST() = Cumulative Distribution calculates the distribution of data points within a window.

-- Find Products that Fall Within the Highest 40% of the Prices.
SELECT 
*,
CONCAT(DistRank * 100, '%') DistRank
FROM (
	SELECT 
	Product,
	Price,
	CUME_DIST() OVER (ORDER BY Price DESC ) DistRank
	FROM Sales.Products
	)t
WHERE DistRank <= 0.4

-- PERCENT_RANK() = Calculates the relative position of each row.
SELECT 
*,
CONCAT(PRCT_Rank * 100, '%') PRCT_Rank
FROM (
	SELECT 
	Product,
	Price,
	PERCENT_RANK() OVER (ORDER BY Price DESC ) PRCT_Rank
	FROM Sales.Products
	)t
WHERE PRCT_Rank <= 0.4

--WINDOW VALUE FUNCTION

USE SalesDB

USE MyDatabase

-- LEAD() = Access a value from the next row within a window.
-- LAG() = Access a value from the previous row within a window.

-- Time Series Analysis
-- Month-Over-Month Analysis
-- Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales Between the Current and Previous Months
SELECT 
*,
CurrentMonthSales - PreviousMonthSales AS MoM_Change,
ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)/PreviousMonthSales *100, 1) AS MoM_Perc
FROM(
SELECT
	MONTH(OrderDate) OrderMonth,
	SUM(Sales) CurrentMonthSales,
	LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonthSales
FROM Sales.Orders
GROUP BY
	MONTH(OrderDate)
)t

-- MIN/MAX USE CASE = CUSTOMER RETENTION ANALYSIS
--   Customer Loyalty Analysis - Rank Customers Based on the Average Days Between Their Orders

SELECT
	CustomerID,
	AVG(DaysUntilNextOrder) AS AvgDays,
	RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 99999)) AS RankAvg
FROM(
	SELECT
	OrderID,
	CustomerID,
	OrderDate AS CurrentOrder,
	LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
	DATEDIFF(
	day,
	OrderDate,
	LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) AS DaysUntilNextOrder
	FROM Sales.Orders
) AS CustomerOrdersWithNext
GROUP BY 
	CustomerID;

-- FIRST AND LAST VALUE FUNCTION
-- FIRST_VALUE() =Access a value from the first row within a window.
-- LAST_VALUE() = Access a value from the last row within a window.

--  Find the Lowest and Highest Sales for Each Product, and determine the difference between the current Sales and the lowest Sales for each Product.
SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS LowestSales,
    LAST_VALUE(Sales) OVER (
        PARTITION BY ProductID 
        ORDER BY Sales 
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS HighestSales,
    Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
FROM Sales.Orders;