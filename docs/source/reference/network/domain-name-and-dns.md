# Domain Name and DNS

## Domain Name and Domain Name System

Computers use IP addresses to communicate.
But since it is hard to memorize and manage
those "numbers" directly, humans use Domain Names.

Domain Name System (DNS) translates the domain names to real addresses
that the computer understands. One domain name can have different
results returned based on different conditions for different queries
(for example, open gmail.com is different from send email to @gmail.com).

DNS services are provided by DNS servers.

One fully qualified domain name ([FQDN]) has 3 parts and is divided using period character, '.'.
There are 4 period characters in total but the dot at the end is commonly omitted.

(In fact there are 4 parts and the root domain, the one after the last period, is represented using empty string)

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

Commands that directly send queries to DNS servers (skip `nsswitch.conf`):

```bash
host
dig # with more details

dig -t mx gmail.com # check all the mx records. number is the priority (smaller -> higher)
dig -x dot-notation # reverse lookup
dig -t soa bing.com # start of authorities
```

One command to resolve a name in "real" way:

* http://man7.org/linux/man-pages/man1/getent.1.html

```bash
getent hosts www.winaproduct.com
getent ahosts google.com
getent ahostsv4 www.google.com
getent ahostsv6 www.google.com
```

## DNS Query

The structure of DNS record is like a tree.

[DNS Root Server | Cloudflare](https://www.cloudflare.com/learning/dns/glossary/dns-root-server/)

A domain name is looked up from right to left and the query is sent to multiple servers.

* root DNS server
* top level DNS server
* authoritative DNS server

The empty string after the last period (the one commonly omitted) represents
root DNS server. Root server stores the most basic information and
returns the addresses of the DNS servers for top-level domains (TLD).

There is no way to resolve the addresses of root server, so their
addresses are stored explicitly by the resolvers.

[List of root servers](https://www.iana.org/domains/root/servers)

Top-level domain name service is provided by one or more servers.
They store the information for their top-domains and return the addresses
of authoritative DNS servers. (for example, a name server that is
responsible for `.com`)

And authoritative name servers are responsible for the information under
second level domains, such as `*.some.domain`. For big companies, they
might have their own authoritative name servers. For personal sites,
it is more practical to use domain name servers of domain name
registration companies or CDN (content delivery network) providers.

The names "below" this level is fully controlled by the owner of this
second level domain.

(Also using CDN might be help one hide the true IP address.
But CDN and other advanced topics are not going to be covered here)

```bash
# show the complete query process
dig +trace www.google.com
```

In practice, however, it is not efficient for all end users to send queries in this fashion.
The DNS records can be cached since a lot of them do not change frequently.
Also some DNS servers only give access to other DNS servers. And using a server that
is very far away will significantly slow down the speed. Because of reasons like these,
users either use popular public DNS servers or use the ones provided by their ISP.

[What is DNS | Cloudflare](https://www.cloudflare.com/learning/dns/what-is-dns/)

## DNS Query Types

* iterative query
* recursive query

In a iterative query, client sends the query to a DNS server. If the server does
not have a direct answer, it sends the address of another DNS server back to client.
And client will send the query to that DNS server. This procedure is repeated until
a server answers a matching address or an error occurs.

In a recursive query, the DNS server (usually a recursive resolver) will
recursively resolve the domain name and send either the answer or an error back
to the client.

In real life, they are combined and DNS servers will cache the records.

## Resource Records

DNS information is stored using a format called Resource Record.

Resource record can store information more than IP addresses.

Some random examples:

```bash
www IN  A     192.169.1.1
g   IN  CNAME www.google.com.
```

Common resource record data fields:

* NAME
  * the name of the host
* CLASS
  * class of the resource, IN is Internet
* TYPE
  * type of the resource
* RDATA
  * record data

Types:

* A: a ipv4 record
* AAAA: ipv6
* CNAME: Canonical Name
* MX: mail exchange, the domain of the e-mail service
* PTR: pointers, reverse map
* SRC: service record
* TXT: text

The domains must be complete in resource records. So there is a period
at the end of the domains.

[DNS Resource Records - Cisco](https://www.cisco.com/c/en/us/support/docs/ip/domain-name-system-dns/12684-dns-resource.html)

## Zone File

A zone file is used to store the information of a domain.

The format is fixed.

For bind, the zone files are located at `/var/named/zone/`.

Example:

```conf
$TTL 1D ; time to live
@       IN      SOA     ns1.invalid.domain. admin.invalid.domain. (
                        1       ; Serial
                        3h      ; Refresh
                        1h      ; Retry
                        1w      ; Expire
                        3h )    ; Minimum

                NS      @
                MX      10      mail.invalid.domain.
                TXT     "Some Text"

example.com.    IN      A       1.2.3.4
ns1             IN      A       127.0.0.1
ns2             IN      A       192.168.1.1
www             IN      CNAME   example.com.
ftp             IN      CNAME   example.com.
```

Serial simply means how many times did this file change.
For each change, increment it by 1, which will notify other
servers refresh.

Refresh is the refresh rate.

[DNS HOWTO : A real domain example](https://www.tldp.org/HOWTO/DNS-HOWTO-7.html)

## DNS Server Types

* Primary (master):

A primary DNS server stores the zone file of a domain.
All changes of the config should be done here.

* Secondary (slave):

Load balance. Fetch zone file from the primary server.
Sync with the primary server.

* Caching only:

No zone files. Provide services based on caches.
Load balance or accelerate the DNS queries. Not
as common as the 2 types above.

If there are plenty of DNS queries in a LAN, a
cache-only DNS server can be used to cache all
the queries for the devices in this network.