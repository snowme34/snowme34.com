# MySQL Misc

## Basic

### Modifications

Both `CHANGE` and `MODIFY` can change table columns.

`CHANGE` requires developer to write column twice but it can change the name of column.

`MODIFY` can do anything `CHANGE` can do except changing the column name.

```sql
ALTER TABLE table_name CHANGE COLUMN old_col_name new_col_name column_definition [FIRST|AFTER col_name];
```

In the command above, if not wishing to change col name, developer needs to write the same name twice.

### Read

```sql
SELECT * FROM table_name
[WHERE]
[ORDER BY field1 [DESC|ASC], field2 [DESC|ASC], ..., fieldn [DESC|ASC]]
[LIMIT offset_start, row_count];

SELECT [field1, field2, ..., fieldn]
fun_name                            -- {sum, count, max, min, ...}, aggregate functions
FROM table_name
[WHERE where_condition]
[GROUP BY field1, field2, fieldn    -- what columns are to classified
[WITH ROLLUP]]                      -- optional, means if we need to aggregate the result again
[HAVING where_condition];           -- filter the result again, after the aggregation. Prefer WHERE since it is done before aggregation
                                    -- https://stackoverflow.com/questions/2905292/where-vs-having

SELECT * FROM t1
UNION|UNION ALL
SELECT * FROM t2
...
UNION|UNION ALL
SELECT * FROM tn;                   -- union the results together, UNION is UNION ALL plus DISTINCT

SELECT * FROM dba where id in       -- in, not in, =, !=, exists, not exists
(SELECT id from idbase);

select ename, dname from d right join edb on d.id=e.id;
```

## Master-Slave Replication

store DDL,DML of master to Binlog

config sync_binlog for this setting

Master: Binlog Dump
Slave: I/O thread, MySQL thread

1. slave create I/O thread asking for data from master
2. master create Binlog Dump thread to read Binlog and send to slave
3. slave receive and store the data to Relay Log
4. SQL thread read the relay log and "redo" all the DDL and DML

note that the replication of MySQL is asynchronous, resulting somewhat delay.
Thus, data require real-time access may (only) be queried from the master, not the slave,
to make sure they are latest.

```sql
SHOW PROCESSLIST\G
SHOW SLAVE STATUS\G
SHOW VARIABLES LIKE '%binlog_format';
```

### Files Involved

Binlog includes Create, Drop, Insert, Update, Delete etc. but no Select.

There are 3 formats of Binlog:

1. Row
    * based on rows, very detailed, but not storing original SQL
    * will not lead to data inconsistency due to different store process or different triggers
    * much more log lines than Statement's
2. Statement
    * based on each SQL statements, every such SQL that changes something will be stored
3. Mixed
    * mixture of 2 above. use statement by default but use Row sometimes, e.g. Time and User operation

[MySQL 8.0 Doc - binlog formats](https://dev.mysql.com/doc/refman/8.0/en/binary-log-formats.html)

Relay log is identical to Binlog but SQL thread will delete the lines executed.

*master.info
  status of reading Binlog
*relay-log.info
  status of executing Relay log

[MySQL 8.0 Document for .info Files](https://dev.mysql.com/doc/refman/8.0/en/slave-logs-status.html)

check the status of update and log

```sql
SHOW BINLOG EVENTS IN 'ip83-bin.000003' from 6912\G
```

note that the event name and lines come from the master.info or the `show slave status;`

can use `mysqlbinlog` tool to analyze

```bash
mysqlbinlog -vv ip83-bin.000003 --base64-output=DECODE-ROWS -- start-pos=7169
```

change **global** setting (can also change current session setting, which may cause unexpected results)

```sql
set global binlog_format = 'ROW';
```

### Replication Structure

1. one master multiple slave
    * when encountering error, any one of the slaves can be used
2. multiple layer replication
    * add Master2 between Master1 and slaves
    * Master1 only push the Binlog
    * Master2 can use BLACKHOLE engine so that it only produces Binlog to decrease the delay (Master2 does not read/write at all)
3. Dual Master
    * use something like floating virtual IP to send write/read request to one and read requests to another.
    * this two replication will be bidirectional
    * Use this for daily maintenance to avoid extra work for building slave database:
      * stop slave on master1
      * stop slave on master2
      * afterwards we can do maintenance like creating index
      * afterwards start slave on master2 to let it sync
      * then switch app's write/read operations to master2
      * finally after making sure no app request on master1, START SLAVE on master1

We can also use Dual Master together with Master/Slave: config slaves under master2 and make master1 a slave of those slaves.

Note that MySQL only execute Binlog with different server id. Even with log_slave_updates on, no cycle replication is possible.

### Set up Master-Slave Asynchronous Replication

Master and slave can be on different servers or same server (multiple MySQL threads).

Make sure latest stable **same** versions of MySQL are installed.

```sql
GRANT REPLICATION SLAVE ON *.* TO 'rep1'@'192.168.123.321' IDENTIFIED BY 'some-password'; -- create an account with permission
```

Change `my.cnf` of master, enable BINLOG and set `server-id`.

```conf
[mysqld]
log-bin = /home/mysql/log/mysql-bin.log
server-id = 1
```

Restart service to apply changes.

Set read lock to avoid database operation, producing a consistent snapshot.

```sql
flush tables with read lock;
```

Get binary log name and position to start recovering from here.

```sql
show master status;
```

Now the master has already suspended update operation, it's the time to generate backup of master database.

There are multiple ways to backup, it is possible by merely coping all the data files or `mysqldump` or use a tool called `ibbackup`.

If it is possible to stop the service, direct coping files is the fastest way.

```bash
tar -scv data.tar data
```

Now we can resume write operation.

```sql
unlock tables;
```

Recover all the data to the slave databases.
If we just tar the whole data, extract it to the corresponding directory is sufficient.

```bash
tar -svf data.tar ???
```

Change my.cnf of slave db, add a `server-id`. note that this must be unique and different the one of master.

If multiple servers are present, no duplication is allowed.

```conf
[mysqld]
server-id = 2
```

Use `--skip-slave-start` flag to start slave db, making it easier for us to config the service.

```bash
./bin/mysqld_safe --skip-slave-start &
```

Config the slave server.

```sql
CHANGE MASTER TO
MASTER_HOST='theName, like 192.168.7.7'
MASTER_PORT=3306
MASTER_USER='theUser'
MASTER_PASSWORD='someSecret'
MASTER_LOG_FILE='recorded log file name, like mysql-bin.000039'
MASTER_LOG_POS='recorded log position, like 102'
```

Now it's time to start the slave.

```sql
start slave
```

Check if it is running properly:

```sql
show processlist;                   -- run on slave
use test; # on master
create table repl_test (id cnd);
insert into repl_test values(1),(2);
use test; # on slave
show tables; 
select * from repl_test;
```

This is the easiest situation.
There is no dependencies of the 3 threads mentioned above.
As long as Binlog is kept, the data is safe.

* If the server is down, DBA can use `mysqlbinlog` to manually add the Binlog to the database
* Or we can use "Master High Availability Manager and tools for MySQL"(MHA) to extract the missing parts automatically
* We may also enable global transaction identifiers(GTID) feature to automatically extract the data, a feature of MySQL 5.6

When the transaction (or SQL statements) is submitted but the lock is not released yet,
the transaction(or SQL statements) will be logged into Binlog.

For the engine supporting transaction, all the submission of transactions are recorded;
for others, all the SQL statements are recorded after execution.
MySQL use `sync_binlog` to control the rate of Binlog's refreshing/updating to the disk.

```sql
show variables like '%sync_binlog%';
```

By default, `sync_binlog=0` means MySQL does not control and hand it to the file system.

If set to be 1, MySQL will store the binlog to disk each time.
Then at most one transaction can be missed.

But this is very expensive I/O operation.
Normally, this value should not be 1.

--------------------------------

In order to protect binlog better, MySQL introduces Semi-synchronous Replication.

### Semi-Synchronous Replication

Available after MySQL 5.5.

After each successful submission of transaction,
Mater will wait for any one of the slaves to receive Binlog and successfully write to Relay Log
before respond the commit to the client.

This ensures that there are at least 2 log entries for each successful transaction.

1. client commit
2. master execute
3. master reproduce binary log
4. master send transaction to slave
5. slave write relay log
6. master get acknowledgement
7. master send acknowledgement to client

If server is down during 1,2,3, the data will be still consistent.

If server is down during 4, master will wait for 'rpl_semi_sync_master_timeout',
then MySQL automatically switch to asynchronous mode and return the result to client normally.

This mode depends on the network between master and slave. Less RTT(Round-Trip Time) is better.

This is achieved by a plug-in of MySQL 5.5.
Master and slave use different versions of this plus-in.

First, make sure the `dynamic_loading` plug-in is supported.

```sql
select @@have_dynamic_loading;
```

Then check if the plug-in is available.

```bash
ls -la $MYSQL_HOME/lib/plugin/semisync_master.so
ls -la $MYSQL_HOME/lib/plugin/semisync_slave.so
```

install corresponding plug-ins to master and slave

```sql
install plugin rpl_semi_sync_master SONAME 'semisync_master.so'; -- master
install plugin rpl_semi_sync_master SONAME 'semisync_slave.so';  -- slave
select * from mysql.plugin;
```

MySQL will record the plugin and automatically load them after the next reboot.

Config the servers:

```sql
set global rpl_semi_sync_master_enabled=1;      -- master
set global rpl_semi_sync_master_timeout=300000;
```

```sql
set global rpl_semi_sync_slave_enabled=1;       -- slave
```

If the previous config is asynchronous, we need to restart I/O thread.
If not, restarting is not necessary.

```sql
STOP SLAVE IO_THREAD; START SLAVE IO_THREAD;
```

Check the status:

```sql
show status like '%semi_sync%';
```

Key variables:

* Rpl_semi_sync_master_status_tx: ON/OFF
* Rpl_semi_sync_master_yes_tx: number of transactions that are replicated via semi-sync
* Rpl_semi_sync_master_no_tx: number of transactions that are not

After the timeout, master will turn off semi-sync. After detecting that the salve is working, master will resume semi-sync.

The `semi` means the master does not wait for the slaves to apply the relay logs before returning results.

### Frequent Start Options

* log-slave-updates (needs to be used with --logs-bin)
  * controls if the slave write logs or not
  * need to be turned on if multiple layers are used to chain the servers together
* master-connect-retry
  * retry time interval after master loses connection to slaves
* read-only
  * only accept root user's operations
* replicate-do-db, replicate-do-table, replicate-ignore-db, replicate-ignore-table, replicate-wild-do-table
  * specify which one to sync
* slave-skip-errors
  * by default, slave will stop if errors are encountered. `--slave-skip-errors=[err_code1, err_code2,... | all]`

### Maintenance Tips

```sql
show slave status; -- Slave_IO_Running, Slave_SQL_Running
```

If the master is too busy or the slave is too slow, the processing may fall behind and affect the performance.

```sql
FLUSH TABLES WITH READ LOCK;
SHOW MASTER STATUS; # get the name and pos
SELECT MASTER_POS_WAIT('mysql-bin.???','pos???'); -- 0: synced; -1: timeout
UNLOCK TABLES; # wait until synced
```

If the slave encounters error during replication, check if they have same table structures first.

If not the same, manually alter the structures and `START SLAVE` again.

If they have the same structures, first check if manually updating is safe, then skip the failed statements from the master.

```sql
select * from repl_test;                -- testing
stop slave;
SET GLOBAL SQL_slave_SKIP_COUNTER=2;    -- first 2 statements will be skipped
```

and try updating.

The number `n` is either 1 or 2.
If the update statement from master does not use `AUTO_INCREMENT` or `LAST_INSERT_ID()`, then n should be 1.

Otherwise, n should be 2. Since the statements using them need to fetch 2 events from the binlog.

Log event entry exceeded max allowed packet:

```sql
show variables like 'max_allowed_packet';
SET @@global.max_allowed_packet=16777216;
```

Don't forget to config `my.cnf` to make the setting persistent.

Sometimes we need to have multiple masters and one slave, there will be conflicts among the main keys.

```sql
show variables like 'auto_inc%';
SET @auto_increment_increment = 2;
-- SET @auto_increment_offset = 0;
```

Check the status:

```sql
alter table repl_test add column createtime datetime;
insert into repl_test values(5,now());
select * from repl_test;
stop slave IO_THREAD;
```

How to speed up:

1. use `replicate-do-db` and other commands to separate the tables and databases to different servers
    * Use master2 to improve efficiency more
    * It is easy and "cheap" but hard to maintain since the data are separated
2. multiple-thread replication based on Schema
   * Set parameter `slave_parallel_worker` to 2 so that MySQL will start 2 SQL threads for replication
   * Read the documentation for details

How to switch master and slave databases:

When old Master is down, we want slave1 to be new Master and S2 use S1 as master.

1. make sure all slaves have executed all from relay log

    * If all the states are: "Has read all rely log", then it is finished.

    ```sql
    STOP SLAVE IO_THREAD;
    SHOW PROCESSLIST;
    ```

2. On s1

    ```sql
    STOP SLAVE;
    RESET MASTER;
    ```

3. on s2

    ```sql
    STOP SLAVE;
    CHANGE MASTER TO MASTER_HOST = '192.168.1.111';  -- ip of s1
    START SLAVE;
    ```

4. Inform all the clients to point to S1 so that all the update logs are written to S1
5. Delete master.info and relay-log.info from this new Master. Otherwise after rebooting, it will start as slave again.
6. If M can be repaired, make it slave of S1 as same as what we did to S2

The above steps assume that S1 has `log-bin` option on and does not have `log-slave-updates` parameter on.
Otherwise (the later one is enabled), it may send executed binlog to S2 again, leading to duplication and sync error.

### Summary of Replication Methods Above

Replication is common. It is easy to set up and it is recommended to replicate important data.

If there is no extra server, setting another MySQL instance on same physical server is also acceptable.

Please read the latest documentation online since the technology is still growing rapidly.