# Unix Permissions

## Basic

Permissions are a mechanism to restrict the access to resources.

Each file has specific permissions, owner, and owner group.

Each process is executed as a user. The process has the same privileges as the user does.

Root user has no permission restrictions.

## Categories

There are 3 types of permissions:

* Read (r)
  * read the content of a file
  * list the contents of a directory
  * 2^2 = 4
* Write (w)
  * change the content of a file
  * create or delete files in a directory
  * 2^1 = 2
* Execute (x)
  * run a file as command
  * access the content in a directory
    * Directories without x cannot be 'opened' (check the content inside a directory)
  * 2^0 = 1

Usually permissions are encoded using octal numbers.
For a number 'rwx', r is the 3rd bit, w is the 2nd bit, x is the 1st bit.

Therefore 'rw-' is '110' and thus 6. Same thing for other encodings.

## UGO

There are 3 parts of permissions for the 9 permission bits:

`User Group Other`

* Owner of the file: User, the first 3 bits
* Group of the file: Group, the middle 3 bits
* Other users: Other, the last 3 bits

There are also 3 special bits for a file.

## Inspect Permissions

```bash
$ ls -l
drwxr-xr-- 2 some-user some-group 208 Oct 1 13:50 some-directory
# UGO | number of links | owner | group | size | time of last modification | name
```

```bash
drwxr-xr--

# d:    is directory
# rwx : owner permission
# r-x : group permission
# r-- : other permission
```

## Modify Permissions

`chown`

```bash
chown some-user some-file
chown -R some-user some-directory
```

Change the owner

-R: recursively change all subdirectories and files

`chgrp`

Change the owner group

Same usage as `chown`

`chmod`

```bash
chmod <new_permission> <some_file>

chmod u+rw ./a.out
chmod g-x ./a.out
chmod go+r ./a.out
chmod a-x ./a.out
chmod u+x ./a.sh

chmod 660 ./a.out # rw-rw----
chmod 775 ./a.out # rwxrwxr-x
```

Change the permissions

## Default Permissions

There is something controlling the default permission for a new file created.

`umask`

Subtraction

* Permission for a newly created file: 666 - `umask`
* Permission for a newly created directory: 777 - `umask`

Each user has a umask property

There are 4 bits for umask. The first 3 bits are UGO and the last bit is special permission.

umask value by default:

* normal user
  * 002
  * 666 - 002 = 664
  * rw-rw-r--
* root
  * 022
  * 666 - 022 = 644
  * rw-r--r--

It's actually not subtraction but a bitwise XOR (?)

```bash
umask                   # inspect
umask <new_umask_value> # set
```

## Special Permissions

What about the 'extra' bit, or the 4th bit, of umask?

The real permission in binary is 12bits. UGO uses 9 bits.
The last 3 bits, namely the leading bit of umask, is the [special permission bit](https://docs.oracle.com/cd/E19683-01/816-4883/secfile-69/index.html).

### suid

Run the command with the access permissions of the owner, not the user executing this command.

```bash
$ ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root 53K May 16  2017 /usr/bin/passwd*
```

The 'x' bit of U becomes 's'.

The user executing this command will potentially gain extra access.

Usually, the file name will be colored and highlighted on a terminal with color support.

```bash
chmod u+s  xxx
```

### sgid

Same as 'suid' but uses the permission of the group owner.

The 'x' bit of G becomes 's'.

Usually set for directories. It is commonly used to inherit the permissions of parent directory.

```bash
chmod g+s xxx
```

### Sticky Bit

Users with write access to a directory can only delete the files owned by this user.
They can not delete other files in this directory which are owned by other users.

Used to protect a directory shared by multiple people. Usually within same group.

Usually the directory name will be highlighted using blue color.

```bash
chmod o+t xxx
```

### Octal Numbers for Special Permissions

suid = 4
sgid = 2
sticky = 1

```bash
chmod 4755 xxx
```