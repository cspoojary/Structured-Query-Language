/* ==============================================================================
   SQL Views 
A View is a virtual table based on the result of an SQL query.
It does not store data physically; instead, it fetches data from one or more base tables whenever you access it.

Types of Views in SQL
1. Simple View
2. Complex View
3. Materialized View
4. Inline View (Subquery View)
5. Security View
-------------------------------------------------------------------------------
   This script demonstrates various view use cases in SQL Server.
   It includes examples for creating, dropping, and modifying views, hiding
   query complexity, and implementing data security by controlling data access.

   Table of Contents:
     1. Create, Drop, Modify View
     2. USE CASE - HIDE COMPLEXITY
     3. USE CASE - DATA SECURITY
===============================================================================
*/
/* ==============================================================================
   CREATE, DROP, MODIFY VIEW
===============================================================================*/

/* TASK:
   Create a view that summarizes monthly sales by aggregating:
     - OrderMonth (truncated to month)
     - TotalSales, TotalOrders, and TotalQuantities.
*/

-- Create View
CREATE VIEW Sales.V_Monthly_Summary AS
(
    SELECT 
        DATETRUNC(month, OrderDate) AS OrderMonth,
        SUM(Sales) AS TotalSales,
        COUNT(OrderID) AS TotalOrders,
        SUM(Quantity) AS TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
);
GO

-- Query the View
SELECT * FROM Sales.V_Monthly_Summary;

-- Drop View if it exists
IF OBJECT_ID('Sales.V_Monthly_Summary', 'V') IS NOT NULL
    DROP VIEW Sales.V_Monthly_Summary;
GO

-- Re-create the view with modified logic
CREATE VIEW Sales.V_Monthly_Summary AS
SELECT 
    DATETRUNC(month, OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders
FROM Sales.Orders
GROUP BY DATETRUNC(month, OrderDate);
GO

/* ==============================================================================
   VIEW USE CASE | HIDE COMPLEXITY
===============================================================================*/

/* TASK:
   Create a view that combines details from Orders, Products, Customers, and Employees.
   This view abstracts the complexity of multiple table joins.
*/
CREATE VIEW Sales.V_Order_Details AS
(
    SELECT 
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Category,
        COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
        c.Country AS CustomerCountry,
        COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM Sales.Orders AS o
    LEFT JOIN Sales.Products AS p ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers AS c ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees AS e ON e.EmployeeID = o.SalesPersonID
);
GO

/* ==============================================================================
   VIEW USE CASE | DATA SECURITY
===============================================================================*/

/* TASK:
   Create a view for the EU Sales Team that combines details from all tables,
   but excludes data related to the USA.
*/
CREATE VIEW Sales.V_Order_Details_EU AS
(
    SELECT 
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Category,
        COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
        c.Country AS CustomerCountry,
        COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM Sales.Orders AS o
    LEFT JOIN Sales.Products AS p ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers AS c ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees AS e ON e.EmployeeID = o.SalesPersonID
    WHERE c.Country != 'USA'
);

GO

/*+===========================================================================
Simple View
A simple view is created using a single table and does not contain group functions or joins.
You can update data through a simple view (if no aggregate or DISTINCT is used).
==================================================================================*/
-- Syntax:
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;

-- Example:
CREATE VIEW hr_employees AS
SELECT emp_id, emp_name, salary
FROM employees
WHERE dept = 'HR';

-- Updatable: Yes
-- Use: Simplifies queries and provides restricted access to columns.
/*=======================================================================================
2. Complex View
A complex view is created using multiple tables (using JOINs) or group functions (like SUM, AVG).
It cannot be updated directly
You cannot perform DML (UPDATE/INSERT/DELETE) operations directly through a complex view.
==========================================================================================*/
-- Syntax:
CREATE VIEW view_name AS
SELECT t1.column, t2.column, aggregate_function()
FROM table1 t1
JOIN table2 t2 ON t1.col = t2.col
WHERE condition
GROUP BY t1.column;

-- Example:
CREATE VIEW employee_department AS
SELECT e.emp_name, e.salary, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- Updatable: No
-- Use: To combine and summarize data from multiple tables.

/*=========================================================================================
3. Materialized View
A materialized view physically stores the result of the query.
It is used to improve performance for complex queries by storing data instead of recalculating each time.
MySQL doesn’t support true materialized views, but you can simulate them using tables.
===========================================================================================*/
-- Syntax
CREATE TABLE view_name AS
SELECT columns
FROM table_name
WHERE condition;

-- Example:
CREATE TABLE sales_summary AS
SELECT product_id, SUM(quantity) AS total_sold
FROM sales
GROUP BY product_id;

-- Updatable: Yes (manually by refreshing)
-- Use: For faster access to precomputed results.
/*=========================================================================================
4. Inline View (Subquery View)

Definition:
An inline view is a subquery in the FROM clause of a main query.
It is not stored permanently — it exists only during query execution.

=======================================================================================*/
-- Syntax:
SELECT *
FROM (
     SELECT emp_name, salary
     FROM employees
     WHERE salary > 50000
) AS high_salary;

-- Example:
SELECT emp_name, salary
FROM (
     SELECT emp_name, salary
     FROM employees
     WHERE dept = 'IT'
) AS it_staff
WHERE salary > 60000;

-- Updatable: No (temporary view)
-- Use: For temporary data filtering or summarizing within complex queries.

/*=========================================================================================
Security View
A Security View restricts user access to specific columns or rows, ensuring users only see allowed data.
=====================================================================================================*/
-- Syntax:
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;

-- Example:
CREATE VIEW public_employees AS
SELECT emp_name, dept
FROM employees;

-- Updatable: Limited
-- Use: Data privacy and controlled access for users.








