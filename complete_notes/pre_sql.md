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
