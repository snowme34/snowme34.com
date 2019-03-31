# FTP

File Transfer Protocol

Old and popular protocol to share files. It uses TCP.

Client-server architecture.

ports: 20, 21

20: data port
21: ftp server command port

The ports of client are usually unprivileged, i.e. a number larger than 1023

## Mode

FTP runs in 2 modes.

### Active Mode

1. Client prepares a random port P1 to receive data
2. Client sends FTP command PORT P1 to the server port 21 from a random port P2
3. Server initializes one data channel from its port 20 to port P1 on client

Problem: port P1 is usually behind firewall.

### Passive Mode

1. Client sends PASV command to server port 21 from an arbitrary port P2
2. Server sends an IP address and a port P3 to client port P2
3. Client initializes one data channel from another port P1 to port P3 of server

-----------------------------------

There is an additional mode, extended passive mode.

[In FTP, what are the differences between passive and extended passive modes?](in-ftp-what-are-the-differences-between-passive-and-extended-passive-modes)

Passive mode is more common than active mode.

## vsftpd

very secure FTP daemon

Most popular FTP.

### Path

There are generally 3 main config files.

On RedHat/CentOS:

```bash
/etc/vsftpd/vsftpd.conf # main
/etc/vsftpd/ftpusers    # list of users DISALLOWED to log in ftp, such as root
/etc/vsftpd/user_list   # another user list
                        # either blacklist or whitelist, controlled by main config file
```

On Ubuntu:

```bash
/etc/vsftpd.conf
/etc/ftpusers
# Not sure where the user_list file is
```

Shared directory:

* different distribution has different locations

```bash
/var/ftp/
/srv/ftp/
```

Logs:

* some possible locations
* can be changed in config file

```bash
/var/log/vsftpd.log
/var/log/xferlog
```

Some config snippet:

```bash
xferlog_enable=YES
xferlog_std_format=NO
vsftpd_log_file=/var/log/xferlog
```

### Config

By default, everyone can access the default shared directory.

Read the man page of specific distribution to get more tuned config.

[Debian vsftpd.conf Man Page](https://manpages.debian.org/stretch/vsftpd/vsftpd.conf.5.en.html)

#### Disable anonymous user

In `/etc/vsftpd/conf`:

```bash
anonymous_enable=NO
```

#### Allow anonymous upload

[Allow anonymous upload for Vsftpd?](https://serverfault.com/questions/247096/allow-anonymous-upload-for-vsftpd)

Change config

* In `/etc/vsftpd/conf`:

```bash
listen=YES
anonymous_enable=YES
write_enable=YES
anon_upload_enable=YES
anon_mkdir_write_enable=YES
```

* And restart ftp service.

Change permission of directory used to upload

```bash
chown -R ftp /var/ftp
```

Not sure if steps above work,
but consider SELinux and search around when there is problem.

## FTP User

FTP uses user to manage. Clients must log in as a user.

There are 3 type of users for FTP

1. system user
    * all the normal users used to login the system
    * same permission as that user
    * default directory is the home directory
    * **all** users of the system can be used to log in FTP, so we need "blacklist" (as mentioned above)
2. anonymous user
    * no authentication required
    * actually a user called "ftp" whose home is "/var/ftp/"
    * will be created when installing vsftpd
    * can be disabled
3. FTP virtual user
    * FTP-only users

No need to change any config if anonymous user is enough.

## How to Use FTP

GUI is very simple to use.

For CLI use `ftp` command.

## Sample Usage

An FTP directory where people can upload but cannot see the content:

```bash
cd /var/ftp/
mkdir dropbox-upload
chmod 2733 dropbox-upload
```