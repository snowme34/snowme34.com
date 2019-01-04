# Linux User and Group

## Basic

Each file in the system has a owner user and a owner group.

Each user has a UID (User Identifier). The system uses UID to identify users.

Each group has a GID (Group Identifier)

Each process is executed as a user, and its access restricted according to the
access restriction of that user.

Each user has an assigned login shell.

## User

### User Identifier (UID)

A 32-bit unsigned int that begins from 0.

Usually for compatibility, the numerical value (for auto assigned UID) is smaller than 60000.

But it can be changed in `login.defs`, for example.

### Categories

Please note that there is no strong restriction here.

* root
  * UID is 0
  * no restrictions for name, but somebody or something might expect such a name
* system users
  * UID ranges from 1 to 499 or 999 (non-mandatory)
  *	used for specific services
  * no need for shell login
* normal users

## Group

To conveniently manage users.

Can be created according to the departments or roles.

Group information is stored in `/etc/group`.

Each user can only have one primary groups and a number of secondary groups.
The limit of number of secondary groups are different on different UNIX systems. (16, 32, 6k)

* [How Many Unix Groups Can A User Be A Member Of?](https://superuser.com/questions/26599/how-many-unix-groups-can-a-user-be-a-member-of)
* [Overview of NGROUPS_MAX on different UNIX systems](https://www.j3e.de/ngroups.html)

By default, the primary group has the same name as the user does.

## Commands

`id`

Display information about current user.

Append different user name to display information about specified user.

`passwd`

Change password.

### Check Logged in Users

```bash
whoami
who    # pts/0 usually means graphic interface
w
```

### Add User

#### Approach 1: `adduser`

If you want an easy and secure and recommended way (possibly not available on some distros).

```bash
adduser # follow the prompt and you are all set
```

[Learn more](https://superuser.com/questions/547966/whats-the-difference-between-adduser-and-useradd)

#### Approach 2: `useradd`

First run `useradd`.

```bash
useradd <some-user-name>

```

Parameters for `useradd`:

-d

* specify the home directory

-s

* specify the 

-u

* specify uid

-g

* specify primary group

-G

* specify secondary group

`useradd` Will add user information in `/etc/passwd`

Second, decide whether or not to set password.

If run `passwd <same-user-name>`, will store the password in `/etc/shadow`

Third, copy the files in `/etc/skel` to the home directory of this new user.
If "-d" was not used, a directory with the same name of the user will be created under `/home`.

* .bash_logout
  * file to run when log out
* .bashrc
  * file to run when log in
* .profile

If "-g" was not used, a group with the same name of the user will be created

#### Approach 3: edit `/etc/passwd`

Not recommended.

### Change User Config

`usermod`

```bash
usermod <options> <username>
```

-l

* new *login* name

-u

* new uid

-d

* new home directory

-g

* new primary group

-G

* new secondary group

-L

* lock the password
* not lock the account

-U

* unlock the password

### Delete User

`userdel`

```bash
userdel [-r] <username> # add -r to delete home directory
```

### Group Commands

```bash
groupadd <groupname>
groupmod -n <newname> <oldname>
groupmod -g <newgid> <oldgid>
groupdel <groupname>

# change current group
sg <groupname> 'somd command'
## OR
newgrp <groupname>
'some commend'
```

## Config Files

`/etc/passwd`

Stores the user information. Each line is one user.

There are 7 parts separated by ':'

1. user name
2. user password
    * "x"
      * password is stored in `/etc/shadow`
    * "!"
      * account is locked
      * user might still be able to log in using other ways (e.g. SSH)
      * see '-l' in man page of `passwd` for more details
      * to avoid bugs, keep this field the same as the password field in `/etc/shadow` if manually edited
3. User ID
4. Group ID
5. Description
6. Home directory
7. login shell
    * no shell
      * `nologin`
        * print a message for user
      * `false`
        * return false

`/etc/shadow`

Store information about password

Same format as passwd

1. user name
2. user password
    * '!!' means the password is not set yet
      * might change on different linux distribution
    * has 3 parts, separated by "$"
      * type of encryption (6 means SHA 512)
      * salt
      * result after encryption (one-direction)
        * can be "solved" using brute force
    * other information

`/etc/group`

1. group name
2. group password
    * in old days, it is needed to switch groups. Now rarely used
3. group ID

`/etc/gshadow`

shadow file for group