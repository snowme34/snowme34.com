# SQL

Structured Query Language

A standard of ANSI.

Almost all relational database management systems use SQL.

## What Can SQL Do

* Query database
* Retrieve data
* Insert records
* Update records
* Delete records
* Create new databases
* Create new tables
* Create stored procedures
* Create views
* Config permissions for tables, stored procedures and views

## Versions and Invariants

Unfortunately, there are different versions of SQL.

In addition, the majority of DBMS have their own features or special functionalities.
And those features are usually implemented using SQL.

But the basic grammar is shared.

```sql
SELECT
UPDATE
DELETE
INSERT
WHERE
...
```

## SQL Categories

Data Definition Language (DDL)

* Change the database, usually structure

```sql
CREATE
ALTER
DROP
RENAME
```

Data Manipulation Language (DML)

* Change the content of database

```sql
SELECT
INSERT
UPDATE
DELETE
```

Data Control Language (DCL)

* Privileges

```sql
GRANT
REVOKE
```

Transaction Control (TCL)

* Transaction

```sql
COMMIT
SAVEPOINT
ROLLBACK
```

## Relational

Data are stored using tables (row and column) with specified relationships between them.