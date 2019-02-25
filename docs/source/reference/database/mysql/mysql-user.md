# MySQL User

Client must log in the MySQL as a user.

MySQL uses user for permission of operations.

* Only a user called `root` by default
* The user information is stored in `user` table of database `mysql`

[MySQL :: MySQL 8.0 Reference Manual :: 5.3 The mysql System Schema](https://dev.mysql.com/doc/refman/8.0/en/system-schema.html)

```sql
USE mysql;
DESC user;
SELECT HOST,USER FROM user;
```

## Create a User

```sql
CREATE USER some_user IDENTIFIED BY 'some_password';
```

New user cannot log in due to the lack of privileges.

## Delete a User

```sql
DROP USER some_user;
```

## Rename a User

```sql
RENAME USER some_old_user TO some_new_user;
```

## Change Password

```sql
SET PASSWORD = 'some_auth_string';
SET PASSWORD FOR 'some-user'@'localhost' = 'some_auth_string';
```