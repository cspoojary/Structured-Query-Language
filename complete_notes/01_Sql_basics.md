## What is SQL?
SQL (Structured Query Language) is a standard language used to store, manage, and manipulate data in relational databases.

### Definition
SQL is used to interact with relational database systems like MySQL, Oracle, PostgreSQL, SQL Server, etc.

```sql
SELECT * FROM employees;
# SQL command retrieves all records from the employees table.
```
### SQL supports operations like:
- Creating databases & tables
- Inserting data
- Querying/filtering results
- Updating and deleting records
- Managing permissions & transactions
### Interview Question
- Q1. What is SQL and why is it used?
- Q2. Name some relational database management systems.
- Q3. What is a table in SQL?
- Q4. What is the difference between a database and a table?
- Q5. Is SQL a programming language or query language? Explain.



---
## Types of SQL Commands
SQL commands are grouped into 5 main categories:
- DDL (Data Definition Language): Defines schema (CREATE, ALTER, DROP).
- DML (Data Manipulation Language): Modify data (INSERT, UPDATE, DELETE).
- DCL (Data Control Language): Permission control (GRANT, REVOKE).
- TCL (Transaction Control Language): Transaction commands (COMMIT, ROLLBACK).
- DQL (Data Query Language): SELECT queries.

----

## Database vs Table
### Database
- A container that stores multiple tables.
- Example: school_db

### Table
- A structured format inside a database that stores data in rows and columns.
- Example table: students

## Schema
- A schema defines the structure of the database:
  - tables
  - columns
  - datatypes
  - constraints
  - relations

## SQL vs NoSQL Comparison
| Feature         | SQL (Relational)                | NoSQL (Non-relational)                        |
|-----------------|---------------------------------|------------------------------------------------|
| **Type**        | Relational                      | Non-relational                                 |
| **Data Format** | Tables (rows & columns)         | JSON, documents, key-value, graph              |
| **Schema**      | Fixed                           | Flexible                                       |
| **Scalability** | Vertical                        | Horizontal                                     |
| **Example DBs** | MySQL, Oracle, SQL Server       | MongoDB, Cassandra, Firebase                   |
| **Best for**    | Structured data, transactions   | Unstructured or semi-structured data           |

----

## SQL Data Types
SQL data types tell the database what kind of data a column can store.
#### They are grouped into 4 main categories:

### 1) Numeric Data Types
Used to store numbers (integer, decimal, floating point).
#### A)Integer Types
| Type       | Description           | Example Value |
| ---------- | --------------------- | ------------- |
| `INT`      | Whole numbers         | 25            |
| `SMALLINT` | Smaller range integer | 120           |
| `BIGINT`   | Very large numbers    | 9876543210    |
| `TINYINT`  | Very small range      | 1             |

#### B) Decimal/Fixed-Point Numbers
Used when exact values are needed (money, measurements).
| Type           | Description                         | Example                  |
| -------------- | ----------------------------------- | ------------------------ |
| `DECIMAL(p,s)` | Exact number with precision & scale | DECIMAL(10,2) → 12345.67 |
- p (precision) = total digits
- s (scale) = digits after decimal

#### C) Floating-Point Numbers
Used for approximate values, scientific calculations.
| Type     | Description      |
| -------- | ---------------- |
| `FLOAT`  | Floating decimal |
| `DOUBLE` | More precision   |

### 2) String / Character Data Types
#### A) CHAR
- Fixed-length
- Fast but wastes memory if text is short
- Example: CHAR(10) always stores 10 characters

#### B) VARCHAR
- Variable-length
- Saves space
- Most commonly used string type

#### C) TEXT / LONGTEXT
Used for large paragraphs or long content.

### 3) Date & Time Data Types
Used for dates, times, and timestamps.
| Type        | Stores                           | Example             |
| ----------- | -------------------------------- | ------------------- |
| `DATE`      | YYYY-MM-DD                       | 2024-01-21          |
| `TIME`      | HH:MM:SS                         | 15:30:00            |
| `DATETIME`  | Date + Time                      | 2024-01-21 15:30:00 |
| `TIMESTAMP` | Auto-stores created/updated time | Auto-generated      |

### 4) Boolean Data Type
| Type                      | Description           |
| ------------------------- | --------------------- |
| `BOOLEAN` or `TINYINT(1)` | True (1) or False (0) |

### 5) Binary Data Types
Used to store files, images, PDFs, audio, etc.
| Type        | Description            |
| ----------- | ---------------------- |
| `BLOB`      | Binary large object    |
| `VARBINARY` | Variable length binary |

### 6) Special Types (Depending on DB)
Some databases support extra types:
| Type       | Description             |
| ---------- | ----------------------- |
| `JSON`     | Stores JSON data        |
| `ENUM`     | Predefined fixed values |
| `UUID`     | Unique identifier       |
| `GEOMETRY` | Spatial data            |
----

## Comments in SQL
Used to explain the SQL code.
```sql
-- This is a comment

/* This is
a multi-line comment */
```
