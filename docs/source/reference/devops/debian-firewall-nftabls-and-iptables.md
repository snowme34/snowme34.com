# Debian Firewall nftabls and iptables

* The following rules will **NOT** apply to everyone and every situation, they are just my naive preference
* [Debian encourages](https://wiki.debian.org/nftables) people to use nftables

* Also do not try to run `iptables` and `nftbales` in the same time, "[could lead to unexpected results](https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables)"

## `iptables` 

The order matters, don't block yourself out of your server

```bash
# list current rules
sudo iptables -L -nv
sudo ip6tables -L -nv

# start adding rules
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport <ssh-port> -m conntrack --ctstate NEW -j ACCEPT

sudo iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT # simply accept the ping request

# Timestamp request
sudo iptables -A INPUT -p icmp -m conntrack --ctstate NEW --icmp-type 13 -j ACCEPT
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# 192.168.1.0/24//sudo iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
# SMTP//sudo iptables -A INPUT -p tcp --dport 25 -j ACCEPT
# SMTP(submission)//sudo iptables -A INPUT -p tcp --dport 587 -j ACCEPT
# POP//sudo iptables -A INPUT -p tcp --dport 110 -j ACCEPT
# 143//sudo iptables -A INPUT -p tcp --dport 143 -j ACCEPT
# rsync//sudo iptables -A INPUT -p tcp -s 15.15.15.0/24 --dport 873 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT (15.15.15.0/24 is an example IP)

# Drop all packets that are going to broadcast, multicast or anycast address. (?)
//sudo iptables -A INPUT -m addrtype --dst-type BROADCAST -j DROP
//sudo iptables -A INPUT -m addrtype --dst-type MULTICAST -j DROP
//sudo iptables -A INPUT -m addrtype --dst-type ANYCAST -j DROP
//sudo iptables -A INPUT -d 224.0.0.0/4 -j DROP
//sudo iptables -A INPUT -s 127.0.0.0/8 ! -i lo -j DROP (?)

# start to drop
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo iptables -P INPUT DROP
sudo iptables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "[iptables] FORWARD_denied: " --log-level 7

## customize
sudo iptables -A INPUT -p tcp -m multiport --dports xxx,yyy -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp -m multiport --dports xxx,yyy -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -P FORWARD DROP

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

# ip6tables
sudo ip6tables -A INPUT -i lo -j ACCEPT
sudo ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip6tables -A INPUT -p tcp --dport <ssh-port> -m conntrack --ctstate NEW -j ACCEPT
sudo ip6tables -A INPUT -p ipv6-icmp --icmpv6-type 128 -j ACCEPT

sudo ip6tables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo ip6tables -P INPUT DROP
sudo ip6tables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "[ip6tables] FORWARD_denied: " --log-level 7

## Customization
# todo

sudo ip6tables -P FORWARD DROP
```

Save the rules

```bash
sudo apt install iptables-persistent # if not installed yet
# sudo dpkg-reconfigure iptables-persistent # if already installed
```

**Note:** `docker` needs "FORWARD" to run properly, I changed the rules for nftables but not here.

## Reference for iptables

1. [](https://wiki.ubuntu.com/BasicSecurity/Firewall)
2. [](https://wiki.debian.org/DebianFirewall)
3. [](https://wiki.debian.org/Firewalls)
4. [](https://www.linode.com/docs/security/firewalls/control-network-traffic-with-iptables)
5. [](https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands)
6. [](https://www.digitalocean.com/community/tutorials/how-to-choose-an-effective-firewall-policy-to-secure-your-servers)
7. [](https://gist.github.com/jirutka/3742890)

## `nftables`

```bash
nft list ruleset
```

The conf file (located at /etc/nftables.conf):

```conf
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
        chain input {
                type filter hook input priority 0; policy drop;

                iifname lo accept

                tcp dport <ssh-port> ct state new accept
                ct state established,related accept

                # no ping floods:
                ip protocol icmp icmp type echo-request limit rate over 10/second burst 4 packets drop
                ip6 nexthdr icmpv6 icmpv6 type echo-request limit rate over 10/second burst 4 packets drop

                # ICMP & IGMP
                ip6 nexthdr icmpv6 icmpv6 type { echo-request, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-reduction, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, nd-neighbor-solicit, nd-neighbor-advert, mld-listener-report } accept
                ip protocol icmp icmp type { echo-request, destination-unreachable, router-solicitation, router-advertisement, time-exceeded, parameter-problem } accept
                ip protocol igmp accept

                # avoid brute force on ssh:
                tcp dport <ssh-port> ct state new limit rate 15/minute accept

                tcp dport { http, https} ct state established,new accept
                udp dport { http, https} ct state established,new accept

                tcp dport { xxx, yyy} ct state established,new accept
                udp dport { xxx, yyy} ct state established,new accept

                ct state invalid drop

                #log flags all counter drop
        }
        chain forward {
                type filter hook forward priority 0; policy drop;
                tcp dport { http, https } ct state { established,new } accept
                udp dport { http, https } ct state { established,new } accept
                # for dockers
                # dockers have plenty of networks, so it may be required to change accordingly
                iifname eth0 oifname docker0 ct state { established,new,related } accept
                oifname eth0 ct state { established,new,related } accept
                tcp dport { xxx, yyy } ct state established,new accept
                udp dport { xxx, yyy } ct state established,new accept
        }
        chain output {
                type filter hook output priority 0; policy accept;
        }
}
```

Note it's required to write the conf at that file to make it persistent.

Reference for nftables:

* [](https://wiki.archlinux.org/index.php/nftables)
* [](https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes)
* [](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
* [](https://mirrors.deepspace6.net/Linux+IPv6-HOWTO/x2561.html)

Troubleshooting note: if anything goes wrong, flush and reload the config file.

Disable the old one if running the new one.