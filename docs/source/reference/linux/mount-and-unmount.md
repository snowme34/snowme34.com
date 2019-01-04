# Mount and Unmount

## Intro

After the file system is set up, devices cannot be used until mounted.

Windows and macOS can mount automatically.

Linux without desktop environment or other services will not mount on their own.

It is advised to use `/mnt` directory. But there is no restrictions.

Some disks should be mounted at `/` [Some details about root mount (see highest voted answer)](https://unix.stackexchange.com/questions/9944/how-does-a-kernel-mount-the-root-partition)

## Commands

`mount`

```bash
mount                # display mount information
mount /dev/sda3 /mnt # device-to-mount point-to-mount
```

(Read man page for more details)

-t

* Specify the file system type
* When failed to recognize automatically

-o [options]

* remount
  * re mount
  * must remount if wish to change the mount options
* ro/rw
  * read only
  * read write (default)
* sync
  * disable cache, all operations are written directly to disk
    * Linux usually write changes into cache (in memory) and write to disks when the system is idle
  * may be safer but slower
  * only necessary when the power is very unstable and the data are very important
* async
  * enable cache (default)
* noatime
  * do not update the access time of accessed files
  * improve efficacy especially with high disk operations frequency
* atime
  * access time
  * update access time (default)
* Use commas (,) to separate different flags in one command

`umount`

```bash
umount <some-device>
umount <some-mount-points>
```

un mount

**Must unmount before any operations on file systems.**

### Handle Busy Device

`fuser`

```bash
fuser -m <some-mount-point>
```

file user

Check which process is using given mount point

`lsof`

```
lsof <some-path>
```

list open file

list the files that are being used

## Auto Mount at Boot

`/etc/fstab`

file systems table file

Lines begin with \# are comments

Each line (in 5 parts) represents a auto-mount config:

1. The device to mount
   * e.g. /dev/sda3
   * `LABEL=XXX` can be used to replace `/dev/sda3`
   * UUID can also be used
2. The mount point
3. File system
4. Mount Options (see above)
   * e.g. defaults
5. Options for dump and fsck
   * e.g. 0 0
   * Usually no need to change

Use `Tab` to format

`mount -a`  can be used to mount `fstab`