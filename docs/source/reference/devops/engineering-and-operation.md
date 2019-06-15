# Engineering and Operation

Code is shipped to production

* coding
  * write the code
  * test locally
* debugging
  * ship the code
  * issues emerge

## Coding

Think about production environment while developing

* How to avoid/defend/recover from issues?
* How to help to troubleshoot?

### Race Conditions and Edge Cases

Very likely happen when

* Threads
* Multi-Process (resource contention)
* Across-the-network

Use "atomic" operations to avoid race conditions

May happen in the situations never thought about, the Edge Cases

* all possible input
* never assume something never happens

Research on the implicit and explicit locks or semaphores available (for file systems or databases etc.)

* usually DBMS automatically locks
* but they may or may not be correct or enough

UNIX file locking

* lockf()
* flock()
* fcntl()

#### File

Think carefully when opening files. (Majority developers never think beyond closing after opening)

It may change after opening, may disappear or even may be maliciously edited (or read).

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

There is usually a trade-off between speed to ship the product vs scalable or efficient

First know

* over-efficient is bad
  * may prevent scaling
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

## Debugging

Now it's time to debug

### System Health

CPU

* load average
* processor utilization

Memory

* resident set sizes
* swap

Disk I/O

* IOPS
  * I/O operations Per Second
* file system
  * local
  * fiber channel
  * SAN (Storage Area Network)
  * NFS
  * NAS (Network Attached Storage)

Network

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

### Process Health

* pegged CPU
* weird memory usage
* process state

### Log

* where
* useful
* readable

### Dependency

Does it depend on other recourses? Are those working?
