# MySQL Basic

A popular open source DBMS.

* bought by Oracle
* has an open-source fork, MariaDB

## Common Packages

```bash
mysql
mysql-sever
mysql-devel

mariadb-server
```

secure

```bash
sudo mysql_secure_installation
```

## Files

Config file

* e.g. can change the location of database files

```bash
/etc/my.cnf
```

Database files

* each directory represents a database with the same name
* has some databases by default, like `mysql` and `test`

```bash
/var/lib/mysql/
```

Log

```bash
/var/log/mysqld.log
```

## Network

MySQL uses TCP protocol.

The default port is 3306.

## Basic Commands

Use `mysqladmin`

* if password is omitted, will prompt user to input later

```bash
mysqladmin -u root -p <some-password> <some-commend>
mysqladmin --user=root --password=<some-old-password> password "some-new-password" # change password

mysqldump -R some_db > dump
```

Connect to local mysql server

* -u user
* -p login using password
* -h specify host

```bash
mysql -u <some-user-name> -p
> input your password

mysql -h 192.168.1.1 -u root -p
```

Cannot login unless `sudo`?

[ERROR 1698 (28000): Access denied for user 'root'@'localhost'](https://stackoverflow.com/questions/39281594/error-1698-28000-access-denied-for-user-rootlocalhost)

Log out mysql shell

```sql
mysql>
mysql> quit
```

Sample queries

```sql
SELECT VERSION();
SELECT CURRENT_DATE;

SELECT VERSION(), CURRENT_DATE\g
SELECT VERSION(), CURRENT_DATE\G

SELECT 4+4;
```

Databases commands

```sql
SHOW DATABASES;
USE some_database;

CREATE DATABASE some_database;
DROP DATABASE some_database;
```

[About renaming database](https://stackoverflow.com/questions/67093/how-do-i-quickly-rename-a-mysql-database-change-schema-name)