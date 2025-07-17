USE MyDatabase

-- FILTERING DATA

-- COMPARISON OPERATOR
-- Retrieve all customer from Germany

SELECT *
FROM customers
WHERE country = 'Germany'

-- Retrieve all customer who are not from Germany
SELECT *
FROM customers 
WHERE country != 'Germany'

-- Retrieve all customer with a score is greater than 500
SELECT *
FROM customers
WHERE score > 500

-- Retrieve all customer with score of 500 and more
SELECT *
FROM customers 
WHERE score >= 500

-- Retrieve all customers with score less than 500
SELECT *
FROM customers
WHERE score < 500

-- Retrieve all customer with score of 500 or less
SELECT * 
FROM customers
WHERE score <= 500

-- LOGICAL OPERATOR 
-- AND
-- Retrieve all customers who are from USA AND have a score greater than 500.
SELECT * 
FROM customers 
WHERE country = 'USA' AND score > 500

-- OR
-- Retrieve all customers who are either from USA OR have a score greter than 500.
SELECT *
FROM customers
WHERE country = 'USA' OR score > 500

-- NOT = "Exclude Matching Rows"
-- Retrieve all customers with a score NOT less than 500
SELECT 
* 
FROM customers
WHERE NOT score < 500


-- RANGE OPERATOR
-- BETWEEN
-- Retrieve all customers whose score falls in the range between 100 and 500
SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500

SELECT *
FROM customers
WHERE score >= 100 AND score <= 500

-- IN/NOT IN OPERATOR
-- Retrieve all customers from either Germany OR USA

SELECT * 
FROM customers
WHERE country = 'Germany' OR country = 'USA'

SELECT * 
FROM customers
WHERE country IN ('Germany', 'USA')


SELECT * 
FROM customers
WHERE country != 'Germany' AND country != 'USA'

SELECT * 
FROM customers
WHERE country NOT IN ('Germany', 'USA')

-- LIKE
-- Find all customers whose first name starts with 'M'
SELECT *
FROM customers 
WHERE first_name like 'M%'

-- Find all customers whose first name ends with 'n'
SELECT *
FROM customers 
WHERE first_name LIKE '%n'

-- Find all customers whose first name contains 'r'
SELECT *
FROM customers 
WHERE first_name LIKE '%r%'

-- Find all customers whose first name has 'r' in the third position
SELECT *
FROM customers 
WHERE first_name LIKE '__r%'
