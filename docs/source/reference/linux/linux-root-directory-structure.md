# Linux Root Directory Structure

Brief about the Linux FHS (Filesystem_Hierarchy_Standard)

Everything on a system is under root directory, `/`, no matter the physical location

(for more concise or more detailed versions, see reference)

## Structure

`/bin`

* "essential command binaries"
* for all users
* shells and commands like "cp, mv, rm, cat, ls"

`/boot`

* "static files for boot loader" (e.g. grub)
* usually has the kernel file
* do not manually edit unless knowing what happens
* worth individually encrypted so that, even disk stolen, even other data are lost, but cannot boot
  * people can manually edit boot loader files to skip/change root password

`/dev`

* devices
* `/dev/sd*` -> disk
* `/dev/tty` -> terminal
* `/dev/null` -> a virtual device that discards input and reports success
* `/dev/random`

`/etc`

* system config files
* host-specific
* "etcetera"
* `/etc/opt` -> config for add-on packages in `/opt`

`/home`

* optional
* home directory
* one directory for one (normal) user
* site-specific
* store the "dot files"

`/lib`

* "essential shared libraries and kernel modules"
* libraries for `/bin` and `/sbin`
* usually `.so` files
* like `.dll` files for Windows

`/lib<qual>`

* optional
* alternative format libraries
* essential shared libraries

`/lost+found`

* corrupt files that were tried to be recovered by `fsck` for each boot

`/media`

* mount points
* for removable media

`/mnt`

* mount points
* generic location for filesystems or devices
* temporarily

`/opt`

* "add-on application software packages"
* optional application
* put self-contained binaries or directories here (recommended)
* together with `/var/opt`, `/etc/opt`
* usually has sub-structure like `/opt/'package'` or `/opt/'provider'`

`/proc`

* virtual filesystem for real-time process and kernel information
* "procfs" mount, exist in RAM
* auto updated
* one process corresponds to one directory with numerical name
  * usually one program takes one process
* popular files under `\proc`
  * cpuinfo
  * meminfo
  * interrupts
  * iomem
  * uptime
  * vmstat
  * scsi 
  * [read more](http://www.tldp.org/LDP/Linux-Filesystem-Hierarchy/html/proc.html)

`/root`

* optional
* home directory for root user

`/run`

* run-time variable

`/sbin`

* essential system binaries
* for root user
* "binaries essential for booting, restoring, recovering, and/or repairing the system in addition to the binaries in /bin." -- FSSTND
* shutdown command is required

`/srv`

* serve
* data served by this server (usually web server)
* not always exist, recommend `/var/www/html` for root of web server

`/sys`

* low-level system information
* device, drivers, kernels

`/tmp`

* temporary
* often auto cleaned per reboot
* usually lock files or temp data

`/usr`

* "secondary hierarchy", "User System Recourses"
* largest sharable read-only data
* contains the user binaries
* notable sub-directories
  * `/usr/bin`
  * `/usr/include`
  * `/usr/lib`: libraries for `/usr/bin` and `/usr/sbin`
  * `/usr/lib\<qual\>`: alternative format libraries, e.g. lib32
  * `/usr/sbin`
    * system binaries, "less important" than the ones in `/sbin`
    * like daemons, only admin access but not crucial for system maintenance
  * `/usr/local`
    * host-specific local data
      * `/usr/local/bin`
      * `/usr/local/lib`
  * `/usr/share`
    * `/usr/doc`
    * `/usr/info`
    * `/usr/man`
  * `/usr/src`: source code

`/var`

* variable data
* e.g. logs
* notable sub-directories
  * `/var/cache`
  * `/var/lib`: state information
  * `/var/lock`
  * `/var/local`: variable data for /usr/local
  * `/var/log`
    * auth.log
    * btmp: bad logins, `lastb`
    * dmesg: kernel ring butter
    * messages
    * syslog
  * `/var/mail`
  * `/var/spool`
  * `/var/tmp`: tmp files that are allowed to stay longer than the ones in `/temp`
* required: cache, lib, local, lock, log, opt, run, spool, tmp

## Shared

There are sharable and non-shareable directories.

* shareable ones can be "shared", on a remote machine, and so on
* non-sharable ones are host-specific

> 'Mountable' directories are: '/home', '/mnt', '/tmp', '/usr' and '/var'.
> Essential for booting are: '/bin', '/boot', '/dev', '/etc', '/lib', '/proc' and '/sbin'.

## Reference

* [FilesystemHierarchyStandard - Debian Wiki](https://wiki.debian.org/FilesystemHierarchyStandard), a very concise one
* [Filesystem Hierarchy Standard - Wikipedia](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
* [Linux Filesystem Hierarchy](http://www.tldp.org/LDP/Linux-Filesystem-Hierarchy/html/)
* [fhs-3.0.pdf](https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf), a very detailed one
