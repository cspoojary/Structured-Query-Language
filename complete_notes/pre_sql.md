# Definition and Evolution
---
## File Systems to DBMS to RDBMS
**A Database Management System (DBMS) is software designed to manage, retrieve, and run queries on data in a database.**

**File Systems:** The earliest method, where data was stored in individual files. This led to problems like data redundancy (same data stored multiple times), inconsistency, and difficulty in data access and sharing.

**DBMS:** Evolved from file systems to centrally manage data, offering features like data security, concurrency, and integrity.

**RDBMS (Relational Database Management System):** A specific type of DBMS based on the Relational Model (developed by E.F. Codd in 1970). It organizes data into tables (relations), which are linked by common fields, providing a logical, structured way to store and query data using SQL.

---
## Database Architecture
**Database architecture describes how the database system components are distributed and interact.**

**1-Tier Architecture:** The database, the DBMS, and the client application all reside on the same machine. Used mostly for development and testing.

**2-Tier Architecture (Client-Server):** The application (client) resides on one machine and communicates directly with the database (server) on another machine. It's often used in Local Area Networks (LANs).

**3-Tier Architecture:** Introduced a middle layer (an Application Server or business logic tier) between the client (presentation tier) and the database (data tier). This is standard for modern web applications, improving scalability, security, and maintainability.
RDBMS Term,Common Alias,Description

---
## Key Concepts in the Relational Model
### RDBMS Fundamental Concepts

The structure of a Relational Database Management System (**RDBMS**) is built upon these core concepts, organizing data into a logical, structured format.

| RDBMS Term | Common Alias | Description |
| :--- | :--- | :--- |
| **Table** | **Relation** | A collection of related data, organized in rows and columns. |
| **Row** | **Tuple** / **Record** | A single entry in a table, representing a single, complete set of data (e.g., one customer's details). |
| **Column** | **Attribute** / **Field** | A vertical entity in a table, representing a specific type of data for every row (e.g., Customer Name). |

### Key Takeaway

* The **Table (Relation)** is the main container.
* The **Row (Tuple/Record)** represents a unique instance of the data within the table.
* The **Column (Attribute/Field)** defines the structure and type of data held by the table.
---

## Keys and Data Integrity
Keys are attributes (columns) used to uniquely identify rows and establish relationships between tables, ensuring data integrity.

**Primary Key:** A column or set of columns that uniquely identifies every row in a table. Its values must be UNIQUE and NOT NULL (essential for data integrity).

**Foreign Key:** An attribute in one table that refers to the Primary Key of another table. It is used to link the two tables and enforce Referential Integrity—ensuring that a relationship exists and is valid (e.g., you cannot reference a non-existent customer ID).

---
## What is MYSQL?
MySQL is an open-source Relational Database Management System (RDBMS) used to store, manage, and retrieve data.
It uses SQL (Structured Query Language) to communicate with the database.

#### It is widely used in:
- Web applications
-  Data analytics
-  E-commerce platforms
- Enterprise applications
- Companies like Facebook, YouTube, Netflix, Twitter use MySQL.

### Key Features
1. Open Source
   - MySQL is free to use and modify, which makes it popular for startups and developers.
2. Relational Database
   - Data is stored in tables (rows & columns) with clear relationships.
3. High Performance
   - MySQL is optimized for:
      - Fast read/write operations
      - Handling large databases
      - High-traffic applications
4. Scalability
   - MySQL supports:
      - Millions of rows
      - Large number of concurrent users
      - Horizontal and vertical scaling

5. Security
   - MySQL provides:
      - User authentication
      - Encrypted passwords
      - Access control (GRANT, REVOKE)

6. Cross-Platform Support
   - It works on:
      - Windows
      - Linux
      - macOS
      - Cloud platforms (AWS, Azure, GCP)

7. ACID Compliance
   - Ensures reliable transactions:
      - Atomicity
      - Consistency
      - Isolation
      - Durability
   - Ensures banking and financial data accuracy.

8. Replication Support
   - MySQL supports:
      - Master–slave replication
      - Master–master replication
   - Used for:
      - High availability
      -Load balancing

9. Stored Procedures, Triggers, Views
   - MySQL supports database programming:
      - Stored procedures → reusable SQL blocks
      - Triggers → automatic actions on events
      - Views → virtual tables for simplified queries

10. Supports Multiple Storage Engines
   - Most important engines:
      - InnoDB → default, supports transactions, foreign keys
      - MyISAM → fast reads
      - Memory → stores data in RAM for speed

11. Backup & Recovery
   - MySQL allows:
      - Logical backups (mysqldump)
      - Physical backups
      - Point-in-time recovery
12. Easy Integration
   - Works with:
      - Python
      - Java
      - PHP
      - Node.js
      - .NET
---

## Database Constraints
Constraints are rules enforced on data columns to limit the type of data that can be inserted or updated, ensuring the accuracy and reliability of the data.
**NOT NULL:** Ensures that a column cannot have a NULL value.
**UNIQUE:** Ensures that all values in a column are different. A table can have multiple UNIQUE constraints.
**DEFAULT:** Provides a default value for a column when a value is not explicitly specified during insertion.
**CHECK:** Allows specifying a condition that must be satisfied by all values in a column (e.g., age $> 18$).
**Constraint Enforcement and Violation Handling:** When an SQL command (INSERT, UPDATE, DELETE) attempts to violate a defined constraint (e.g., trying to insert a NULL value into a NOT NULL column), the DBMS rejects the operation and returns an error, preserving the integrity of the data.

---

## Normalization

**Normalization** is a systematic process for designing a relational database. Its goal is to restructure tables to **reduce data redundancy** and improve **data integrity** by decomposing large, complex tables into smaller, well-structured ones.

### Purpose

* **Reduce Redundancy:** Prevents storing the same piece of information multiple times, saving space and improving efficiency.
* **Eliminate Anomalies:** Prevents data inconsistencies that arise from redundancy:
    * **Insertion Anomaly:** Cannot insert data for a new entity without data for another dependent entity.
    * **Deletion Anomaly:** Deleting data for one entity unintentionally deletes data for another related entity.
    * **Update Anomaly:** Updating a piece of data requires updating multiple rows, and failure to update all copies leads to inconsistency.
* **Logical Dependency:** Ensures data dependencies are clear and logical (i.e., every non-key attribute is dependent on the whole key).

---

### Normal Forms (Progressive Stages)

| Normal Form | Requirement | Focus/Eliminates |
| :--- | :--- | :--- |
| **1NF (First Normal Form)** | Every attribute must contain only **atomic (indivisible)** values, and there are **no repeating groups** of columns. | Repeating Groups |
| **2NF (Second Normal Form)** | Must be in **1NF**, and all non-key attributes must be **fully dependent on the entire Primary Key**. | Partial Dependency |
| **3NF (Third Normal Form)** | Must be in **2NF**, and there should be **no transitive dependency** (non-key attributes should not depend on other non-key attributes). | Transitive Dependency |
| **BCNF (Boyce-Codd Normal Form)** | A stricter version of 3NF. For every non-trivial functional dependency $X \rightarrow Y$, $X$ must be a **Super Key**. | Anomalies due to overlapping Candidate Keys |

---

##  Entity-Relationship (E-R) Modeling

**E-R Modeling** is a high-level conceptual data model used to describe the data requirements of a system. It provides a visual, diagrammatic approach to represent the structure of the data.

### ER Diagrams (ERDs)

An **ER Diagram** is the visual representation of the E-R Model, using specific symbols:

* **Entities:** Real-world objects or concepts that have independent existence (e.g., *Customer*, *Product*, *Order*).
    * **Representation:** Rectangles.
* **Attributes:** Properties or characteristics that describe an entity (e.g., *Customer Name*, *Product Price*, *Order Date*).
    * **Representation:** Ovals.
* **Relationships:** Associations or links between entities (e.g., *A Customer **places** an Order*).
    * **Representation:** Diamonds.

### Cardinality (Types of Relationships)

Cardinality defines the number of instances of one entity that can be associated with the number of instances of another entity.

| Type | Description | Example |
| :--- | :--- | :--- |
| **1:1 (One-to-One)** | An instance of entity A is related to at most one instance of entity B, and vice-versa. | One Employee is assigned One Company Car. |
| **1:N (One-to-Many)** | An instance of entity A can be related to multiple instances of entity B, but an instance of B is related to only one instance of A. | One Department has Many Employees. |
| **N:M (Many-to-Many)** | An instance of entity A can be related to multiple instances of entity B, and vice-versa. | Many Students enroll in Many Courses. |
























 
