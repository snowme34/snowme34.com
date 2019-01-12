# Domain Name and DNS

## Domain Name and Domain Name System

Computers use IP addresses to communicate.
But it is hard to memorize and manage those
so humans use Domain Names.

Domain Name System (DNS) translates the domain names to real addresses
that the computer understands. One domain name can have different
results returned based on different conditions for different queries
(for example, open gmail.com is different from send email to @gmail.com).

DNS is provided by DNS servers.

One fully qualified domain name ([FQDN]) has 3 (usually) parts and is divided using period character, '.'.
There are 4 period characters in total but the dot at the end is commonly omitted.

[FQDN]:https://en.wikipedia.org/wiki/Fully_qualified_domain_name

* Top-level domain
  * .com or .org?
* Second-level domain
  * example.com
  * something one needs to purchase from a company
  * [Learn more from ICANN](https://www.icann.org/resources/pages/register-domain-name-2017-06-20-en)
* host name
  * controlled by the owner of the second-level domain
  * like a specific server in a company

Domains are case-insensitive.

Somewhat duplicated with
[another article](https://docs.snowme34.com/en/latest/reference/network/network-devops-basic.html) on this site.

## DNS Clients

Devices of end-users are clients, which do not store DNS
information (but they might cache or override).

Applications or services will use some low-level methods to
resolve the domain names (by which it means a c program on Linux do
not call `host` command directly).

* [ngx_resolver.c](https://github.com/nginx/nginx/blob/master/src/core/ngx_resolver.c)
* [resolver(5) - Linux man page](https://linux.die.net/man/5/resolver)
* [getaddrinfo(3) - Linux man page](https://linux.die.net/man/3/getaddrinfo)
* [res_query(3) - Linux man page](https://linux.die.net/man/3/res_query)

DNS query of system:

* Files
  * `/etc/hosts`
  * `/etc/networks`
  * often taken advantage of by virus or Trojans
  * usually have higher priority
* DNS server
  * `/etc/resolv.conf`
  * see the config guide of your linux distribution
  * [NetworkConfiguration - Debian Wiki](https://wiki.debian.org/NetworkConfiguration#Defining_the_.28DNS.29_Nameservers)
* NIS(network information service)
  * not popular

The query order can be configured in `/etc/nsswitch.conf`

```conf
hosts: files dns
```

## DNS Query Commands

Commands that directly send queries to DNS servers:

* they skip `nsswitch.conf`

```bash
host
dig # with more details
```

Others:

* http://man7.org/linux/man-pages/man1/getent.1.html

```bash
getent hosts www.winaproduct.com
getent ahosts google.com
getent ahostsv4 www.google.com
getent ahostsv6 www.google.com
```