# Linux File System

## Basics

System uses file system to manage files and data.

## Common File Systems

* fat32 win
* NTFS win
* ext2 Linux
* ext3 Linux
* ext4 Linux
* xfs
* HFS
* fat (msdos)
* nfs
* iso9660
* proc
* gfs (global file system)
* jfs
* vfat

## Difference Among File Systems

* journals
* size of partitions supported
* size of single file
* performance (matters most)

## Journaling file system

File systems with journals are more stable. Can repair after errors.

Their file systems keep track of the changes before committing the changes

Pros: decrease the possibility of corruption after crashes
Cons: at the cost of performance

## Commands

### Create

`mkfs`

```bash
mkfs.ext3 /dev/sda3
```

-b [blocksize]

* specify the size of block

-c

* check bad blocks before creating file system
* be more safe

-L [label]

* assign a label

-j

* create file system with journals
* ext3 ext4 have journals by default

`mke2fs`

```bash
mke2ft -t ext4 /dev/sda3
```

### Inspect

`dumpe2fs`

```bash
dumpe2fs /dev/sda2
```

### Label

`e2label`

```bash
e2label /dev/sda1            # get label
e2label /dev/sda2 MY_DEVICE  # set label
```

Labels are usually all uppercase.

### Check and Repair

`fsck`

```bash
fsck /dev/sda1
```

If outputs 'clean', this file system is good.

**Unmount before run `fsck`.**

-y

* Auto repair without prompts

-t

* Specify the type of file system
* If the file system is very broken, it would be better to specify instead of auto detection

If `fsck` cannot find records for some corrupted data, it will put them under `lost+found` directory.

Some systems will auto run `fsck` at boot. [Ubuntu example](https://askubuntu.com/questions/26141/how-do-i-find-out-if-there-will-be-a-fsck-during-the-next-boot)