# Debian Firewall nftables and iptables

A **short** summary of how to config a basic Debian firewall.

[Debian encourages](https://wiki.debian.org/nftables) people to use nftables.

Also try to not run `iptables` and `nftbales` at the same time, "[could lead to unexpected results](https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables)"

See my other [page](https://docs.snowme34.com/en/latest/reference/devops/set-up-debian-server-on-digital-ocean.html) for a complete Debian VPS set up guide.

## `iptables`

Read the man page if you have time:

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
# accept loopback, established connections, SSH
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT # change to your ssh port

# accept ping (feel free to reject or set a limit)
sudo iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT

# accept timestamp request
sudo iptables -A INPUT -p icmp -m conntrack --ctstate NEW --icmp-type 13 -j ACCEPT

# http servers (inessential)
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# something not necessary

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

# drop invalid and all other input
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo iptables -P INPUT DROP

# log forward with limit
sudo iptables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "[iptables] FORWARD Denied: " --log-level 7

## customize
#sudo iptables -A INPUT -p tcp -m multiport --dports xxx,yyy -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#sudo iptables -A INPUT -p udp -m multiport --dports xxx,yyy -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# drop forward
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
# accept loopback, established, SSH, ping connections
sudo ip6tables -A INPUT -i lo -j ACCEPT
sudo ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip6tables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT # change to your ssh port
sudo ip6tables -A INPUT -p ipv6-icmp --icmpv6-type 128 -j ACCEPT

# http (inessential)
sudo ip6tables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# drop input
sudo ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo ip6tables -P INPUT DROP

# log forward with limit
sudo ip6tables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "[ip6tables] FORWARD Denied: " --log-level 7

## add some other customization here

# drop forward
sudo ip6tables -P FORWARD DROP
```

Make the rules persistent:

```bash
sudo apt install iptables-persistent # if not installed yet
# sudo dpkg-reconfigure iptables-persistent # if already installed
```

Notice for `docker` users: you might need to add additional "FORWARD" policies for `docker`.

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

## `nftables`

Read the man page if you have time:

```bash
man nft # https://www.netfilter.org/projects/nftables/manpage.html
```

List current rule set:

```bash
nft list ruleset
```

The config file (`/etc/nftables.conf`):

* I directly edited the conf file. Feel free to use `nft` command
* But it *seems* that you will need to figure out how to make those rules persist

```conf
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;

        iifname lo accept

        tcp dport 22 ct state new accept # change to your own ssh port
        ct state established,related accept

        # no ping floods:
        ip protocol icmp icmp type echo-request limit rate over 10/second burst 4 packets drop
        ip6 nexthdr icmpv6 icmpv6 type echo-request limit rate over 10/second burst 4 packets drop

        # ICMP & IGMP
        ip6 nexthdr icmpv6 icmpv6 type { echo-request, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-reduction, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, nd-neighbor-solicit, nd-neighbor-advert, mld-listener-report } accept
        ip protocol icmp icmp type { echo-request, destination-unreachable, router-solicitation, router-advertisement, time-exceeded, parameter-problem } accept
        ip protocol igmp accept

        # avoid brute force on ssh, and your ssh port here
        tcp dport 22 ct state new limit rate 15/minute accept # change to your own ssh port

        # http server
        tcp dport { http, https} ct state established,new accept
        udp dport { http, https} ct state established,new accept

        # some ports you like
        #tcp dport { xxx, yyy} ct state established,new accept
        #udp dport { xxx, yyy} ct state established,new accept

        ct state invalid drop

        # uncomment to enable log, choose one
        #log flags all counter drop
        #log prefix "[nftables] Input Denied: " flags all counter drop
    }
    chain forward {
        type filter hook forward priority 0; policy drop;
        tcp dport { http, https } ct state { established,new } accept
        udp dport { http, https } ct state { established,new } accept
        # for dockers
        # dockers have plenty of networks, so it may be required to change accordingly
        iifname eth0 oifname docker0 ct state { established,new,related } accept
        oifname eth0 ct state { established,new,related } accept
        # uncomment to enable log
        #log prefix "[nftables] Forward Denied: " flags all counter drop
    }
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

Few words about `counter`:
After set a `counter` in the rule, you can see the number of packages that this rule applied to by list this rule.

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

```bash
nft flush table <some-table>
nft flush ruleset
```

If nftable is blocking some services, enable the log.
Add corresponding rules based on the content of the log:

```bash
sudo tail /var/log/syslog -n 500 | grep nftables # sample command to read the log
# edit the config...
```

Notice for `docker` users: you might need to add additional "forward" policies for `docker`.

### Reference for nftables

* [nftables - ArchWiki](https://wiki.archlinux.org/index.php/nftables)
* [Quick reference-nftables in 10 minutes - nftables wiki](https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes)
* [nftables wiki](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
* [Firewalling using nftables](https://mirrors.deepspace6.net/Linux+IPv6-HOWTO/x2561.html)