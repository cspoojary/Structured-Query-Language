/* Create a  new table called persons with columns; id, person_name, burth_date, and phone */


Use MyDatabase

CREATE TABLE persons(
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE NULL,
	phone VARCHAR(15) NOT NULL,
 CONSTRAINT pk_persons PRIMARY KEY (id) 
)

SELECT * 
FROM persons

-- Add a new column called email to the persons table

ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL

SELECT * FROM persons

-- Remove a Table called phone from the table persons

ALTER TABLE persons
DROP COLUMN phone

SELECT * FROM persons

/* DROP */
-- Delete the table person from the database

DROP TABLE persons