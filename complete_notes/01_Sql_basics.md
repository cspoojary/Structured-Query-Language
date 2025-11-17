## What is SQL?
SQL (Structured Query Language) is a standard language used to store, manage, and manipulate data in relational databases.

### Definition
SQL is used to interact with relational database systems like MySQL, Oracle, PostgreSQL, SQL Server, etc.

```sql
SELECT * FROM employees;
# SQL command retrieves all records from the employees table.
```
## Types of SQL Commands
SQL commands are grouped into 5 main categories:
- DDL - Data Definition Language - CREATE,ALTER,DROP,TRUNCATE,RENAME
- DML - Data Manipulation Language - INSERT,UPDATE,DELETE
- DQL - Data Query Language - SELECT
- DCL - Data Control Language - GRANT,REVOKE
- TCL - Transaction Control Language - COMMIT,ROLLBACK,SAVPOINT

# SQL vs NoSQL Comparison

  ------------------------------------------------------------------------------
  Feature           SQL (Relational)          NoSQL (Non-relational)
  ----------------- ------------------------- ----------------------------------
  **Type**          Relational                Non-relational

  **Data Format**   Tables (rows & columns)   JSON, documents, key-value, graph

  **Schema**        Fixed                     Flexible

  **Scalability**   Vertical                  Horizontal

  **Example DBs**   MySQL, Oracle, SQL Server MongoDB, Cassandra, Firebase

  **Best for**      Structured data,          Unstructured or semi-structured
                    transactions              data
  ------------------------------------------------------------------------------
