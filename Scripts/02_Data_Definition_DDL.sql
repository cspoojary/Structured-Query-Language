/* ==============================================================================
   SQL Data Definition Language (DDL)
-------------------------------------------------------------------------------
   This guide covers the essential DDL commands used for defining and managing
   database structures, including creating, modifying, and deleting tables.

   Table of Contents:
     1. CREATE - Creating Tables
     2. ALTER - Modifying Table Structure
     3. DROP - Removing Tables
=================================================================================
*/

/* ============================================================================== 
   CREATE
The CREATE statement** is used to create new objects** in a database such as:
Tables
Databases
Views
Procedures
Functions
=============================================================================== */
-- CREATE DATABASE
CREATE DATABASE company_db;
-- CREATE TABLE
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    job_title VARCHAR(50),
    salary DECIMAL(10,2),
    joining_date DATE
);
-- CREATE VIEW
-- Creates a virtual table (saved query):
CREATE VIEW high_salary_employees AS
SELECT emp_name, salary
FROM employees
WHERE salary > 60000;

-- CREATE VIEW
-- Creates a virtual table (saved query):
CREATE VIEW high_salary_employees AS
SELECT emp_name, salary
FROM employees
WHERE salary > 60000;

/* Create a new table called persons 
   with columns: id, person_name, birth_date, and phone */
CREATE TABLE persons (
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
)

/* ============================================================================== 
   ALTER
The ALTER command is used to modify the structure of an existing table —
for example, to add, delete, or change columns or constraints.
It doesn’t delete data — it just changes the table design.
=============================================================================== */
-- Basic Syntax
ALTER TABLE table_name
action;
/*
ADD column
DROP column
MODIFY column or ALTER COLUMN
RENAME COLUMN
ADD CONSTRAINT or DROP CONSTRAINT
*/

-- Add a New Column
ALTER TABLE employees
ADD job_title VARCHAR(50);

-- Modify Data Type or Size
ALTER TABLE employees
MODIFY salary DECIMAL(12,2);

-- Rename a Column
ALTER TABLE employees
RENAME COLUMN emp_name TO employee_name;

-- Drop a Column
ALTER TABLE employees
DROP COLUMN job_title;

-- Add a Constraint (e.g., Foreign Key)
ALTER TABLE employees
ADD CONSTRAINT fk_dept
FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Rename a Table
ALTER TABLE employees
RENAME TO staff;

-- Add a new column called email to the persons table
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL

-- Remove the column phone from the persons table
ALTER TABLE persons
DROP COLUMN phone

/*
Create table	   CREATE TABLE employees (...);
Add column	      ALTER TABLE employees ADD department VARCHAR(50);
Modify column	   ALTER TABLE employees MODIFY emp_name VARCHAR(100);
Rename column	   ALTER TABLE employees RENAME COLUMN salary TO monthly_salary;
Add constraint	   ALTER TABLE employees ADD CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id);
Drop column	      ALTER TABLE employees DROP COLUMN department;
Rename table	   ALTER TABLE employees RENAME TO company_staff;
*/

/* ============================================================================== 
   DROP
The DROP command is used to delete entire database objects — such as a table, database, view, column, or constraint — permanently.
Once you DROP something, all data and structure are gone — you can’t undo it (unless you have a backup).
=============================================================================== */
-- Syntax
DROP object_type object_name;

-- DROP TABLE
-- Completely deletes a table and all its data.
DROP TABLE employees;

-- DROP DATABASE
-- Deletes the entire database (all tables, data, views, etc.).
DROP DATABASE company_db;

-- DROP COLUMN
-- Used with ALTER TABLE to remove a specific column.
ALTER TABLE employees
DROP COLUMN job_title;

-- DROP CONSTRAINT
-- Removes a constraint like a foreign key, primary key, or unique rule.
ALTER TABLE employees
DROP CONSTRAINT fk_dept;

-- DROP VIEW
-- Removes a view (virtual table).
DROP VIEW high_salary_employees;

-- DROP INDEX
-- Deletes an index created for faster searching.
DROP INDEX idx_emp_name;

