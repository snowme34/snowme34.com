# NFS

Network File System, a distributed file system protocol.

The most common file sharing protocol among *nix systems.

It shared the file system directly as if the user is mounting
a local storage.

* direct mounting
* efficient
* 3 versions
  * v2, v3, v4

## Protocol

NFSv2 and NFSv3 relies on some RPC (Remote Process Call) services,
which were "rolled into the kernel" later ([ref](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/4/html/Reference_Guide/ch-nfs.html)).

Sample commands to start RPC service:

```bash
service rpcbind start
chkconfig rpcbind on
```

NFSv4 does not need those RPC support and it listens on TCP port 2049.

NFSv4 is also more firewall-friendly (explained later).

NFSv2 originally only used UDP. NFSv2 and NFSv3 both support TCP.
NFSv4 requires TCP.

Sample commands to run NFS service:

```bash
service nfs start
chkconfig nfs on
```

## NFS and Firewall

NFSv2 and NFSv3 use portmap and RPC.

NFSv4 uses TCP port 2209 and no portmap.

By default NFS uses 4 NFS ports and one RPC port.

It is hard to configure firewall for dynamic ports.
But users can specify those ports or use startup scripts
to detect them and change firewall rules. Feel free
to be creative on your own.

How to do it on Debian: [SecuringNFS - Debian Wiki](https://wiki.debian.org/SecuringNFS)

Sample config:

```bash
MOUNT_PORT="1234"
STATD_PORT="1235"
LOCKD_TCPPORT="1236"
LOCKD_UDPPORT="1237"
```

Ports 2049 and 111 are also needed to be able to go through the firewall.

## Sharing

Config file:

```bash
/etc/exports
```

Each line represents one "sharing".

* format is
  * directory to be shared
    * each directory only appears once
  * space
  * allowed hosts and options
    * **NO SPACE** between the host and its options

```bash
/var/some-nfs *.some.domain *.some-other.domain(ro)
/var/their-nfs 1.2.3.4(rw, sync)
/var/my-nfs    192.168.1.0/24(ro, async)
/var/public-nfs (ro)
/var/almost-public-nfs 1.2.3.4(rw, no_root_squash) (ro)
```

Sample command to reload config:

```bash
service nfs start
exportfs -r

exportfs -v       # show verbose status
```

### NFS Options

Default:

* ro
  * read only
* sync
  * reply to client after changes committed (e.g. write to disk)
* wdelay
  * delay writes
  * wait for multiple writes and commit at the same time
  * often improves efficiency
  * no effects if `async` is set
* root_squash
  * map uid 0 (root) to user `nobody`
* ...

Other Options:

* rw
  * read and write access
* async
  * do not wait for change commitment to reply
  * might faster but suffers from crash
* no_wdelay
  * disable wdelay
  * used together with `sync`
* no_root_squash
  * no root_squash

[Learn More](https://linux.die.net/man/5/exports)

## NFS Clients

Clients use `mount` to mount shared NFS

```bash
mount -t nfs 192.168.1.100:/my-nfs /mnt/someone-nfs
mount # check status
```

Or in `/etc/fstab`

```bash
192.168.1.100:/my-nfs /mnt/someone-nfs nfs defaults 0 0
```

Use `nfsvers=4` to specify NFSv4 (not necessary)

* [Network File System (NFS) - Ubuntu](https://help.ubuntu.com/lts/serverguide/network-file-system.html.en)
* [nfs(5) - Linux man page](https://linux.die.net/man/5/nfs)