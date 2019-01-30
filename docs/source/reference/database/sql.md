# SQL

Structured Query Language

A standard of ANSI.

Almost all relational database management systems use SQL.

This reference focuses on MySQL.

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

## Database Management

Create

```sql
CREATE DATABASE aaa;
```

Delete

```sql
DROP DATABASE aaa;
```

## Table

Each column is an attribute

Each row is a record

Common Data Types

| Data Type                                                 | Usage                              |
| --------------------------------------------------------- | ---------------------------------- |
| integer(size) or int(size), smallint(size), tinyint(size) | store integers (exact value)       |
| decimal(size,d), numeric(size,d)                          | fixed-point (exact value)          |
| float, double                                             | floating-point (approximate value) |
| char(size)                                                | fixed-length                       |
| varchar(size)                                             | variable-length                    |
| date                                                      | date                               |

[MySQL Data Types](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)

`char(10)` means a string with length 10.

`varchar(10)` where 10 is the max length. Usually 100 or 255.

Must provide data type when creating the tables.

Create a table

* Usually there is a "ID" column.
* the last column does not need a comma
* [MySQL :: MySQL 8.0 Reference Manual :: 13.1.20 CREATE TABLE Syntax](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)

```sql
CREATE TABLE some_table_name
(
some_col_name some_data_type,
some_col_name some_data_type,
some_col_name some_data_type,
...
);
```

Check table

```sql
DESCRIBE aaa;
DESC aaa;
```

In the output of `DESC`,

* Field means the column names, i.e. the attributes
* Type is type
* Null is if the cells in this column can be Null
* Key is whether this column will be used as a key column
* Default is the default value

Delete table

```sql
DROP aaa;
```

Modify table

```sql
ALTER TABLE aaa RENAME bbb;

ALTER TABLE aaa ADD ccc some_type;

ALTER TABLE aaa DROP COLUMN ccc;

ALTER TABLE aaa MODIFY ccc some_new_type;

ALTER TABLE aaa CHANGE COLUMN ccc some_new_name some_new_type;
```