USE MyDatabase

-- This is comments

/* This 
is a 
comments */


-- Retrieve All Customer Data

 SELECT * 
 FROM customers

 
-- Retrieve All Order Data

 SELECT *
 FROM orders

/* select few columns */
-- Retrieve each customer's Name, Country, and Score.

SELECT 
first_name,
country,
score
FROM customers

/* WHERE = Filter based on your Condition */
-- Retrieve customers with a score not equal to 0

SELECT * 
FROM customers
WHERE score != 0

-- -- Retrieve customers from Germany

SELECT *
FROM customers 
WHERE country = 'Germany'

SELECT 
	first_name,
	country
FROM customers
WHERE country = 'Germany'

/* ORDER BY = SORT YOUR DATA 
ASC OR DESC */
-- Retrieve all customers and sort the result by the highest score first

SELECT *
FROM customers
ORDER BY score DESC

-- Retrieve all customers and sort the result by the lowest score first

SELECT *
FROM customers
ORDER BY  score ASC

/* (Nested) ORDER BY = Sort Your Data using multiple columns*/
-- Retrieve all customers and sort the result by country and then by the highest score

SELECT * 
FROM customers
ORDER BY country ASC, score DESC

/* GROUP BY = Aggregate Your Data : Combines the row with same value */
-- Find total score for each country

SELECT 
	country AS customer_country,
	SUM(score) As Total_score
FROM customers
GROUP BY country /* The result of  GROUP BY determined by the unique values of the grouped columns */

-- Find the total score and total number of customers for each contry
SELECT 
	country AS customer_country,
	SUM(score) As Total_score,
	COUNT(id) AS Total_customers
FROM customers
GROUP BY country

/* HAVING = Filter Aggregated Data
Having can be used only with GROUP BY */
/* Find the average score for each country considering only customers with a score not equal to 0
	And return only thoose countries with an average score greater than 430 */

SELECT 
	country,
	AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430

/* DISTINCT = Removes Duplicates: Each value appears once */
-- Return Unique List of All Countries

SELECT DISTINCT country
FROM customers /* Don't use DISTINCT simply */

/* Top ( Limit) = Restrict Number of Rows Returned
-- Retrieve only 3 customers */

SELECT TOP 3 *
FROM customers

-- Retrieve only 3 customers WITH THE HIGHEST SCORE

SELECT TOP 3 *
FROM customers
ORDER BY score DESC

-- Retrieve lOWEST 2 customers BASED ON SCORE

SELECT tOP 2 * 
FROM customers 
ORDER BY score ASC

-- Get the 2 most recent Orders

SELECT * 
FROM orders

SELECT TOP 2 * 
FROM orders
ORDER BY order_date DESC

/* Everything together one Query
COOL QUERY TECHNIQUE
	MULTI QUERY*/

SELECT * 
FROM customers;

SELECT * 
FROM orders;

-- Static(Fixed) Values

SELECT 123 AS static_number

SELECT 'Hello' AS static_string

SELECT 
	id, 
	first_name,
	'New Customer' AS customer_type
	FROM customers

-- Highlight & Excute

SELECT * 
FROM customers
WHERE country = 'Germany'

SELECT * FROM orders
