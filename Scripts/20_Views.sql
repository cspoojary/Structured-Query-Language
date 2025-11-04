/* ==============================================================================
   SQL Views 
A View is a virtual table based on the result of an SQL query.
It does not store data physically; instead, it fetches data from one or more base tables whenever you access it.

Types of Views in SQL
1. Simple View
A simple view is created using a single table and does not contain group functions or joins.
You can update data through a simple view (if no aggregate or DISTINCT is used).

2. Complex View

Definition:
A complex view is created using multiple tables (using JOINs) or group functions (like SUM, AVG).
It cannot be updated directly.

3. Materialized View

Definition:
A materialized view physically stores the result of the query.
It is used to improve performance for complex queries by storing data instead of recalculating each time.

4. Inline View (Subquery View)

Definition:
An inline view is a subquery in the FROM clause of a main query.
It is not stored permanently — it exists only during query execution.

5. System View (or Data Dictionary View)

Definition:
These are predefined views created by the database system to provide metadata information — about users, tables, constraints, etc.
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

/*+===========================================================================
Simple View
A simple view is created using a single table and does not contain group functions or joins.
You can update data through a simple view (if no aggregate or DISTINCT is used).
==================================================================================*/
























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
