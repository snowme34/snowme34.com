# Linux Service

A service is one or a set of applications running in the background doing
specific tasks.

Services usually do not have GUI.

They run and accept requests all the time. And the reliability
often refers to the how long they can work without errors.

## System V and systemd

SysVinit is an old way for Linux to manage system and services.

Systemd replaces SysVinit and is the system and service manager used in common distributions now.

But it seems that a lot of people dislike systemd.

* [systemd - Wikipedia](https://en.wikipedia.org/wiki/Systemd#Criticism)
* [Linus Torvalds and others on Linux's systemd](https://www.zdnet.com/article/linus-torvalds-and-others-on-linuxs-systemd/)
* [The Biggest Myths](http://0pointer.de/blog/projects/the-biggest-myths.html)
* [ELI5: The difference between SystemV and Systemd in Linux and why it's a big deal with Debian](https://www.reddit.com/r/explainlikeimfive/comments/2jormj/eli5_the_difference_between_systemv_and_systemd/)
* ... a lot more

## systemd

```bash
man systemd
man systemd-system.conf
```

`systemd` uses "unit files" to manage each service and other things (from man page):

* Service, daemons
* Socket, local IPC or network sockets
* Target, group units or synchronization points
* Device, kernel devices
* Mount, mount points
* Automount
* Timer, triggering based on times
* Swap, similar to "mount", memory swap partitions or files
* Path, activate other services on change
* Slice, group system process management units
* Scope, similar to "Service", but manage foreign processes

Some `systemctl` commands:

```bash
systemctl status <service>

# specific ones depend on whether the unit supports the operations
sudo systemctl start <service>
sudo systemctl stop <service>
sudo systemctl reload <service>
sudo systemctl restart <service>
sudo systemctl enable <service>
sudo systemctl disable <service>

# list enabled
systemctl list-unit-files --state=enabled
systemctl list-unit-files | grep enabled

# list running
systemctl list-units --type=service --state=running
systemctl | grep running

# list active
systemctl list-units --type=service --state=active
```

If you know SysVinit, [SysVinit to Systemd Cheatsheet](https://fedoraproject.org/wiki/SysVinit_to_Systemd_Cheatsheet)

### Write a Unit File

General recommendation:

1. read existing files or examples
2. read man page for interested directories
    * if you want your thing truly works, always read man page even it's overlength

```bash
man systemd.unit # https://www.freedesktop.org/software/systemd/man/systemd.unit.html
```

Where should I put the file?

Paths in descending priority (config in `etc` overwrites others):

```bash
# system
/etc/systemd/system.conf, /etc/systemd/system.conf.d/*.conf, /run/systemd/system.conf.d/*.conf, /lib/systemd/system.conf.d/*.conf
# user
/etc/systemd/user.conf, /etc/systemd/user.conf.d/*.conf, /run/systemd/user.conf.d/*.conf, /usr/lib/systemd/user.conf.d/*.conf
```

### Unit Section

```bash
[Unit]
...
```

* Description=
  * short and descriptive
* Documentation=
  * docs
  * local or online
  * displayed in `systemctl status`
* Requires=
  * essentially depends
  * must be activate simultaneously
  * started in parallel by default
* Wants=
  * less strictly depends
  * continue to work even if other units it "wants" not working
  * recommended for most dependencies
  * started in parallel by default
* BindsTo=
  * similar to Requires
  * this unit stops when the units it "Binds to" stops
* Before= After=
  * ordering, not implying dependencies
  * common to list units listed in both the After= and Requires= option
    * this unit defined in this file depends on those units and will start after them
* Conflicts=
  * negative requirement dependencies
* Conditions...=
  * a set of directives, see man page for all of them (plenty of)
  * will be verified (is true?) before starting the current unit
  * if not true, unit will be (mostly silently) skipped but not failure
  * read the man page (again) for each option
* Asserts...=
  * similar to Conditions...= but failure

For `enable`, read about the [Install] section.

If you are truly tired of reading man page, maybe [this](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files) might be helpful.

### Example Unit Files

From man page, read man page for more.

```bash
[Unit]
Description=Foo

[Service]
ExecStart=/usr/sbin/foo-daemon

[Install]
WantedBy=multi-user.target
```

## SysVinit

Very brief

### Run Levels

* 0 Halt
* 3 multi-user, non-graphical
* 5 multi-user, graphical
* 6 reboot

Each run level has different services to start.

3 and 5 are most common.

### Management

Write System V scripts

Path:

```bash
/etc/rc.d/init.d # stores the actual scripts
/etc/rc[0-6].d/  # scripts to run for each level, links to init.d

# s in link name: start at boot
# k in link name: not start at boot

# number in the name means the order, 01-99
```

Commands:

```bash
service <some-service> [start|restart|stop|status]
```

#### `chkconfig`

Control services started at boot or not

```bash
chkconfig cups [on/off]
chkconfig cups on
chkconfig cups off
chkconfig --list
```

### `xinetd`

* service
  * daemon, always (almost) up
* xinted
  * not always up

`xinted` is a daemon, when requests sent to services it controls,
it will start that service and stop it afterwards.

`xinted` can also controls access

Usually legacy ones, rare.

Common `xinetd` services:

* telnet
* tftp
* rsync

Still controlled by `chkconfig`

#### `xinetd` config

`/etc/xinetd.d/<service-name>`

`/etc/xinetd.d/tftp` example:

```bash
service tftp
{
    disable          = yes
    socket_type      = dgram
    protocol         = udp
    wait             = yes
    user             = root
    server           = /usr/sbin/in.tftpd # the read server behind
    server_args      = -c -s   /tftpboot
    per_source       = 11
    cps              = 100 2
    flags            = IPv4
}
```