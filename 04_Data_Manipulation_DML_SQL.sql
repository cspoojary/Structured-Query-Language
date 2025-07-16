USE MyDatabase


INSERT INTO customers (id, first_name,country, score)
VALUES
	(6, 'Anna','USA',NULL),
	(7, 'Sam',NULL,100)

SELECT * FROM customers
	
INSERT INTO customers (id, first_name,country, score)
VALUES
	(8, 'USA','Max',NULL)

INSERT INTO customers(id, first_name)
VALUES
	(9, 'Andreas','Germany',NULL)
	
INSERT INTO customers(id, first_name)
VALUES
	(9, 'Andreas')

SELECT * FROM customers

/* INSERTING DATA INTO TABLE BY FETCHING DATA BY ANOTHER TABLE */
-- Copy data from 'customers' table into 'persons'

INSERT INTO persons(id, person_name, birth_date, phone)
SELECT
id,
first_name,
NULL,
'Unknown'
FROM customers

SELECT * FROM persons

/* UPDATE */
-- Change the score of customers with ID 6 to 0
SELECT *
FROM customers
WHERE id = 6

UPDATE customers
SET score = 0
WHERE id = 6


SELECT *
FROM customers

-- Change the score of customer with ID 10 to 0 and update the country to 'UK'

UPDATE customers
SET score = 0,
	country = 'UK'
WHERE id =9

SELECT *
FROM customers

-- Update all customers with a NULL score by setting their score to 0 */
UPDATE customers 
SET score = 0
WHERE score IS NULL

SELECT *
FROM customers

/* DELETE */

-- Delete all customers with an ID greater than 5
SELECT *
FROM customers
WHERE id > 5

DELETE FROM customers
WHERE id > 5

SELECT * 
FROM customers

-- Delete all data from the persons table

DELETE FROM persons

TRUNCATE TABLE persons