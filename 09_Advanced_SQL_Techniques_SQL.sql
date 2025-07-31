USE MyDatabase

SELECT 
* 
FROM INFORMATION_SCHEMA.COLUMNS

SELECT 
DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS

USE SalesDB

-- CHAPTER 9-1 = SUBQUERIES = A Query inside another query.
 -- FROM CLAUSE
 --  Find the products that have a price higher than the average price of all products.

 -- Main Query
 SELECT 
 * 
 FROM
 -- Subquery
	 (SELECT 
	 ProductID,
	 Price,
	 AVG(Price) OVER() AvgPrice
	 FROM Sales.Products)t
WHERE price > AvgPrice

-- Rank Customers based on their total amount of sales.
-- Main Query
SELECT
*, 
RANK() OVER (ORDER BY TotalSales DESC) CustomerRank
FROM
	-- SubQuery
	(SELECT 
	CustomerID,
	SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID)t

-- Show the product IDs, product names, prices, and the total number of orders.
-- Main Query
SELECT 
	ProductID,
	Product,
	Price,
	-- Subquery
	(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM Sales.Products;

-- JOIN SUBQUERY
-- Show customer details and find the total orders of each customer.

-- Main Query
SELECT 
c.*,
o.TotalOrders
FROM Sales.Customers c
LEFT JOIN (
	SELECT
	CustomerID,
	COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID

-- WHERE Subquery
-- Find the products that have a price higher than the average price of all products.
SELECT
    ProductID,
    Price,
    (SELECT AVG(Price) FROM Sales.Products) AS AvgPrice -- Subquery
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products); -- Subquery

-- Subquery : IN OPERATOR

-- Show the details of orders made by customers in Germany.
-- Main Query
SELECT
    *
FROM Sales.Orders
WHERE CustomerID IN (
					-- Subquery
					SELECT
						CustomerID
					FROM Sales.Customers
					WHERE Country = 'Germany'
);

-- Show the details of orders made by customers not in Germany.

-- Main Query
SELECT
    *
FROM Sales.Orders
WHERE CustomerID NOT IN (
    -- Subquery
    SELECT
        CustomerID
    FROM Sales.Customers
    WHERE Country = 'Germany'
);

-- ANY / ALL OPERATOR
-- Find female employees whose salaries are greater than the salaries of any male employees.

-- Main Query
SELECT
    EmployeeID, 
    FirstName,
    Salary
FROM Sales.Employees
WHERE Gender = 'F'
  AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

-- Find female employees whose salaries are greater than the salaries of all male employees.
SELECT
    EmployeeID, 
    FirstName,
    Salary
FROM Sales.Employees
WHERE Gender = 'F'
  AND Salary > All (
      SELECT Salary
      FROM Sales.Employees
      WHERE Gender = 'M'
  );

-- NON-CORRELATED|CORRELATED
-- Show all customer details and the total orders for each customer using a correlated subquery.

--Main Query
SELECT
    *,
    (SELECT COUNT(*) -- Sub Query
     FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS TotalSales
FROM Sales.Customers AS c;

-- EXISTS

--Show the details of orders made by customers in Germany.

SELECT
    *
FROM Sales.Orders AS o
WHERE EXISTS (
    SELECT 1
    FROM Sales.Customers AS c
    WHERE Country = 'Germany'
    AND o.CustomerID = c.CustomerID);

-- Show the details of orders made by customers not in Germany.
SELECT
    *
FROM Sales.Orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Customers AS c
    WHERE Country = 'Germany'
      AND o.CustomerID = c.CustomerID
);

-- CHAPTER 9 - 2 = COMMON TABLE EXPRESSON (CTE)

-- NON-RECURSIVE CTE

-- Step1: Find the total Sales Per Customer (Standalone CTE)
WITH CTE_Total_Sales AS
(
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Step2: Find the last order date for each customer (Standalone CTE)
, CTE_Last_Order AS
(
    SELECT
        CustomerID,
        MAX(OrderDate) AS Last_Order
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Step3: Rank Customers based on Total Sales Per Customer (Nested CTE)
, CTE_Customer_Rank AS
(
    SELECT
        CustomerID,
        TotalSales,
        RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
    FROM CTE_Total_Sales
)
-- Step4: segment customers based on their total sales (Nested CTE)
, CTE_Customer_Segments AS
(
    SELECT
        CustomerID,
        TotalSales,
        CASE 
            WHEN TotalSales > 100 THEN 'High'
            WHEN TotalSales > 80  THEN 'Medium'
            ELSE 'Low'
        END AS CustomerSegments
    FROM CTE_Total_Sales
)
-- Main Query
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    cts.TotalSales,
    clo.Last_Order,
    ccr.CustomerRank,
    ccs.CustomerSegments
FROM Sales.Customers AS c
LEFT JOIN CTE_Total_Sales AS cts
    ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order AS clo
    ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank AS ccr
    ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segments AS ccs
    ON ccs.CustomerID = c.CustomerID;

-- Generate a sequence of numbers from 1 to 20.

WITH Series AS (
    -- Anchor Query
    SELECT 1 AS MyNumber
    UNION ALL
    -- Recursive Query
    SELECT MyNumber + 1
    FROM Series
    WHERE MyNumber < 20
)
-- Main Query
SELECT *
FROM Series

-- Generate a sequence of numbers from 1 to 1000.
WITH Series AS
(
    -- Anchor Query
    SELECT 1 AS MyNumber
    UNION ALL
    -- Recursive Query
    SELECT MyNumber + 1
    FROM Series
    WHERE MyNumber < 1000
)
-- Main Query
SELECT *
FROM Series
OPTION (MAXRECURSION 5000);

-- RECURSIVE CTE | BUILD HIERARCHY

/* 
   Build the employee hierarchy by displaying each employee's level within the organization.
   - Anchor Query: Select employees with no manager.
   - Recursive Query: Select subordinates and increment the level.
*/

WITH CTE_Emp_Hierarchy AS
(
    -- Anchor Query: Top-level employees (no manager)
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL
    UNION ALL
    -- Recursive Query: Get subordinate employees and increment level
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        Level + 1
    FROM Sales.Employees AS e
    INNER JOIN CTE_Emp_Hierarchy AS ceh
        ON e.ManagerID = ceh.EmployeeID
)
-- Main Query
SELECT *
FROM CTE_Emp_Hierarchy;

-- CHAPTER 9-3 = VIEWS

-- CREATE, DROP, MODIFY VIEW

/* 
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

-- VIEW USE CASE | HIDE COMPLEXITY

/* 
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

SELECT 
* 
FROM Sales.V_Order_Details

-- VIEW USE CASE | DATA SECURITY

/*
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

SELECT 
* 
FROM Sales.V_Order_Details_EU


-- CHAPTER 9-4 = CTAS & TEMP

-- Step 1: Create Temporary Table (#Orders)
SELECT
    *
INTO #Orders
FROM Sales.Orders;

SELECT * FROM #Orders
  
-- Step 2: Clean Data in Temporary Table
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered';
  
SELECT * FROM #Orders

-- Step 3: Load Cleaned Data into Permanent Table (Sales.OrdersTest)

SELECT
    *
INTO Sales.OrdersTest
FROM #Orders;

SELECT * FROM #Orders

-- CHAPTER 9 - 5 = STORED PROCEDURE

 -- Step 1 : Write a query for US Customer find the Total Number of Customer and the Average Score.
SELECT 
     COUNT(*) TotalCustomers,
     AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'

-- Step 2: Turning the Query into a Stored Procedure.

CREATE PROCEDURE GetCustomerSummary AS 
BEGIN
SELECT 
     COUNT(*) TotalCustomers,
     AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'
END

-- Step 3 : Excute the Stored Procedure.
 
EXEC GetCustomerSummary

-- For German Customers Find the Total Number of Customers and the average.
CREATE PROCEDURE GetCustomerSummaryGermany AS
BEGIN
SELECT 
     COUNT(*) TotalCustomers,
     AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'Germany'
END

EXEC GetCustomerSummaryGermany

-- Define stored procedure
    -- Step 1 : Define parameter

ALTER PROCEDURE GetCustomerSummary @Country VARCHAR(50) -- = 'USA' = In default
AS 
BEGIN
SELECT 
     COUNT(*) TotalCustomers,
     AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country =  @Country -- Step 2: Use the Parameter
END

-- Step 3 : Pass the Parameter's Value at Execution.
EXEC GetCustomerSummary @Country = 'Germany'

EXEC GetCustomerSummary @Country = 'USA'
 
 DROP PROCEDURE GetCustomerSummaryGermany

-- Multiple Queries in Stored Procedure

-- Edit the Stored Procedure
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    -- Query 1: Find the Total Nr. of Customers and the Average Score
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;

    -- Query 2: Find the Total Nr. of Orders and Total Sales
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;

-- Before
SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country ='USA';


-- Variables in Stored Procedure.

-- Edit the Stored Procedure
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    -- Declare Variables
    DECLARE @TotalCustomers INT, @AvgScore FLOAT;
                
    -- Query 1: Find the Total Nr. of Customers and the Average Score
    SELECT
		@TotalCustomers = COUNT(*),
		@AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

	PRINT('Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR));
	PRINT('Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR));

    -- Query 2: Find the Total Nr. of Orders and Total Sales
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;

-- Control Flow IFELSE in Stored Procedure

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
	-- Declare Variables
	DECLARE @TotalCustomers INT, @AvgScore FLOAT;     

	/* --------------------------------------------------------------------------
	   Prepare & Cleanup Data
	-------------------------------------------------------------------------- */

	IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
	BEGIN
		PRINT('Updating NULL Scores to 0');
		UPDATE Sales.Customers
		SET Score = 0
		WHERE Score IS NULL AND Country = @Country;
	END
	ELSE
	BEGIN
		PRINT('No NULL Scores found');
	END;

	/* --------------------------------------------------------------------------
	   Generating Reports
	-------------------------------------------------------------------------- */
	SELECT
		@TotalCustomers = COUNT(*),
		@AvgScore = AVG(Score)
	FROM Sales.Customers
	WHERE Country = @Country;

	PRINT('Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR));
	PRINT('Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR));

	SELECT
		COUNT(OrderID) AS TotalOrders,
		SUM(Sales) AS TotalSales,
		1/0 AS FaultyCalculation  -- Intentional error for demonstration
	FROM Sales.Orders AS o
	JOIN Sales.Customers AS c
		ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;

SELECT * FROM Sales.Customers

-- Error Handling TRY CATCH in Stored Procedure

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
    
BEGIN
    BEGIN TRY
        -- Declare Variables
        DECLARE @TotalCustomers INT, @AvgScore FLOAT;     

        /* --------------------------------------------------------------------------
           Prepare & Cleanup Data
        -------------------------------------------------------------------------- */

        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT('Updating NULL Scores to 0');
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END
        ELSE
        BEGIN
            PRINT('No NULL Scores found');
        END;

        /* --------------------------------------------------------------------------
           Generating Reports
        -------------------------------------------------------------------------- */
        SELECT
            @TotalCustomers = COUNT(*),
            @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT('Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR));
        PRINT('Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR));

        SELECT
            COUNT(OrderID) AS TotalOrders,
            SUM(Sales) AS TotalSales,
            1/0 AS FaultyCalculation  -- Intentional error for demonstration
        FROM Sales.Orders AS o
        JOIN Sales.Customers AS c
            ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country;
    END TRY
    BEGIN CATCH
        /* --------------------------------------------------------------------------
           Error Handling
        -------------------------------------------------------------------------- */
        PRINT('An error occurred.');
        PRINT('Error Message: ' + ERROR_MESSAGE());
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR));
        PRINT('Error State: ' + CAST(ERROR_STATE() AS NVARCHAR));
        PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
        PRINT('Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));
    END CATCH;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;

-- TRIGGER

-- Step 1: Create Log Table
CREATE TABLE Sales.EmployeeLogs
(
    LogID      INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    LogMessage VARCHAR(255),
    LogDate    DATE
);
GO

-- Step 2: Create Trigger on Employees Table
CREATE TRIGGER trg_AfterInsertEmployee
ON Sales.Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT
        EmployeeID,
        'New Employee Added = ' + CAST(EmployeeID AS VARCHAR),
        GETDATE()
    FROM INSERTED;
END;
GO

SELECT * FROM Sales.EmployeeLogs;

-- Step 3: Insert New Data Into Employees
INSERT INTO Sales.Employees
VALUES (6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3);
GO

-- Check the Logs
SELECT *
FROM Sales.EmployeeLogs;
GO 