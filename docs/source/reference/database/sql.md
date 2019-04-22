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

| Data Type                                              | Usage                              |
| ------------------------------------------------------ | ---------------------------------- |
| integer(size)/int(size), smallint(size), tinyint(size) | store integers (exact value)       |
| decimal(size,d), numeric(size,d)                       | fixed-point (exact value)          |
| float, double                                          | floating-point (approximate value) |
| char(size)                                             | fixed-length                       |
| varchar(size)                                          | variable-length                    |
| date                                                   | date                               |

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

## Table Data

### Insert Records

* either provide all columns
* or specify columns to insert
  * might have some concern with `Null`
  * prefer the later way that specifies the columns since no need to rewrite if adding new columns (can have NULL) in the future

```sql
INSERT INTO table_name VALUES (val_0, val_1, ...);
INSERT INTO table_name (col_a, col_b) VALUES (val_a, val_b);
```

### Lookup Records

```sql
SELECT col_1, col2, ... FROM table_name;
SELECT * FROM table_name;
SELECT * FROM table_name\G

SELECT col FROM table_name WHERE col operator val;
SELECT * FROM course WHERE course_level = 1;
SELECT * FROM course WHERE course_name = 'SQL';
```

#### Aliases

```sql
SELECT salary / 1000.0 AS Salary_in_k
FROM usr_total_salary_cumulative_table AS sa_table;
```

#### Common `WHERE` operators

`WHERE` conditions can be connected using `AND`, `OR`.

For numerical values:

| operator                  | meaning                  |
| ------------------------- | ------------------------ |
| =                         | equal                    |
| <>,!=                     | not equal                |
| >                         | larger than              |
| <                         | smaller than             |
| >=                        | larger than or equal to  |
| <=                        | smaller than or equal to |
| (NOT) BETWEEN ... AND ... | between a range          |
| (NOT) IN (...)            | appear in a list         |

For string values:

| operator       | meaning                             |
| -------------- | ----------------------------------- |
| =              | equal (case-sensitive)              |
| <>,!=          | not equal (case-sensitive)          |
| (NOT) LIKE     | pattern matching (case-insensitive) |
| (NOT) IN (...) | in a list                           |

Generally:

| operator      | meaning    |
| ------------- | ---------- |
| IS (NOT) NULL | NULL check |

Can use `%` to match zero or more characters and `_` to match one character in `LIKE`:

```sql
LIKE "%A%B%"
LIKE "HEA_T"
```

[MySQL :: MySQL 8.0 Reference Manual :: 12.3 Operators](https://dev.mysql.com/doc/refman/8.0/en/non-typed-operators.html)

#### NULL

Note NULL values are generally more tricky to tackle than some "empty" values, like
0 or "". Use NULL with caution.
But if "no data" is a data in specific cases, NULL is a good option.

[MySQL :: MySQL 8.0 Reference Manual :: 3.3.4.6 Working with NULL Values](https://dev.mysql.com/doc/refman/8.0/en/working-with-null.html)

#### Process Results

```sql
SELECT DISTINCT name FROM user;
```

```sql
SELECT * FROM user ORDER BY uid ASC/DESC;

SELECT * FROM user LIMIT 5;                   -- return first 5 user
SELECT * FROM user LIMIT 5 OFFSET 0;          -- return first 5 user (equivalent to above)
SELECT * FROM user LIMIT 5 OFFSET 2;          -- return 3th to 8th user

SELECT * FROM user ORDER BY age DESC LIMIT 5; -- return top 5 oldest user
```

#### JOIN

Try to understand JOINs using venn diagrams.

INNER JOINS:

* INNER JOIN is like `(A ∩ B)`

OUTER JOINs:

* LEFT JOIN is like `A ∪ (A ∩ B)`
* RIGHT JOIN is like `(A ∩ B) ∪ B`
* FULL JOIN is like `A ∪ B`

For LEFT or RIGHT or FULL JOINs, NULL values may be appended to the result
if there is no matching column in "right" or "left" table or "one of" the tables.

Note the `OUTER` keyword is optional.

```sql
...
FROM table_1
INNER JOIN table_2               -- INNER JOIN is default JOIN
    ON table_1.id = table_2.id
...
```

See *end of this page* for examples.

This page has some good discussions on JOINs: [MySQL FULL JOIN? - Stack Overflow](https://stackoverflow.com/questions/7978663/mysql-full-join/36001694)

#### Aggregate and Group Results

Group function generally ignore NULL values.

`GROUP BY` will group rows based on unique values in the specified columns.

Use `HAVING` to filter grouped rows (think it as the `WHERE` of `GROUP BY`).

```sql
SELECT region, SUM(salary) AS salary_sum FROM usr
GROUP BY region
HAVING region LIKE "US-%";  -- assume regions are like US-AL, US-AK, US-CA, ..., CA-ON, ...
```

Common group functions:

| function        | usage                 |
| --------------- | --------------------- |
| AVG()           | average               |
| COUNT()         | count                 |
| COUNT(DISTINCT) | count distinct values |
| MAX()           | max                   |
| MIN()           | min                   |
| STD()           | standard deviation    |
| SUM()           | sum                   |
| VARIANCE()      | variance              |

Group function generally ignore NULL values.

[MySQL :: MySQL 8.0 Reference Manual :: 12.20.1 Aggregate (GROUP BY) Function Descriptions](https://dev.mysql.com/doc/refman/8.0/en/group-by-functions.html)

#### SELECT Overview

From [MySQL :: MySQL 8.0 Reference Manual :: 13.2.10 SELECT Syntax](https://dev.mysql.com/doc/refman/8.0/en/select.html):

```sql
SELECT
    [ALL | DISTINCT | DISTINCTROW ]
      [HIGH_PRIORITY]
      [STRAIGHT_JOIN]
      [SQL_SMALL_RESULT] [SQL_BIG_RESULT] [SQL_BUFFER_RESULT]
      [SQL_NO_CACHE] [SQL_CALC_FOUND_ROWS]
    select_expr [, select_expr ...]
    [FROM table_references
      [PARTITION partition_list]
    [WHERE where_condition]
    [GROUP BY {col_name | expr | position}, ... [WITH ROLLUP]]
    [HAVING where_condition]
    [WINDOW window_name AS (window_spec)
        [, window_name AS (window_spec)] ...]
    [ORDER BY {col_name | expr | position}
      [ASC | DESC], ... [WITH ROLLUP]]
    [LIMIT {[offset,] row_count | row_count OFFSET offset}]
    [INTO OUTFILE 'file_name'
        [CHARACTER SET charset_name]
        export_options
      | INTO DUMPFILE 'file_name'
      | INTO var_name [, var_name]]
    [FOR {UPDATE | SHARE} [OF tbl_name [, tbl_name] ...] [NOWAIT | SKIP LOCKED] 
      | LOCK IN SHARE MODE]]
```

### Delete Records

```sql
DELETE FROM table_name WHERE col operator val;
DELETE * FROM table_name;
```

### Update Records

```sql
UPDATE table_name SET col_to_change = new_value WHERE col_identify = val;
UPDATE course SET lecture = 'Math' WHERE id = 1;
```

## Example Query

Example for JOINs and some constrains:

Table `usr`:

| uid | name     |
| --- | -------- |
| 1   | "u1"     |
| 2   | "hello"  |
| 3   | "root"   |
| 4   | "admin"  |
| 5   | "ha-ha"  |
| 6   | "legend" |

```sql
CREATE TABLE usr (
  uid INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (uid)
);
INSERT INTO usr (name) VALUES ("u1");
INSERT INTO usr (name) VALUES ("hello");
INSERT INTO usr (name) VALUES ("root");
INSERT INTO usr (name) VALUES ("admin");
INSERT INTO usr (name) VALUES ("ha-ha");
INSERT INTO usr (name) VALUES ("legend");
```

Table `records`:

| id  | uid  | content  |
| --- | ---- | -------- |
| 1   | 1    | "test"   |
| 2   | 1    | "test"   |
| 3   | 1    | "test"   |
| 4   | 1    | "test"   |
| 5   | 2    | "abc"    |
| 6   | 3    | "cloud"  |
| 7   | 2    | "train"  |
| 8   | 4    | "room"   |
| 9   | 1    | "noodle" |
| 10  | 1024 | "hacked" |

```sql
CREATE TABLE records (
  id INT NOT NULL AUTO_INCREMENT,
  uid INT NOT NULL,
  content VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id)
);
INSERT INTO records (uid, content) VALUES (1, "test");
INSERT INTO records (uid, content) VALUES (1, "test");
INSERT INTO records (uid, content) VALUES (1, "test");
INSERT INTO records (uid, content) VALUES (1, "test");
INSERT INTO records (uid, content) VALUES (2, "abc");
INSERT INTO records (uid, content) VALUES (3, "cloud");
INSERT INTO records (uid, content) VALUES (2, "train");
INSERT INTO records (uid, content) VALUES (4, "room");
INSERT INTO records (uid, content) VALUES (1, "noodle");
INSERT INTO records (uid, content) VALUES (1024, "hacked");
```

Table `constrained_records`:

| id  | uid | content  |
| --- | --- | -------- |
| 1   | 1   | "test"   |
| 2   | 1   | "test"   |
| 3   | 1   | "test"   |
| 4   | 1   | "test"   |
| 5   | 2   | "abc"    |
| 6   | 3   | "cloud"  |
| 7   | 2   | "train"  |
| 8   | 4   | "room"   |
| 9   | 1   | "noodle" |

```sql
CREATE TABLE constrained_records (
  id INT NOT NULL AUTO_INCREMENT,
  uid INT NOT NULL,
  content VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (uid) REFERENCES usr(uid)
);
INSERT INTO constrained_records (uid, content) VALUES (1, "test");
INSERT INTO constrained_records (uid, content) VALUES (1, "test");
INSERT INTO constrained_records (uid, content) VALUES (1, "test");
INSERT INTO constrained_records (uid, content) VALUES (1, "test");
INSERT INTO constrained_records (uid, content) VALUES (2, "abc");
INSERT INTO constrained_records (uid, content) VALUES (3, "cloud");
INSERT INTO constrained_records (uid, content) VALUES (2, "train");
INSERT INTO constrained_records (uid, content) VALUES (4, "room");
INSERT INTO constrained_records (uid, content) VALUES (1, "noodle");
```

Queries:

```sql
SELECT *
FROM usr
  JOIN records
  ON usr.uid = records.uid;
```

| uid | name  | id  | uid | content |
| --- | ----- | --- | --- | ------- |
| 1   | u1    | 1   | 1   | test    |
| 1   | u1    | 2   | 1   | test    |
| 1   | u1    | 3   | 1   | test    |
| 1   | u1    | 4   | 1   | test    |
| 2   | hello | 5   | 2   | abc     |
| 3   | root  | 6   | 3   | cloud   |
| 2   | hello | 7   | 2   | train   |
| 4   | admin | 8   | 4   | room    |
| 1   | u1    | 9   | 1   | noodle  |

```sql
SELECT *
FROM usr
  RIGHT JOIN records
  ON usr.uid = records.uid;
```

| uid  | name  | id  | uid  | content |
| ---- | ----- | --- | ---- | ------- |
| 1    | u1    | 1   | 1    | test    |
| 1    | u1    | 2   | 1    | test    |
| 1    | u1    | 3   | 1    | test    |
| 1    | u1    | 4   | 1    | test    |
| 2    | hello | 5   | 2    | abc     |
| 3    | root  | 6   | 3    | cloud   |
| 2    | hello | 7   | 2    | train   |
| 4    | admin | 8   | 4    | room    |
| 1    | u1    | 9   | 1    | noodle  |
| NULL | NULL  | 10  | 1024 | hacked  |

```sql
SELECT *
FROM usr
  LEFT JOIN records
  ON usr.uid = records.uid;
```

| uid | name   | id   | uid  | content |
| --- | ------ | ---- | ---- | ------- |
| 1   | u1     | 1    | 1    | test    |
| 1   | u1     | 2    | 1    | test    |
| 1   | u1     | 3    | 1    | test    |
| 1   | u1     | 4    | 1    | test    |
| 2   | hello  | 5    | 2    | abc     |
| 3   | root   | 6    | 3    | cloud   |
| 2   | hello  | 7    | 2    | train   |
| 4   | admin  | 8    | 4    | room    |
| 1   | u1     | 9    | 1    | noodle  |
| 5   | ha-ha  | NULL | NULL | NULL    |
| 6   | legend | NULL | NULL | NULL    |

Note MySQL does not (yet) support `FULL JOIN`

```sql
SELECT *
FROM usr
  FULL JOIN records
  ON usr.uid = records.uid;
```

| uid  | name   | id   | uid  | content |
| ---- | ------ | ---- | ---- | ------- |
| 1    | u1     | 1    | 1    | test    |
| 1    | u1     | 2    | 1    | test    |
| 1    | u1     | 3    | 1    | test    |
| 1    | u1     | 4    | 1    | test    |
| 2    | hello  | 5    | 2    | abc     |
| 3    | root   | 6    | 3    | cloud   |
| 2    | hello  | 7    | 2    | train   |
| 4    | admin  | 8    | 4    | room    |
| 1    | u1     | 9    | 1    | noodle  |
| NULL | NULL   | 10   | 1024 | hacked  |
| 5    | ha-ha  | NULL | NULL | NULL    |
| 6    | legend | NULL | NULL | NULL    |

```sql
INSERT INTO constrained_records (uid, content) VALUES (1323, "random");
```

This will fail the foreign key constrain.

## Read More

[SQL left join vs multiple tables on FROM line? - Stack Overflow](https://stackoverflow.com/questions/894490/sql-left-join-vs-multiple-tables-on-from-line)