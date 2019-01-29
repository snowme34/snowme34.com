# Set Up Debian 9.5 Server on Digital Ocean

## Preparation

Generate a ssh key file using the tool you like on your platform and upload to digital
ocean, and use it when creating the Droplet at the very beginning.

And a float ip is also highly recommended. I have created and destroyed lot of droplets but the ip stays the same.

## Set Up Non-Root User as Root

### Add Aliases (Optional)

```bash
vim .bashrc # add alias for 'la' and so on
source .bashrc
```

Some of my aliases for root

```bash
alias ll="ls -l"
alias la="ls -lhA"
alias ..="cd .."
alias fhere="find . -type f -print0 | xargs -0 grep"
```

### Digital Ocean Debian 9.5 Bug

[Tackle](https://www.digitalocean.com/community/questions/debian-9-3-droplet-issues-with-useradd) Digital Ocean cloud-init and here is
the [Official](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-debian-9) one for that issue

```bash
# note if you do not have the issue then there is no need to run the following command
apt-get remove --purge unscd
# userdel -r debian
```

### Add Non-Root User and Install sudo

It's normal if already installed. But it
is still required to add the user to the group.

```bash
adduser __NAME__ # add user

apt update
apt upgrade
apt install sudo
usermod -aG sudo __NAME__
```

### Give Non-Root User ssh-key

Method 1: still as root

```bash
cp -r ~/.ssh /home/__NAME__
chown -R __NAME__:__NAME__ /home/__NAME__/.ssh
chmod 700 /home/__NAME__/.ssh
chmod 600 /home/__NAME__/.ssh/authorized_keys
```

Method 2: switch to that user

```bash
su - __NAME__

mkdir .ssh
chmod 700 .ssh
vim .ssh/authorized_keys # add public key, copy paste or copy from root (?), pay attention to the permission
chmod 600 .ssh/authorized_keys
```

We are done with root.

## Secure the Server

### Setup for Non-Root User

Add aliases

```bash
vim .bash_aliases
source .bashrc
```

Change default editor

```bash
# install the editor
sudo update-alternatives --config editor
```

Add .vimrc if using vim (not provided here)

```bash
vim ~/.vimrc
# add color scheme etc.
```

### Harden SSH

```bash
sudo vim /etc/ssh/sshd_config
```

Change the config

```bash
Port # change to some port you like
PermitRootLogin no
PasswordAuthentication no
```

Make sure you would not lock yourself out of your server and **apply the changes**

```bash
sudo systemctl restart sshd
```

If ever locked out, try the VNC connection (Console Access) on Digital Ocean's website,
the "Access" dashboard for the droplets.

If you want something fancy, you can choose to:

* specify users who can ssh login
* use [Google Authenticator](https://wiki.archlinux.org/index.php/Google_Authenticator) (ArchWiki)!
* port knocking
  * send a ICMP packet first then allow the source ip to ssh
  * send a tcp packet first to a specific port then open that port as ssh port
  * etc.
* port multiplexing

The Authenticator one is recommended.

### Add apt source list (optional)

The following commands are only examples.

```bash
sudo vim /etc/apt/sources.list
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
wget https://www.dotdeb.org/dotdeb.gpg
sudo apt-key add dotdeb.gpg
sudo aptitude update
```

### Set Hostname (optional)

```bash
hostnamectl set-hostname <some-name>
```

### Configure Firewall (iptables/nftables)

Using other front-ends are also acceptable (but not recommended)

See my other [page](https://docs.snowme34.com/en/latest/reference/devops/debian-firewall-nftables-and-iptables.html) for more details on firewall config (including more explanation about each command).

* The following rules will **NOT** apply to everyone and every situation, they are just my naive preference
* [Debian encourages](https://wiki.debian.org/nftables) people to use **nftables**

#### iptables

The order matters, don't block yourself out of your server.

```bash
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# change to your ssh-port
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
# simply accept the ping request
sudo iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
# Timestamp request
sudo iptables -A INPUT -p icmp -m conntrack --ctstate NEW --icmp-type 13 -j ACCEPT
# http, https
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
# drop INPUT
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo iptables -P INPUT DROP
# limit for forward
sudo iptables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "[iptables] FORWARD_denied: " --log-level 7
## customization
#sudo iptables -A INPUT -p tcp -m multiport --dports xxx,yyy -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#sudo iptables -A INPUT -p udp -m multiport --dports xxx,yyy -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
# drop FORWARD
sudo iptables -P FORWARD DROP
```

#### ip6tables

```bash
sudo ip6tables -A INPUT -i lo -j ACCEPT
sudo ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# change to your ssh port
sudo ip6tables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
sudo ip6tables -A INPUT -p ipv6-icmp --icmpv6-type 128 -j ACCEPT

sudo ip6tables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

sudo ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo ip6tables -P INPUT DROP
sudo ip6tables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "[ip6tables] FORWARD_denied: " --log-level 7
sudo ip6tables -P FORWARD DROP
```

#### Post-Config for iptables and ip6tables

List rules and check:

```bash
sudo iptables -L -nv
sudo ip6tables -L -nv
```

Make the rules persistent:

```bash
sudo apt install iptables-persistent # if not installed yet
# sudo dpkg-reconfigure iptables-persistent # if already installed
```

Reference for iptables:

* [BasicSecurity/Firewall - Ubuntu Wiki](https://wiki.ubuntu.com/BasicSecurity/Firewall)
* [DebianFirewall - Debian Wiki](https://wiki.debian.org/DebianFirewall)
* [Firewalls - Debian Wiki](https://wiki.debian.org/Firewalls)
* [Control Network Traffic with iptables](https://www.linode.com/docs/security/firewalls/control-network-traffic-with-iptables)
* [Iptables Essentials: Common Firewall Rules and Commands | DigitalOcean](https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands)
* [How To Choose an Effective Firewall Policy to Secure your Servers | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-choose-an-effective-firewall-policy-to-secure-your-servers)
* [Basic iptables template for ordinary servers (both IPv4 and IPv6)](https://gist.github.com/jirutka/3742890)

#### nftables

List current ruleset:

```bash
nft list ruleset
```

Edit the conf file (located at /etc/nftables.conf):

```conf
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;

        iifname lo accept

        tcp dport 22 ct state new accept # change to your ssh port
        ct state established,related accept

        # no ping floods:
        ip protocol icmp icmp type echo-request limit rate over 10/second burst 4 packets drop
        ip6 nexthdr icmpv6 icmpv6 type echo-request limit rate over 10/second burst 4 packets drop

        # ICMP & IGMP
        ip6 nexthdr icmpv6 icmpv6 type { echo-request, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-reduction, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, nd-neighbor-solicit, nd-neighbor-advert, mld-listener-report } accept
        ip protocol icmp icmp type { echo-request, destination-unreachable, router-solicitation, router-advertisement, time-exceeded, parameter-problem } accept
        ip protocol igmp accept

        # avoid brute force on ssh:
        tcp dport 22 ct state new limit rate 15/minute accept # change to your ssh port

        tcp dport { http, https} ct state established,new accept
        udp dport { http, https} ct state established,new accept

        ct state invalid drop

        # uncomment to enable log
        #log prefix "[nftables] Input Denied: " flags all counter drop
    }
    chain forward {
        type filter hook forward priority 0; policy drop;
        tcp dport { http, https } ct state { established,new } accept
        udp dport { http, https } ct state { established,new } accept

        # uncomment to enable log
        #log prefix "[nftables] Forward Denied: " flags all counter drop
    }
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

Apply the conf

```bash
sudo /etc/nftables.conf
```

Note it's required to write the conf at that file to make it persistent.

Also make sure the systemd unit, "nftables", is enabled and started as required.

```bash
sudo systemctl enable nftables
sudo systemctl start nftables
sudo systemctl status nftables
```

Hope Debian buster will make the nftable easier to use (currently a lot of software still does not support it natively).

Reference for nftables:

* [ArchLinux Wiki nftables](https://wiki.archlinux.org/index.php/nftables)
* [nftables Quick reference-nftables in 10 minutes](https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes)
* [nftables Wiki Main Page](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
* [Linux IPv6 HOWTO (en)](https://mirrors.deepspace6.net/Linux+IPv6-HOWTO/x2561.html)

#### Firewall of Digital Ocean

Log out and go back to Digital Ocean and config their firewall as above also. This is optional
but it's easier to config and apply to other Droplets!

### fail2ban

In short, `fail2ban` blocks if some ip is accessing a service too frequently

Use this tool to make it a little bit harder for attackers to hack.

Note it may be required to config `fail2ban` to use `nftables` not `iptables`

```bash
sudo apt install fail2ban
cd /etc/fail2ban
sudo cp fail2ban.conf fail2ban.local
sudo cp jail.conf jail.local
# edit the 2 local conf files based on user's situation
vim fail2ban.local
vim jail.local
sudo systemctl restart fail2ban
```

## Reference

* [Initial Server Setup with Debian 8](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-debian-8)
* [Initial Server Setup with Debian 9](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-debian-9)