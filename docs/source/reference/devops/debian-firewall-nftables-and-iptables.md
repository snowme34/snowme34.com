# Debian Firewall nftables and iptables

A **short** summary of how to config a basic Debian firewall.

[Debian encourages](https://wiki.debian.org/nftables) people to use nftables, but right now it's not well supported.

Also try to not run `iptables` and `nftables` at the same time, "[could lead to unexpected results](https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables)"

Update: this page is receiving higher traffic than I expected. Due to the immature nature of the topics discussed and the superficialness of the discussion, the content is highly recommended only as a quick handy non-professional reference.

## `iptables`

Always begin with reading the man page

```bash
man iptables # https://linux.die.net/man/8/iptables
```

List current rules:

```bash
sudo iptables -L -nv
sudo ip6tables -L -nv
```

Add rules:

* the order matters
* the configurations applies immediately, and it's very common for people to block their own access to the server here

```bash
# accept loopback
sudo iptables -A INPUT -i lo -j ACCEPT

# accept established and related
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# drop invalid
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# accept ssh (change port if different)
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT

# accept useful ICMP (echo reply, destination unreachable, echo request, time exceeded)
# feel free to reject or set a limit for ping (icmp type 8)
sudo iptables -A INPUT -p icmp --icmp-type 0  -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type 3  -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type 8  -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type 11 -m conntrack --ctstate NEW -j ACCEPT

# accept timestamp request
sudo iptables -A INPUT -p icmp -m conntrack --ctstate NEW --icmp-type 13 -j ACCEPT

# http servers (inessential)
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# below is optional

# 192.168.1.0/24
#sudo iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT

# SMTP
#sudo iptables -A INPUT -p tcp --dport 25 -j ACCEPT
# SMTP(submission)
#sudo iptables -A INPUT -p tcp --dport 587 -j ACCEPT

# POP
#sudo iptables -A INPUT -p tcp --dport 110 -j ACCEPT

# rsync (15.15.15.0/24 is an example IP)
#sudo iptables -A INPUT -p tcp -s 15.15.15.0/24 --dport 873 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# Drop all packets that are going to broadcast, multicast or anycast address.
#sudo iptables -A INPUT -m addrtype --dst-type BROADCAST -j DROP
#sudo iptables -A INPUT -m addrtype --dst-type MULTICAST -j DROP
#sudo iptables -A INPUT -m addrtype --dst-type ANYCAST -j DROP
#sudo iptables -A INPUT -d 224.0.0.0/4 -j DROP
#sudo iptables -A INPUT -s 127.0.0.0/8 ! -i lo -j DROP (?)

# drop all other INPUT (dangerous line, takes effect immediately)
sudo iptables -P INPUT DROP

## add your customization ports p1 and p2
#sudo iptables -A INPUT -p tcp -m multiport --dports <p1>,<p2> -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#sudo iptables -A INPUT -p udp -m multiport --dports <p1>,<p2> -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# allow all output
sudo iptables -A OUTPUT -j ACCEPT

# drop forward (if not router)
sudo iptables -P FORWARD DROP

# other common ports
# FTP - 21 TCP
# SSH - 22 TCP
# TELNET - 23 TCP
# SMTP - 25 TCP
# DNS - 53 TCP/UDP
# DHCP - 67 , 68 DHCP
# HTTP - 80 TCP
# POP3 - 110 TCP
# IMAP - 143 TCP
# HTTPS - 443 TCP
# VNC - 5900-6000
# IRC - 6667-7000
# Gmail SMTP TLS: 587
# Gmail SMTP SSL: 465
# Gmail POP SSL: 995
# Gmail IMAP SSL: 993
```

For `ip6tables` (IPv6):

```bash
# accept loopback
sudo ip6tables -A INPUT -i lo -j ACCEPT

# accept established and related
sudo ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# drop invalid
sudo ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP

# accept ssh (change port if different)
sudo ip6tables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT

# accept all ICMP
sudo ip6tables -A INPUT -p icmpv6 -j ACCEPT

# http (inessential)
sudo ip6tables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# drop other INPUT
sudo ip6tables -P INPUT DROP

# allow all output
sudo iptables -A OUTPUT -j ACCEPT

# drop FORWARD (if not router)
sudo ip6tables -P FORWARD DROP
```

Make the rules persistent:

```bash
sudo apt install iptables-persistent # if not installed yet
# sudo dpkg-reconfigure iptables-persistent # if already installed
```

Notice for `docker` users: you might need to add additional "FORWARD" policies for `docker` (but it generally takes care of itself).

Reset/Clear the rules:

```bash
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -F
iptables -X

# ipv6
ip6tables -P INPUT ACCEPT
ip6tables -P OUTPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -t nat -F
ip6tables -t nat -X
ip6tables -t mangle -F
ip6tables -t mangle -X
ip6tables -F
ip6tables -X

# if you want to remove the persistent rules too, save the current empty rule set
sudo apt install iptables-persistent # if not installed yet
# sudo dpkg-reconfigure iptables-persistent # if already installed
```

### Reference for iptables

1. [BasicSecurity/Firewall - Ubuntu Wiki](https://wiki.ubuntu.com/BasicSecurity/Firewall)
2. [DebianFirewall - Debian Wiki](https://wiki.debian.org/DebianFirewall)
3. [Firewalls - Debian Wiki](https://wiki.debian.org/Firewalls)
4. [Control Network Traffic with iptables](https://www.linode.com/docs/security/firewalls/control-network-traffic-with-iptables)
5. [Iptables Essentials: Common Firewall Rules and Commands | DigitalOcean](https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands)
6. [How To Choose an Effective Firewall Policy to Secure your Servers | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-choose-an-effective-firewall-policy-to-secure-your-servers)
7. [Basic iptables template for ordinary servers (both IPv4 and IPv6)](https://gist.github.com/jirutka/3742890)

If you have a large number of IPs to manage, take a look at `ipset` ([ipset - ArchWiki](https://wiki.archlinux.org/index.php/Ipset))

## `nftables`

Install: [nftables - Debian Wiki](https://wiki.debian.org/nftables#nftables_in_Debian_the_easy_way)

```bash
apt-get install nftables
systemctl enable nftables.service
```

Always begin with the man page

```bash
man nft # https://www.netfilter.org/projects/nftables/manpage.html
```

List current rule set:

```bash
nft list ruleset
```

The config file (`/etc/nftables.conf`):

* directly edit this file to make changes persistent

```conf
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;

        # established/related
        ct state established,related accept

        # invalid
        ct state invalid drop

        # loopback
        iifname lo accept

        # ssh
        tcp dport 22 ct state new accept # change to your ssh port

        # accept all icmp
        ip protocol icmp accept
        ip6 nexthdr ipv6-icmp accept

        # http(s)
        tcp dport {http, https} accept
        udp dport {http, https} accept

        # uncomment to enable logging
        #log prefix "[nftables] Input Denied: " flags all counter drop
    }
    chain forward {
        # drop everything (if not a router)
        type filter hook forward priority 0; policy drop;

        # uncomment to enable logging
        #log prefix "[nftables] Forward Denied: " flags all counter drop
    }
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

About `counter`: After set a `counter` in the rule, you can see the number of packages that this rule applied to by list this rule.

Load the config file:

```bash
sudo /etc/nftables.conf
```

Note it's required to write the conf at the conf file (/etc/nftables.conf) and
enable the nftables service (if not yet), to make the config persistent (i.e. not lost after reboot).

```bash
sudo systemctl enable nftables
sudo systemctl start nftables
sudo systemctl status nftables
```

Delete rules by table or all rules:

* will not delete the content in the config file
* config file will still be loaded in the boot

```bash
nft flush table <some-table>
nft flush ruleset
```

If nftables is blocking some services, enable the log.
Add corresponding rules based on the content of the log:

```bash
sudo tail /var/log/syslog -n 500 | grep nftables # sample command to read the log
# then fix the issues accordingly
```

Notice for `docker` users: you might need to add additional "forward" policies for `docker`.

### Reference for nftables

* [nftables - ArchWiki](https://wiki.archlinux.org/index.php/nftables)
* [Quick reference-nftables in 10 minutes - nftables wiki](https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes)
* [nftables wiki](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
* [Firewalling using nftables](https://mirrors.deepspace6.net/Linux+IPv6-HOWTO/x2561.html)
