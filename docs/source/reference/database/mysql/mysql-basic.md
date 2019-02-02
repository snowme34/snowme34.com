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

## Simple Backup

```bash
mysqldump -u root -p some-database-name > some-backup-file-name.sql
mysql -u root -p some-database-name < some-backup-file-name.sql
```

## Character Set and Collation

A database uses specific encoding for the data.

Usually use different encoding for different languages

Why different?

* Storage size
* Communication between database and client

It should be

* The data are stored using the minimum space
* Same char set should be used otherwise the data will be garbled text

### MySQL

Default:

```markdown
char set: latin1
collation: latin1_swedish_ci
```

Char set and collation should be changed in the same time.

List supported char set

```sql
SHOW CHARACTER SET;
```

The most commonly used one is UTF-8.

List environment variables

```sql
SHOW VARIABLES;
```

List current config

```sql
SHOW VARIABLES LIKE 'character_set%';
SHOW VARIABLES LIKE 'collation%';
```

Specify when creating databases

```sql
CREATE DATABASE db DEFAULT CHARACTER_SET utf8 DEFAULT COLLATE utf8_general_ci;
```

Change existing ones

* Note the existing records might not be encoded correctly
* They must be dropped and recreated

```sql
ALTER DATABASE db CHARACTER SET utf8 COLLATE utf8_general_ci;
```

### Default Character Set and Collation Config

The file is located at `/etc/my.cnf`.

```conf
[client]
default-character-set=utf8

[mysql]
default-character-set=utf8

[mysqld]
default-character-set=utf8
collation-server=uft8_unicode_ci
init-connect='SET NAMES utf8'
character-set-server=utf8
```

Reload mysql after changing

[MySQL :: MySQL 8.0 Reference Manual :: 4.2.7 Using Option Files](https://dev.mysql.com/doc/refman/8.0/en/option-files.html)