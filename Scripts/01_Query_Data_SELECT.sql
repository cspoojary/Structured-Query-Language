/* ==============================================================================
   SQL SELECT Query
-------------------------------------------------------------------------------
   This guide covers various SELECT query techniques used for retrieving, 
   filtering, sorting, and aggregating data efficiently.

   Table of Contents:
     1. SELECT ALL COLUMNS
     2. SELECT SPECIFIC COLUMNS
     3. WHERE CLAUSE
     4. ORDER BY
     5. GROUP BY
     6. HAVING
     7. DISTINCT
     8. TOP
     9. Combining Queries
	 10. COOL STUFF - Additional SQL Features
=================================================================================
*/

/* ==============================================================================
   COMMENTS
=============================================================================== */

-- This is a single-line comment.

/* This
   is
   a multiple-line
   comment
*/

/* ==============================================================================
   SELECT ALL COLUMNS
=============================================================================== */

-- Retrieve All Customer Data
SELECT *
FROM customers

-- Retrieve All Order Data
SELECT *
FROM orders

/* ==============================================================================
   SELECT FEW COLUMNS
=============================================================================== */

-- Retrieve each customer's name, country, and score.
SELECT 
    first_name,
    country, 
    score
FROM customers

/* ==============================================================================
   WHERE 
The WHERE clause in SQL is used to filter records (rows) in a 
	table — it tells the database which rows to select, update, or delete based on a specific condition.

When to Use the WHERE Clause:
  * Get specific data from a table (not all rows)
  * Apply conditions in SELECT, UPDATE, or DELETE statements
  * Filter rows before grouping or joining

If you don’t use a WHERE clause in:
  * UPDATE → it updates all rows
  * DELETE → it deletes all rows

* WHERE filters before grouping and joining
* It is used for individual roows.
=============================================================================== */
-- Filtering records in SELECT
SELECT * 
FROM Employees
WHERE Department = 'HR';

-- With numeric condition
SELECT Name, Salary 
FROM Employees
WHERE Salary > 50000;

-- Using multiple conditions (AND / OR)
SELECT * 
FROM Employees
WHERE Department = 'IT' AND Salary > 40000;

-- Using WHERE in UPDATE
UPDATE Employees
SET Salary = Salary + 5000
WHERE Department = 'Sales';

-- Using WHERE in DELETE
DELETE FROM Employees
WHERE EmployeeID = 101;

-- Using pattern matching (LIKE)
SELECT * 
FROM Employees
WHERE Name LIKE 'A%';

-- Query: Join + Where
SELECT e.Name, d.DeptName, e.Salary
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID
WHERE e.Salary > 50000;

-- WHERE with GROUP BY
/* GROUP BY is used to group rows that have the same value in one or more columns (like department).
The WHERE clause filters before grouping happens.*/
SELECT DeptID, AVG(Salary) AS AvgSalary
FROM Employees
WHERE Salary > 40000
GROUP BY DeptID;

-- If you want to filter after grouping, use HAVING, not WHERE.
SELECT DeptID, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DeptID
HAVING AVG(Salary) > 50000;

/*=================
EXAMPLE
==================*/
-- Retrieve customers with a score not equal to 0
SELECT *
FROM customers
WHERE score != 0

-- Retrieve customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany'

-- Retrieve the name and country of customers from Germany
SELECT
    first_name,
    country
FROM customers
WHERE country = 'Germany'

/* ==============================================================================
   ORDER BY
* It’s one of the most useful clauses for arranging your query results in a specific order.

*The ORDER BY clause is used to sort the result set of a SQL query — either in:
   - Ascending order (smallest to largest → default)
   - Descending order (largest to smallest)
=============================================================================== */
-- Basic Syntax
SELECT column1, column2
FROM table_name
ORDER BY column_name [ASC|DESC];

--Sort by one column
SELECT * 
FROM Employees
ORDER BY Salary; -- Sorts all employees by Salary in ascending order (lowest → highest).

-- Sort in descending order
SELECT Name, Salary 
FROM Employees
ORDER BY Salary DESC; -- Displays employees from highest to lowest salary.

-- Sort by multiple columns
SELECT Name, Department, Salary
FROM Employees
ORDER BY Department ASC, Salary DESC; -- First sorts data by Department alphabetically (A → Z)
									  -- If two employees are in the same department, it then sorts them by Salary (high → low)

-- Using column position
SELECT Name, Salary, Department
FROM Employees
ORDER BY 2 DESC; -- The number 2 means the second column (Salary) in the SELECT list.

-- ORDER BY with WHERE
SELECT Name, Salary
FROM Employees
WHERE Department = 'IT'
ORDER BY Salary DESC; -- Filters only IT employees, then sorts them by highest to lowest salary.

-- ORDER BY with computed column
SELECT Name, (Salary + Bonus) AS TotalPay
FROM Employees
ORDER BY TotalPay DESC; -- Sorts employees by their total pay (salary + bonus) in descending order.

/*======================
EXAMPLE
=======================*/

/* Retrieve all customers and 
   sort the results by the highest score first. */
SELECT *
FROM customers
ORDER BY score DESC

/* Retrieve all customers and 
   sort the results by the lowest score first. */
SELECT *
FROM customers
ORDER BY score ASC

/* Retrieve all customers and 
   sort the results by the country. */
SELECT *
FROM customers
ORDER BY country ASC

/* Retrieve all customers and 
   sort the results by the country and then by the highest score. */
SELECT *
FROM customers
ORDER BY country ASC, score DESC

/* Retrieve the name, country, and score of customers 
   whose score is not equal to 0
   and sort the results by the highest score first. */
SELECT
    first_name,
    country,
    score
FROM customers
WHERE score != 0
ORDER BY score DESC

/* ==============================================================================
   GROUP BY
The GROUP BY clause in SQL is used to group rows that have the same values in one or more columns.
* It is often used with aggregate functions like:
   -- COUNT()
   -- SUM()
   -- AVG()
   -- MIN()
   -- MAX()
So basically, GROUP BY helps you get summary information from your data (like totals, averages, or counts per group).
=============================================================================== */
-- Syntax
SELECT column_name, aggregate_function(column_name)
FROM table_name
GROUP BY column_name;

-- Average salary by department
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department; -- SQL grouped all rows by Department.
					 -- Then for each department, it calculated the average salary.

-- Count employees in each department
SELECT Department, COUNT(*) AS TotalEmployees
FROM Employees
GROUP BY Department;

-- Total salary per department
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department;

-- GROUP BY with WHERE
SELECT Department, COUNT(*) AS TotalEmployees
FROM Employees
WHERE Salary > 45000
GROUP BY Department; -- Filters rows first (only employees with salary > 45000), then groups them by department. 

-- GROUP BY with HAVING
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 50000; -- Returns only departments where average salary is greater than 50,000.

/*==============
EXAMPLE
===============*/
-- Find the total score for each country
SELECT 
    country,
    SUM(score) AS total_score
FROM customers
GROUP BY country

/* This will not work because 'first_name' is neither part of the GROUP BY 
   nor wrapped in an aggregate function. SQL doesn't know how to handle this column. */
SELECT 
    country,
    first_name,
    SUM(score) AS total_score
FROM customers
GROUP BY country

-- Find the total score and total number of customers for each country
SELECT 
    country,
    SUM(score) AS total_score,
    COUNT(id) AS total_customers
FROM customers
GROUP BY country

/* ==============================================================================
   HAVING
The HAVING clause in SQL is used to filter the results of grouped data (the results created by GROUP BY).
* Think of it like this:
	- WHERE filters rows before grouping
	- HAVING filters groups after grouping
=============================================================================== */
-- Syntax
SELECT column_name, aggregate_function(column_name)
FROM table_name
GROUP BY column_name
HAVING condition;

-- Using HAVING with GROUP BY
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 50000;
/*
* GROUP BY → groups rows by department
* AVG(Salary) → calculates average salary for each group
* HAVING → filters groups where average salary > 50,000
*/

-- HAVING without WHERE
SELECT Department, COUNT(*) AS TotalEmployees
FROM Employees
GROUP BY Department
HAVING COUNT(*) >= 2; -- Shows departments that have 2 or more employees.

-- Using WHERE and HAVING together
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
WHERE Salary > 40000        -- filters individual rows
GROUP BY Department
HAVING AVG(Salary) > 50000; -- filters groups
/*
WHERE removes low-salary employees (row-level filter)
GROUP BY groups remaining rows by department
HAVING keeps only those departments with average > 50,000
*/

--HAVING with multiple conditions
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
HAVING SUM(Salary) > 100000 AND COUNT(*) >= 2; -- Shows departments where total salary > 100,000 and at least 2 employees.

/*==============
EXAMPLE
===============*/
/* Find the average score for each country
   and return only those countries with an average score greater than 430 */
SELECT
    country,
    AVG(score) AS avg_score
FROM customers
GROUP BY country
HAVING AVG(score) > 430

/* Find the average score for each country
   considering only customers with a score not equal to 0
   and return only those countries with an average score greater than 430 */
SELECT
    country,
    AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430

/*
* GROUP BY will groups rows with same values used with Aggregate functions.
* HAVING will Filters grouped data used with GROUP BY.
* ORDER BY will Sorts results used withAny query.
*/
/*
Order of SQL Execution
1️⃣ FROM
2️⃣ WHERE
3️⃣ GROUP BY
4️⃣ HAVING
5️⃣ SELECT
6️⃣ ORDER BY
*/

/* ==============================================================================
   DISTINCT
The DISTINCT keyword is used to remove duplicate rows from the result of a SELECT query.
It makes sure that the data you get back contains only unique values.

TOP			Limits number of rows returned	SQL Server
LIMIT		Limits number of rows			MySQL / PostgreSQL
FETCH FIRST	Limits number of rows			Oracle
=============================================================================== */
-- Syntax
SELECT DISTINCT column1, column2, ...
FROM table_name;

-- Return Unique list of all countries
SELECT DISTINCT country
FROM customers

-- Counting Unique Values
SELECT COUNT(DISTINCT department) AS unique_departments
FROM employees;

-- With JOIN
SELECT DISTINCT e.department_id, d.department_name
FROM employees e

/* ==============================================================================
   TOP
The TOP keyword is used to limit the number of rows returned by a query.
It helps you fetch only a specific number (or percentage) of records from a table.
=============================================================================== */
 --Syntax 
SELECT TOP (number) column1, column2, ...
FROM table_name
WHERE condition;

-- Retrieve only 3 Customers
SELECT TOP 3 *
FROM customers

-- Retrieve the Top 3 Customers with the Highest Scores
SELECT TOP 3 *
FROM customers
ORDER BY score DESC

-- Retrieve the Lowest 2 Customers based on the score
SELECT TOP 2 *
FROM customers
ORDER BY score ASC

-- Get the Two Most Recent Orders
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC

-- Get Top 5 Employees
SELECT TOP 5 emp_name, salary
FROM employees;

-- Top 10% of Salaries
SELECT TOP 10 PERCENT emp_name, salary
FROM employees
ORDER BY salary DESC;

-- Highest salary Employees (MySQL Style)
SELECT emp_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3;
/* ==============================================================================
   All Together
=============================================================================== */

/* Calculate the average score for each country 
   considering only customers with a score not equal to 0
   and return only those countries with an average score greater than 430
   and sort the results by the highest average score first. */
SELECT
    country,
    AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430
ORDER BY AVG(score) DESC

/* ============================================================================== 
   COOL STUFF - Additional SQL Features
=============================================================================== */

-- Execute multiple queries at once
SELECT * FROM customers;
SELECT * FROM orders;

/* Selecting Static Data */
-- Select a static or constant value without accessing any table
SELECT 123 AS static_number;

SELECT 'Hello' AS static_string;

-- Assign a constant value to a column in a query
SELECT
    id,
    first_name,
    'New Customer' AS customer_type

FROM customers;






