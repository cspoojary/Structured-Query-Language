USE MyDatabase

/* CHAPTER 6-1
	JOINING DATA */

-- JOINs
-- NO JOIN
-- Retrieve all data from customers and orders as separate results

SELECT *
FROM customers;

SELECT *
FROM orders;

-- INNER JOIN = Matching rows from both tables.

-- Get all customers along with their orders, but only for customers who have placed an order.
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id;

-- LEFT JOINS = ALL THE MATCHING FROM LEFT AND ONLY MATCHING FROM RIGHT.

-- Get all customers along with their orders,including those without orders.
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o 
ON c.id = o.customer_id;

-- RIGHT JOINS : ALL TH ROWS FROM RIGHT AND MATCHING FROM LEFT.
-- Get all customers along with their orders,including orders without matching customers.
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o 
ON c.id = o.customer_id; 

-- SQL TASK 
-- Get all customers along with their orders,including orders without matching customers.

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders AS o 
LEFT JOIN customers AS c
ON c.id = o.customer_id;

-- FULL JOINS = ALL THE ROWS FROM BOTH TABLES.
-- Get all customers and all orders, even if there's no match.

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
FULL JOIN orders AS o 
ON c.id = o.customer_id;

-- ADVANCED JOINS


-- LEFT ANTI JOIN = ROW FROM LEFT THAT HAS no match IN RIGHT
-- Get all customers who havn't place any order.
SELECT *
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.id = o.customer_id
WHERE o.customer_id IS NULL;

-- RIGHT ANTI JOIN = ROWS FROM RIGHT THAT HAS no match IN LEFT.
-- Get all orders without matching customers.
SELECT * 
FROM customers AS c
RIGHT JOIN orders AS o 
ON c.id = o.customer_id
WHERE c.id  IS NULL;

SELECT * 
FROM orders AS o
LEFT JOIN customers AS c 
ON c.id = o.customer_id
WHERE c.id  IS NULL;

-- FULL ANTI JOIN = ONLY ROWS THAT DON'T MATCH IN EITHER TABLES.
-- Find customers without orders and orders without customers.

SELECT * 
FROM orders AS o 
FULL JOIN customers AS c 
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL;

-- CHALLENGE
-- Get all customers along with their orders, but only for customers who have placed an order.
SELECT * 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id 
WHERE o.customer_id IS NOT NULL;

-- CROSS JOIN = EVERY ROW FROM LEFT WITH EVERY ROE FROM RIGHT = ALL POSSIBLE COMBINATION -CARTESIAN JOINS-
-- Generate All possible combinations of customers and orders.
SELECT * 
FROM customers
CROSS JOIN orders;

/*  Using SalesDB, Retrieve a list of all orders, along with the related customers, product and employee details.
	For each order, display:
	- OrderID
	- Customer's name
	- Product name
	- Sales amount
	- Product price
	- Salesperson's name */

USE SalesDB

SELECT * FROM Sales.Customers;

SELECT * FROM Sales.Employees;

SELECT * FROM Sales.Orders;

SELECT * FROM Sales.OrdersArchive;

SELECT * FROM Sales.Products;

SELECT 
	o.OrderID,
	o.Sales,
	c.FirstName AS CustomerFirstName,
	c.LastName as CustomerLastName,
	p.Product AS ProductName,
	p.Price,
	e.FirstName AS EmployeeFirstName,
	e.LastName AS EmployeeLastName
FROM Sales.Orders AS o 
LEFT JOIN  Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
on o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID;


-- CHA[TER 6 - 2
-- SET OPERATORS

SELECT
FirstName,
LastName
FROM Sales.Customers

UNION

SELECT 
FirstName,
LastName
FROM Sales.Employees

SELECT
CustomerID AS ID,
LastName
FROM Sales.Customers

UNION

SELECT 
EmployeeID,
LastName AS Last_name
FROM Sales.Employees

/* UNION = RETURNS ALL DISTRICT ROWS FROM BOTH QUERIES.
		   REMOVES DUPLICATES ROWS FROM THE RESULT. */
-- Combines the data from employees and customers into one table.

SELECT 
FirstName,
LastName
FROM sales.Customers
UNION
SELECT 
FirstName,
LastName
FROM Sales.Employees

-- UNION ALL = RETURNS ALL ROWS FROM BOTH QUERIES, INCLUDING DUPLICATES.
SELECT 
FirstName,
LastName
FROM sales.Customers
UNION ALL
SELECT 
FirstName,
LastName
FROM Sales.Employees

/* EXCEPT = RETURNS ALL DISTINCT ROWS FROM THE FIRST QUERY THAT ARE NOT FOUND IN THE SECOND QUERY.
			IT IS THE ONLY ONE WHERE THE ORDER OF QUERIES AFFECTS THE FINAL RESULTS.*/
-- Find the employee who are not customers at the same time.
SELECT 
FirstName,
LastName
FROM sales.Employees
EXCEPT
SELECT 
FirstName,
LastName
FROM Sales.Customers /* Order Of Queries is most important */

-- INTERSECT = RETURNS ONLY THE ROWS THAT ARE COMMON IN BOTH QUERIES.
-- Find the Employees, who are also customers.
SELECT 
FirstName,
LastName
FROM sales.Employees
INTERSECT
SELECT 
FirstName,
LastName
FROM Sales.Customers

-- UNION USE CASES
-- COMBINE INFORMATION

-- Orders are storedin separate tables ( Orders and OredersArchieve). 
-- Combine all orders into one report without duplicates.
SELECT 
'Orders' AS SourceTable
	  ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
'OrdersArchive' AS SourceTable
	  ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID

-- EXCEPT USE CASES
-- DELTA DETECTION = Identifying the difference or changes(delta) between two batches or data.
-- DATA COMPLETENESS CHECK = EXCEPT operator can be used to compare tables to detect discrepancies between databases.
