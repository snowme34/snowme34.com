# Bind DNS Server Setup

To setup a basic master DNS server.

This article may contain some outdated information.

**Always** read the latest official document first.

Debian, for example, [Bind9 - Debian Wiki](https://wiki.debian.org/Bind9).

## BIND

The most popular DNS server software.

Berkeley Internet Name Domain (bind), originally developed in Berkeley and
not maintained by ISC, Internet Systems Consortium.

Its main component is called `named`.

## Install Bind

```bash
sudo apt-get install bind9 bind9-doc

# yum install -y bind bind-chroot bind-utils # for centos with chroot
```

DNS uses both UDP and TCP.

Bind uses 2 ports (by default):

* 53: receiving and sending DNS protocol traffic
* 953: rndc (remote name daemon control)

Bind is usually not installed by default.

## Config Files for Bind

```bash
/etc/named.conf  # main config
/var/named/*.db  # zone
```

### Chroot

Not recommended for modern environments (where `SELinux` is properly enabled).

You may skip this section if you are not planning to use `chroot`.

Nowadays people use `bind9`. But for `bind8` and even old days,
there were severe security bugs. So it was common for people to create
`chroot` jail for bind. Today as long as SELinux is enabled, it is
safe enough to run without `chroot`.

**Actually**, [`chroot` is never intended to be used as a security
measure](https://serverfault.com/questions/454899/why-chroot-is-considered-insecure).

On Debian, `bind9` can be directly configured to use `chroot`.

[Debian wiki - Bind9 (Bind Chroot)](https://wiki.debian.org/Bind9#Bind_Chroot)

If you still decide to use `chroot`, there is an additional program, `bind-chroot`,
that may come to be handy.

To prepare for `chroot` jail, create "fake" directories for "chroot". The common way:

```bash
/var/named/chroot/etc/named.conf
/var/named/chroot/var/named
```

Also it may be required to "fake" all other necessary directory structure in `chroot`
directories.

## Config Bind

### Main Config

From [Debian Wiki - Bind9](https://wiki.debian.org/Bind9)

`/etc/bind/named.conf`

```bash
// Managing acls (access control list)
acl internals { 127.0.0.0/8; 192.168.0.0/24; };

// Load options
include "/etc/bind/named.conf.options";

// TSIG key used for the dynamic update
include "/etc/bind/ns-example-com_rndc-key";

// Configure the communication channel for Administrative BIND9 with rndc
// By default, they key is in the rndc.key file and is used by rndc and bind9 
// on the localhost
controls {
        inet 127.0.0.1 port 953 allow { 127.0.0.1; };
};

// prime the server with knowledge of the root servers
zone "." {
        type hint;
        file "/etc/bind/db.root";
};

include "/etc/bind/named.conf.default-zones";
include "/etc/bind/named.conf.local";
```

`/etc/bind/named.conf.default-zones`

```bash
// be authoritative for the localhost forward and reverse zones, and for
// broadcast zones as per RFC 1912
zone "localhost" {
        type master;
        file "/etc/bind/db.local";
};
zone "127.in-addr.arpa" {
        type master;
        file "/etc/bind/db.127";
};
zone "0.in-addr.arpa" {
        type master;
        file "/etc/bind/db.0";
};
zone "255.in-addr.arpa" {
        type master;
        file "/etc/bind/db.255";
};
```

`/etc/bind/named.conf.options`

```bash
options {
        directory "/var/cache/bind";

        // Exchange port between DNS servers
        query-source address * port *;

        // Transmit requests to 192.168.1.1 if
        // this server doesn't know how to resolve them
        forward only;
        forwarders { 192.168.1.1; };

        auth-nxdomain no;    # conform to RFC1035

        // From 9.9.5 ARM, disables interfaces scanning to prevent unwanted stop listening
        interface-interval 0;
        // Listen on local interfaces only(IPV4)
        listen-on-v6 { none; };
        listen-on { 127.0.0.1; 192.168.0.1; };

        // Do not transfer the zone information to the secondary DNS
        allow-transfer { none; };

        // Accept requests for internal network only
        allow-query { internals; };

        // Allow recursive queries to the local hosts
        allow-recursion { internals; };

        // Do not make public version of BIND
        version none;
};
```

Minimum version:

```bash
options
{
        directory (/var/named)               # directory for bind to work in
        listen-on port 53    {127.0.0.1}     # listen to loopback address
        listen-on-v6 port 53    {::1:}
}
```

`named.conf.local`

```bash
// add our own zone config here
zone “xxx.net” {
        type master;                  // master server
        file "/etc/bind/db.com.zone"; // name can be anything
};
```

### Zone Config

To configure a master server for a domain

1. Add zone definition in `named.conf.local` as shown above

2. Create zone file in `/etc/bind/zones/` or `/var/named/chroot/var/named`

    * It is common to copy the existing zone file as template:
    * `cp named.localhost xxx.net.zone`

3. Edit zone files

    Zone file, simply speaking, is just TTL (time to live) and
    the resource record of this domain. Read
    [another page](http://docs.snowme34.com/en/latest/reference/network/domain-name-and-dns.html)
    on this site to learn more.

4. Restart `named` service or reload config
5. Check if work properly

Sample way to check:

Change `/etc/resolv.conf`:

```bash
nameserver 127.0.0.1
```

Then

```bash
host some.domain
dig -t MX some.domain
```

Actually you can specify DNS server for those commands directly.

## Troubleshoot

bind provides 2 grammar checking tools

```bash
named-checkconf # check conf files
named-checkzone # check zone files

named-checkconf /etc/named.conf                  # main conf
named-checkconf /var/named/chroot/etc/named.conf # main conf
named-checkzone some.domain some.domain.zone     # domain zone-file
```

It's usually either grammar errors or permission errors.

Make sure all zone files have reading permission on.

## Slave Bind Server

To backup or load balance, bind servers can be configured to be slave.

* large amount of DNS requests
* master server stops working

All information of slave bind server is retrieved from master server.
All changes are made on master server.

### Configure a Slave Bind Server (brief)

There are multiple ways to "update" the zone files on salve server. Two examples:

* Wait for slave server to fetch each time it boots
* Let master server to notify slave servers

On master:

1. update listen port accordingly
2. add "notify" options

On slave:

1. add domain definition to bind config file
   * see sample below
   * make sure DNS service has read and write permission
2. restart bind service (load changes)
3. check if zone files are retrieved correctly
    * check firewall
    * check selinux
4. use `host` or `dig` to check if everything works

Sample slave zone definition:

```bash
zone "some.domain" {
    type slave;
    masters { 192.168.1.1; };
    file "slaves.some.domain.zone"
}
```

## Caching or Forwarding Bind Server

There is also another type of bind server that contains no zone definitions.

It recursively lookup DNS queries and caches the results,
usually to accelerate the DNS query speed of its clients.

Example will be such a server in a LAN network that speeds up the DNS queries inside this network

Forwarding servers will forward some or all DNS queries to other servers.

It allows user to access both the local zone files and the DNS records of the other servers.

Example will be such a server in a LAN network that contains zone definitions for
the domains in this LAN but it also forwards other queries to other public DNS,
so that users in this LAN can both access the local domains and the "outside" ones.

```bash
forwarders {1.2.3.4; };
```

This server does nothing but forwards DNS query:

```bash
forward only;
```

From [Forwarding (DNS and BIND, 4th Edition)](https://docstore.mik.ua/orelly/networking_2ndEd/dns/ch10_05.htm):

> A name server in forward-only mode is a variation on a name server that uses forwarders. It still answers queries from its authoritative data and cached data. However, it relies completely on its forwarders; it doesn't try to contact other name servers to find information if the forwarders don't give it an answer.