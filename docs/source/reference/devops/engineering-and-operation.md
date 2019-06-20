# Engineering and Operation

Code is shipped to production

* coding
  * write the code
  * test
* debugging
  * ship the code
  * issues emerge

## Coding

Think about production environment while developing

* How to avoid/defend/recover from issues?
* How to help to troubleshoot?

### Race Conditions and Edge Cases

Very likely happen when the following are involved

* Threads
* Multi-Process (resource contention)
* Across-the-network

Use "atomic" operations to avoid race conditions

May happen in the situations never thought about, the Edge Cases

* all possible input
* never assume something never happens

Research on the implicit and explicit locks or semaphores available (for file systems or databases etc.)

* usually DBMS automatically locks
* but they may or may not be correct or enough or efficient

UNIX file locking

* lockf()
* flock()
* fcntl()

#### File

Think carefully when opening files. (Majority developers never think beyond closing after opening)

They may change after opening, may disappear or even may be maliciously edited (or read).

One security measurement: create a randomly named directory for the files under /tmp/, and change the permission of that directory

#### Race Condition Pitfall

Bad Locks, use randomness to help

* deadlock
* livelock

Failed to account for network latency

* possible solution is to averaging the data of multi-clients (e.g. local and remote)
  * e.g. display player in a location between where the player thinks and others thinks
* do not wish to slow down other people via atomic operations etc.

### Efficiency and Scalability

There is usually a trade-off between "speed to ship the product" and "scalable or efficient code"

First know

* over-efficient is bad
  * may prevent scaling
  * may harm later development
* unnecessary scalability is unnecessary
  * never able to predict the future exactly
  * always trading-off scalability with others, usually efficiency
    * e.g. more servers -> slower to start the whole system

Think about your own product

* what is the limit (disk, memory, cpu, networking)?
* what happens when reaching the limit?
* how to scale?

How

* separate by layers
* load balancing
* DNS evenly lookup
* active/passive mode

See the [Scale](https://docs.snowme34.com/en/latest/reference/devops/scale.html) page for more details

Don't forget availability

* CAP theorem

### Debug

Output

* Logs
* Console output

Switches

* Manual switch
  * command line
  * process signal (`kill`)
* Config file

Think carefully (again) what to use. Some bugs may be caused by logging itself. Some switches like reloading
a config file may clear the bug.

#### Logs

One of the most important things.

Logging builds the bridge between developers and debuggers.

##### Logging Level

Usually different levels for logs

* debug
* info
* warning
* fatal

##### Logging Pitfalls

Logging costs

* over-logging wastes resources
* jumbled or interleaved logging makes logs useless

## Debugging

Now it's time to debug

### System Health

#### CPU

* load average
* processor utilization

#### Memory

* resident set sizes
* swap

About swap

* If forking a large process, lack of memory will fail this fork unless there is enough swap.
* But we don't want to use swap. Check problems that cause processes to use swap.
* Can use `ps` to check swap

Also Linux has OOM Killer (Out of memory killer). Overloaded memory usage might trigger it to kill.

#### Disk I/O

* IOPS
  * I/O operations Per Second
* file system
  * local
  * fiber channel
  * SAN (Storage Area Network)
  * NFS
  * NAS (Network Attached Storage)

#### Network

* utilization
  * bps (bit per seconds)
  * pps (packet per seconds)
* packet loss
  * local
  * remote
* protocol
* end users
  * slow
  * lossy
  * not exist
  * malicious

There are 65535 TCP/IP ports (some are reserved) in total. Running out of ports is another common issue.

There are "2" ips: IPv6 and IPv4. One process might make 2 connection attempts or 1 or 0.

### Process Health

* pegged CPU
* weird memory usage
* process state

-------------------------------------

See [Unix and Linux Commands](https://docs.snowme34.com/en/latest/reference/commands/unix-and-linux-commands.html) for commands to use. Search for key word: troubleshoot or click this [link](https://docs.snowme34.com/en/latest/reference/commands/unix-and-linux-commands.html?highlight=troubleshoot) for built-in highlight.

### Log

* where
* useful
* readable

Check how your program logs

Check system logs (system health)

### Dependency

Does it depend on other recourses? Are those working?

* blocking synchronous calls
* slow asynchronous calls
* dependency services go down
* components in series go down
* proxy servers
* etc.

Real problem might be surprising, like a DNS record issue or an expired certificate
