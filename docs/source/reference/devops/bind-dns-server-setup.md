# Bind DNS Server Setup

To setup a basic master DNS server.

## BIND

The most popular DNS server software.

Berkeley Internet Name Domain, originally developed in Berkeley and
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

Not recommended for modern environments (with `SELinux`).

Nowadays people use `bind9`. But for `bind8` and even old days,
there were severe security bugs. So it was common for people to create
`chroot` jail for bind. Today as long as SELinux is enabled, it is
safe enough to run without `chroot`.

**Actually**, [`chroot` is never intended to be used as a security
measure](https://serverfault.com/questions/454899/why-chroot-is-considered-insecure).

On Debian, `bind9` can be directly configured to use `chroot`.

[Debian wiki - Bind9 (Bind Chroot)](https://wiki.debian.org/Bind9#Bind_Chroot)

If additional program, `bind-chroot`, is what you need. install it and
create "fake" directories for "chroot". The common way:

```bash
/var/named/chroot/etc/named.conf
/var/named/chroot/var/named
```

Also it may be required to "fake" complete directory structure in `chroot`
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

2. create zone file in `/etc/bind/zones/` or `/var/named/chroot/var/named`

    It is common to copy the existing zone file as template.

    `cp named.localhost xxx.net.zone`

## Troubleshoot

bind provides 2 grammar checking tools

```bash
named-checkconf # check conf files
named-checkzone # check zone files

named-checkconf /var/named/chroot/etc/named.conf # main conf
named-checkzone linuxcase.net linuxcast.net.zone # domain zone-file
```

It's usually either grammar errors or permission errors.

Make sure all zone files have reading permission open.
