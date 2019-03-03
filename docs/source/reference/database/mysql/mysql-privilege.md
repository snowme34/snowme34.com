# MySQL Privilege

## Why Privilege

Access Control is indispensable.

1. whether or not a user is allowed to connect
2. whether or not a user can perform the intended action

## Levels

From [MySQL :: MySQL 8.0 Reference Manual :: 13.7.1.6 GRANT Syntax](https://dev.mysql.com/doc/refman/8.0/en/grant.html)

1. Global
2. Database
3. Table
4. Column
5. Procedure

(6.Proxy)

```sql
priv_level: {
    *
  | *.*
  | db_name.*
  | db_name.tbl_name
  | tbl_name
  | db_name.routine_name
}
```

Flexible

## Commands

`GRANT`

```sql
GRANT ALL PRIVILEGES ON <some_level> TO <some_user>@<some_host> IDENTIFIED BY <some_password>;

GRANT ALL PRIVILEGES ON *.* TO 'me'@'%' IDENTIFIED BY 'MyPass';
GRANT ALL PRIVILEGES ON MyDB.* TO 'you'@'%' IDENTIFIED BY 'YourPass';
GRANT ALL PRIVILEGES ON MyDB.* TO 'another_user_can_grant_permissions'@'localhost' WITH GRANT OPTION;

GRANT SELECT ON YourDB.* TO 'role3';
```

[About 'Identified By Password - StackOverflow'](https://stackoverflow.com/questions/31111847/identified-by-password-in-mysql)

The "host" is the allowed connection source.

* `*@localhost`
  * means only connection from localhost are allowed
* `@%`
  * means any source is allowed
* `one.such.domain`
  * specify a domain
* `*.such.domain`
  * use wildcard
* `0.0.0.0`
  * specify an ip
* `192.168.1.9/255.255.255.0`
  * specify a segment

`REVOKE`

```sql
REVOKE ALL PRIVILEGES FROM user [, user]…
REVOKE ALL PRIVILEGES, GRANT OPTION FROM user [, user]…
```

## Connection Authorization

In order to perform an action, a user must

* connected from specific source
* exist (has a record in mysql)
* give correct authentication credential
* has permission to perform that action on the target

By default, `root` cannot be accessed from connections other than localhost.

Usually we create a specific database and assign the permissions on that database.