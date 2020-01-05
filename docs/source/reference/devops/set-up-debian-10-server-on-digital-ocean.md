# Set Up Debian 10 Server on Digital Ocean

This article assumes (and highly recommends) ssh login with key-only authentication

(Published for **personal reference purpose**)

Brief:

* create non-root user
* harden ssh
* create basic firewall
* install fail2ban

## Preparation

* [Generate a ssh key](https://www.google.com/search?q=how+to+generate+ssh+key) file using the tool you like
* [Upload and setup](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server) on Digital Ocean
* Use that key when creating the Droplet (dashboard will prompt this)

(4096 RSA and encrypted with passphrases is recommended)

A [Digital Ocean floating IP](https://www.digitalocean.com/docs/networking/floating-ips/) is great.
I have created and destroyed lot of droplets but can use the same IP all the time, so that all
the API calls, DNS entries etc. can remain un-touched.

## Set Up as Root

Log in

* assume ssh public key is already set up

```bash
ssh root@__HOST__
```

Change editor

* install your favorite editor first
* vim, nano and so on are usually pre-installed

```bash
update-alternatives --config editor
```

### Add Aliases (Optional)

```bash
editor .bashrc
# do the edit... (e.g. add those `alias` commands to that file or uncomment existing alias)
source .bashrc
```

Some of my aliases for root

```bash
alias ll="ls -l"
alias la="ls -lhA"
alias ..="cd .."
alias fhere="find . -type f -print0 | xargs -0 grep"
```

### Add Non-Root User and Enable sudo

It's normal if `sudo` is already installed. But it
is still required to add the user to the group.

* replace `__NAME__` with your own non-root user name

```bash
adduser __NAME__ # add user, only password is needed

apt update
apt upgrade
apt install sudo
usermod -aG sudo __NAME__
```

### Give Non-Root User ssh-key

Method 1: switch user

Case 1: same ssh-key as root's:

```bash
su - __NAME__

mkdir .ssh
chmod 700 .ssh

sudo cat /root/.ssh/authorized_keys > .ssh/authorized_keys

chmod 600 .ssh/authorized_keys
```

Case 2: different ssh-key from root's

* Vim Tip: in normal (command) mode, type `:set paste` and press enter to have smooth copy and paste experience

```bash
su - __NAME__

mkdir .ssh
chmod 700 .ssh

editor .ssh/authorized_keys # copy and paste the key
# or use `scp` to copy

chmod 600 .ssh/authorized_keys
```

Method 2: stay as root

Case 1: same ssh-key as root's:

```bash
cp -r ~/.ssh /home/__NAME__
chown -R __NAME__:__NAME__ /home/__NAME__/.ssh
chmod 700 /home/__NAME__/.ssh
chmod 600 /home/__NAME__/.ssh/authorized_keys
```

Case 2: different ssh-key from root's:

```bash
mkdir /home/__NAME__/.ssh
editor /home/__NAME__/.ssh/authorized_keys     # copy and paste the key, or scp
chown -R __NAME__:__NAME__ /home/__NAME__/.ssh
chmod 700 /home/__NAME__/.ssh
chmod 600 /home/__NAME__/.ssh/authorized_keys
```

We are done with root.

Log out:

```bash
exit
```

Or Ctrl+D.

## Secure the Server

Now log in as the non-root user using the ssh-key just uploaded/created.

```bash
ssh __NAME__@__HOST__
```

Only in rare cases we will need to log in as root (and that's not secure).

### Setup for Non-Root User

Add aliases

```bash
editor .bash_aliases
source .bashrc
```

#### Customize bachrc (optional)

Edit `~/.bashrc`

* chang the prompt
  * "the focus in a terminal window should be on the output of commands, not on the prompt"
* add a directory to the PATH
  * note some distributions will add `~/bin` automatically to PATH

```bash
...
# customizations
force_color_prompt=yes
...
## customizations
my_color_prompt=$color_prompt
...
# customizations
if [ "$my_color_prompt" = yes ]; then
  PS1="\[\e[38;2;245;150;170m\]◟(*•᎑•*)ノ♡:\[\e[00m\]\[\e[34m\]\w\[\e[00m\]\[\e[32m\]\$\[\e[00m\] "
else
  PS1="♡◟(*•᎑•*):\w\\$ "
fi
unset my_color_prompt
...
# customizations
PATH=/docker/bin:$PATH # it's better to create that directory before adding this line
```

#### Customize Vim (Optional)

Edit `~/.vimrc`

```bash
# add color scheme etc.
# Example: wget https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim

# change vimrc
vim .vimrc
```

Example `.vimrc`

```bash
" syntax
syntax on
 
" history : how many lines of history VIM has to remember
set history=2000
 
" filetype
filetype on
" " Enable filetype plugins
filetype plugin on
filetype indent on
 
" base
set nocompatible                " don't bother with vi compatibility
set autoread                    " reload files when changed on disk, i.e. via `git checkout`
 
set magic                       " For regular expressions turn magic on
set title                       " change the terminal's title
 
set novisualbell                " turn off visual bell
set noerrorbells                " don't beep
set visualbell t_vb=            " turn off error beep/flash
set t_vb=
set tm=500
 
" show location
" set cursorcolumn
set cursorline
 
" show
set ruler                       " show the current row and column
set number                      " show line numbers
set nowrap
set showcmd                     " display incomplete commands
set showmode                    " display current modes
set showmatch                   " jump to matches when entering parentheses
set matchtime=2                 " tenths of a second to show the matching parenthesis
 
" search
set hlsearch                    " highlight searches
set incsearch                   " do incremental searching, search as you type
set ignorecase                  " ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present
 
" tab
set expandtab                   " expand tabs to spaces
set smarttab
set shiftround
" indent
set autoindent smartindent shiftround
set shiftwidth=4
set tabstop=4
set softtabstop=4                " insert mode tab and backspace use 4 spaces
 
" encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set termencoding=utf-8
set ffs=unix,dos,mac
set formatoptions+=m
set formatoptions+=B
 
" select and compare
set selection=inclusive
set selectmode=mouse,key
 
set completeopt=longest,menu
set wildmenu                           " show a navigable menu for tab completion"
set wildmode=longest,list,full
set wildignore=*.o,*~,*.pyc,*.class

" disable cndent for yml
au FileType yaml setlocal nocindent
 
" ============================ theme and status line ============================
 
" theme
set background=light
colorscheme PaperColor
 
" set mark column color
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange
 
" status line
set statusline=%<%f\%h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\%-14.(%l,%c%V%)\ %P
set laststatus=2   " Always show the status line - use 2 lines for the status bar
```

(Optional) If using [Vundle](https://github.com/VundleVim/Vundle.vim) to manage vim plugins

```bash
sudo apt install git
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
```

### Harden SSH

```bash
sudo editor /etc/ssh/sshd_config
```

Change the config

* change default ssh `Port`
  * it's a **low-benefit security-through-obscurity practice**
  * not recommended but it's a thing
  * don't change if firewall does not support
  * suggested ports from 1025 to 65534
* disable root ssh login `PermitRootLogin no`
  * can no longer ssh as `root`
* disable ssh login with password `PasswordAuthentication no`

```bash
Port <some-other-number>
PermitRootLogin no
PasswordAuthentication no
```

Make sure you would not lock yourself out of your server and **apply the changes**

* change your local ssh client port
  * `ssh __NAME__@<host> -p <new-ssh-port>`
* don't forget the **firewall**, that port must allow in/out connection
  * rules by default are empty, but not necessarily so

```bash
sudo systemctl restart sshd
```

If ever locked out, try the VNC connection (Console Access) on Digital Ocean's website,
the "Access" dashboard for the droplet. Will be able to use the password to log in.

If you want something fancy:

* specify users who can ssh login
* use [Google Authenticator](https://wiki.archlinux.org/index.php/Google_Authenticator) (ArchWiki) for ssh
* port knocking
  * send a ICMP packet first then allow the source ip to ssh
  * send a tcp packet first to a specific port then open that port as ssh port
  * etc.
* port multiplexing

The Authenticator one is recommended.

Now **log out and then log in** with new settings.

### Add apt source list (optional)

If you want software or newer versions that are not included in default source:

Example:

```bash
sudo editor /etc/apt/sources.list
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
wget https://www.dotdeb.org/dotdeb.gpg
sudo apt-key add dotdeb.gpg
sudo aptitude update
```

### Configure Firewall (iptables/nftables)

* Don't forget **replace the ssh port** with your own one
* at this moment (01/04/2020), using `nftable` directly may have significant compatibility issues, like [this](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#ensure-iptables-tooling-does-not-use-the-nftables-backend)

Using front-end wrappers also works (but not needed for straightforward rule sets like the following)

See other [page](https://docs.snowme34.com/en/latest/reference/devops/debian-firewall-nftables-and-iptables.html) for more details on firewall config (including more explanation about each command).

* The following rules will **NOT** apply to everyone and every situation, they are just personal naive preference
* [Debian encourages](https://wiki.debian.org/nftables) people to use **nftables**
  * if you feel the same, follow [their guide](https://wiki.debian.org/nftables) to setup nftables and jump to next section
  * but beware that **not all the applications play well with nft yet**, for example docker might not like it
* and don't run both firewalls at the same time (choose one; use iptables for the purpose of compatibility)

#### iptables

The **order** matters, don't block yourself out of your server (by setting default drop too early for example).

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
sudo iptables -A INPUT -p icmp --icmp-type 0  -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type 3  -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type 8  -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type 11 -m conntrack --ctstate NEW -j ACCEPT

# accept Timestamp request ICMP
sudo iptables -A INPUT -p icmp -m conntrack --ctstate NEW --icmp-type 13 -j ACCEPT

# accept http, https if needed
#sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#sudo iptables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# drop all other INPUT (dangerous line)
sudo iptables -P INPUT DROP

# add other customizations
#sudo iptables -A INPUT -p tcp -m multiport --dports xxx,yyy -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#sudo iptables -A INPUT -p udp -m multiport --dports xxx,yyy -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# allow all output
sudo iptables -A OUTPUT -j ACCEPT

# drop all forward (if not a router)
sudo iptables -A FORWARD -j DROP
```

#### ip6tables

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

# accept http/https
sudo ip6tables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p udp -m multiport --destination-ports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# drop other INPUT
sudo ip6tables -P INPUT DROP

# allow all output
sudo iptables -A OUTPUT -j ACCEPT

# drop FORWARD (if not router)
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

        # established/related
        ct state established,related accept

        # invalid
        ct state invalid drop

        # loopback
        iifname lo accept

        # ssh
        tcp dport 22 ct state new accept # change to your ssh port

        # icmp
        ip protocol icmp accept
        ip6 nexthdr ipv6-icmp accept

        # http(s)
        tcp dport {http, https} accept
        udp dport {http, https} accept

        # uncomment to enable log
        #log prefix "[nftables] Input Drop: " flags all counter drop
    }
    chain forward {
        # drop everything (if not a router)
        type filter hook forward priority 0; policy drop;

        # uncomment to enable log
        #log prefix "[nftables] Forward Drop: " flags all counter drop
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

Also make sure the systemd unit, "nftables", is enabled and started.

```bash
sudo systemctl enable nftables
sudo systemctl start nftables
sudo systemctl status nftables
```

Hope they will make the nftable easier to use (currently a lot of software still does not support it natively).

Reference for nftables:

* [ArchLinux Wiki nftables](https://wiki.archlinux.org/index.php/nftables)
* [nftables Quick reference-nftables in 10 minutes](https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes)
* [nftables Wiki Main Page](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
* [Linux IPv6 HOWTO (en)](https://mirrors.deepspace6.net/Linux+IPv6-HOWTO/x2561.html)

#### Firewall of Digital Ocean

Go to Digital Ocean and config their firewall as above also.
This is optional but it's easier to config (with UI) and apply to other Droplets (in a click)!

### fail2ban

In short, `fail2ban` blocks if some ip is accessing a service too frequently

Use this tool to make it a little bit harder for attackers to hack.

Note it may be required to config `fail2ban` to use `nftables` not `iptables` if necessary

```bash
sudo apt-get install fail2ban
cd /etc/fail2ban
sudo cp fail2ban.conf fail2ban.local
sudo cp jail.conf jail.local

# edit the 2 local conf files accordingly
# can delete anything but customized configs (see example below)
sudo editor fail2ban.local
sudo editor jail.local

# restart to apply changes
sudo systemctl restart fail2ban
```

[Use Fail2ban to Secure Your Server](https://www.linode.com/docs/security/using-fail2ban-for-security/)

My fail2ban.local is an empty file

```bash
```

My jail.local

```bash
[DEFAULT]
bantime = 100m

[sshd]
enabled = true
port    = <some-ssh-port>
```

### Docker (optional)

* [Install docker for Debian](https://docs.docker.com/install/linux/docker-ce/debian)
* [Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/)

```bash
# install docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# start on boot
sudo systemctl enable docker

# add current user to docker group (so that no `sudo` required)
sudo groupadd docker # group might already exist
sudo usermod -aG docker $USER
## log out and log back in to apply this change
```

docker compose

* [Install docker-compose](https://docs.docker.com/compose/install/#install-compose)

* **substitude the version numbers** (1.25.0) with the one you want
  * in both links of the docker-compose executable and the command line completion

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# install bash completion (optional)
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.25.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
# reload to current bash
. /etc/bash_completion
```

### kubectl (optional)

* [install kubectl on linux](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux)

```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# bash completion (optional)
echo 'source <(kubectl completion bash)' >> ~/.bashrc
source <(kubectl completion bash) # load it for current shell

# add my own kubeconfig file
echo "KUBECONFIG=/PATH/TO/MY/KUBECONFIG/" >> ~/.bashrc
```

## Reference

* [Initial Server Setup with Debian 8](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-debian-8)
* [Initial Server Setup with Debian 9](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-debian-9)
* [Initial Server Setup with Debian 10](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-debian-10)