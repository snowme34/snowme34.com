# Engineering and Operation

Code is shipped to production

## Coding

Think about production environment while developing

* How to avoid/defend/recover from issues?
* How it make it easier to debug?

### Race Conditions

* Threads
* Multi-Process (resource contention)
* Across-the-network

Use "atomic" operations to avoid race conditions

Research on the implicit and explicit locks or semaphores available (for file systems or databases etc.)

* usually DBMS automatically locks
* but they may or may not be correct or enough

#### UNIX file locking

* lockf()
* flock()
* fcntl()

#### File

Think carefully when opening files.

It may change after opening, may disappear or even may be maliciously edited (or read).

### Edge Cases

All possible input

Never assume something never happens

### Efficient

Over-efficient is bad

### Scale

What is the limit (disk, memory, cpu, networking)?

What happens when reaching the limit?

Need to scale at all?

How to scale?

### Debug

* Logs
* Console output

* "Switch"
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
