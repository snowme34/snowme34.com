# Unix and Linux Commands

*Last Update: 07/02/2019.*

This is a collection of general *nix commands.

For commands of specific task (not found here), see the specific reference section of this website.

(For example, the commands about managing "file systems" are introduced at [Linux File System — Docsnt documentation](https://docs.snowme34.com/en/latest/reference/linux/linux-file-system.html))

## How to Use

This is not a tutorial.

See the table of contents and search for keyword.

- [Unix and Linux Commands](#unix-and-linux-commands)
  - [How to Use](#how-to-use)
  - [Prologue](#prologue)
  - [Philosophies and Notes](#philosophies-and-notes)
  - [Basics](#basics)
  - [Keyboard Shortcuts](#keyboard-shortcuts)
  - [Navigation](#navigation)
  - [Files](#files)
  - [Directory](#directory)
  - [Links](#links)
  - [Find](#find)
  - [Archive and Compress](#archive-and-compress)
  - [Help](#help)
  - [Previous Commands](#previous-commands)
  - [Input and Output](#input-and-output)
  - [Filters and Text Manipulation](#filters-and-text-manipulation)
  - [Date and Time](#date-and-time)
  - [Names](#names)
  - [Users](#users)
  - [Privileges and Permissions](#privileges-and-permissions)
  - [Process Management and Resource Monitor](#process-management-and-resource-monitor)
  - [Network](#network)
  - [Free Cache](#free-cache)
  - [Environment and Global Variables](#environment-and-global-variables)
  - [Scripting](#scripting)
  - [Schedule](#schedule)
  - [Run in a Shell](#run-in-a-shell)
  - [Build and Install](#build-and-install)
  - [Debugging](#debugging)
  - [Popular Paths](#popular-paths)
  - [Uncanny Commands](#uncanny-commands)
  - [Message](#message)
  - [Hardware Information](#hardware-information)
  - [Disk and Filesystem](#disk-and-filesystem)
  - [Run levels](#run-levels)
  - [Power](#power)
  - [Printers](#printers)
  - [Gpg Signature](#gpg-signature)
  - [Distribution Specific](#distribution-specific)
    - [Debian](#debian)
  - [Miscellaneous](#miscellaneous)

## Prologue

As the most common operating systems in production environments, *nix systems are known for their command line interface (cli).

For people working with "systems", even not professional DevOps, the familiarity with *nix cli still corresponds with the level of experiences in development.

Things are ordered from general fundamentals to specific tips.

## Philosophies and Notes

* [Everything is a "file"](https://en.wikipedia.org/wiki/Everything_is_a_file), including the shell, the devices, the directories.
* Shell is very serious with spaces. Pay extra heed when writing scripts.

* The brackets are meaningful in bash, I used them to represent user input if not specified otherwise.
* [Here](http://bashoneliners.com) is a small website for oneline commands.

The exit values of commands:

```markdown
| Value | Status            |
| ----- | ----------------- |
| 0     | success           |
| non-0 | failure           |
| 2     | incorrect usage   |
| 127   | command not found |
```

Shell built-in vs external

* some commands are only built-in in shell (`man builtins`)
* some are only external (actually the majority)
* others have both versions (e.g. `kill`)

```bash
help
command -V command
builtin kill
/bin/kill
```

## Basics

1. Open current path using GUI file explorer

    * Different systems have different file explorers, it's hard for me to test each one
    * See [here](https://wiki.archlinux.org/index.php/Category:File_managers) for more
    * Pay attention to the privileges, it's generally not good to run as root

    ```bash
    nautilus . # Ubuntu?
    nemo .
    dolphin . # Arch Linux?
    ```

2. Redirection and pipes

    * Sometimes you want to save output of a command as a file
    * Or you want to use a file as input of a command
    * Or you want to use output of a command as input of another file
    * different streams (FD):
        * 0: stdin
        * 1: stdout, default for `>` and `>>`
        * 2: stderr
    * `/dev/null` is a magic file, everything redirected to it is magically discarded
    * order of redirection does not matter

    ```bash
    # a.txt will be cleared and only consist of this line
    echo "write this line into file a.txt" > a.txt
    # the original content of a.txt would not be affected
    echo "append this line into file a.txt" >> a.txt

    # feed a small c program that reads input from STDIN with test_input
    ./a.out < test_input
    # store the errors and discard the standard output
    ./a.out 2>> err_log 1> /dev/null
    # two streams go to the same destination (2 is tied with 1)
    ./a.out > afile 2>&1
    # order does not matter
    > count.txt 2> log.txt wc < shakespeare.txt

    # only output lines containing "file"
    man cat | grep file
    # list all files in root directory and output only the last 10 lines
    ls -lha / | tail -n 10

    cat << TerminationSign
    > asdfdas
    > asdfdsa
    > TerminationSign (can be anything)

    cat << END > ShortScript.sh
    > #!/bin/bash
    > echo "I love bash"
    > END
    ```

3. Escape and back quote

    * to escape bash keywords, `\`
    * to use the output of a command, shell will treat strings inside \`\` as commands

    ```bash
    echo -e "bash\tis\tgood!"
    echo `echo "I like bash!"`
    ```

4. Test and true and false

    * true or false
    * '\[' is the same as test

    ```bash
    test
    true
    false
    ```

5. Change shell mode

    ```bash
    set -o vi # set vi mode
    ```

6. Multiple lines

    * use ';' to run multiple commands in one line
    * use '\\' to separate one-line commands
        * note that you will see the so-called second prompt (PS2) here, usually ">"

    ```bash
    echo this; echo that
    echo "this \
    that"
    ```

7. Comments

    ```bash
    #
    ```

8. Quote

    ```bash
    "" # weak quote
       # $var are variables
       # back quotes and escape characters are processed
    '' # strong quote, everything is string
    `` # back quote, the primary output of the command inside with replace this string
    ```

9. Aliases

    * alias is just shortcuts or macros
    * use \\ at the beginning of a command to avoid aliases

    ```bash
    alias "rm -rf"="echo 'rm? how dare you?'"
    \rm -rf ./*.class
    ```

## Keyboard Shortcuts

`^` stands for Ctrl

1. Abort (SIGINT)

    ```bash
    ^c
    ```

2. Suspend (signal 17, SIGTSTP)

    ```bash
    ^z
    ```

3. Go to the beginning of line

    ```bash
    ^a
    ```

4. Go to the end of line

    ```bash
    ^e
    ```

5. Delete content after cursor

    ```bash
    ^k
    ```

6. Clear the screen

    ```bash
    ^l
    ```

7. Log out current session

    ```bash
    ^d
    ```

8. Search in the history

    ```bash
    ^r
    ```

9. Autocompletion of commands or paths (Press twice to see all available ones if not unique)

    * maybe it's required to type a letter first then press `Tab` twice?

    ```bash
    [Tab]
    ```

10. Go to last command

    ```bash
    [Up Arrow]
    ```

11. Fetch the parameters of last command

    * Press together

    ```bash
    [Esc]+.
    ```

12. Pause/Freeze the terminal

    ```bash
    ^s
    ```

13. Resume the terminal

    ```bash
    ^q
    ```

For cursor movement, [here](https://clementc.github.io/blog/2018/01/25/moving_cli/) is an excellent picture.

## Navigation

1. See current directory

    * -1 one column
    * -R recursive listing all files in subdirectories
    * -t time
    * -a show all files (hidden files)
    * -h human friendly (change units)
    * -l show in detail
    * -R show subdirectory recursively
    * -ld show dir info and link info
    * My favorite one: `ls -lha`

    ```bash
    ls
    ls -a -l -R -D -C -h -F --color=auto
    ls -CF
    ls -lhAf
    ls -lhaF
    ls -l
    ls --color=auto
    ```

2. Print current path

    ```bash
    pwd
    ```

3. Change directory

    * .. parent directory
    * . current directory
    * ~ home
    * \- back to last dir (useful)

    ```bash
    cd # go home
    ```

## Files

1. Create blank file or update last-change time

    ```bash
    touch
    ```

2. See file type and char-set and other information

    ```bash
    file
    file -i [file]
    ```

3. See file disk usage

    * -h human-reading friendly
    * -s sum
    * -a all files not just directories
    * -dN max-depth=N

    ```bash
    du
    du -sh
    du -s *
    du -hs .[^.]*
    du -sch .[!.]* * | sort -h
    du -hd1 | sort -h
    du -ahd1 | sort -h
    ```

4. Copy

    * -r dir
    * -v verbose
    * -p reserve time

    ```bash
    cp [source] [target]
    scp [source] [target] # secure copy, copy across ssh and so on
    ```

5. rsync

    * -n dry-run
    * -a archive
    * -v verbose
    * -h human-friendly size
    * -u update, skip newer files on the receiving side
    * remove dry-run after checking the result

    ```bash
    rsync -avh --dry-run <source> <target>    # copy and overwrite, no deletion
    rsync -u -ah --dry-run <source> <target> # copy and overwrite for files that are newer in source
    ```

6. Move and rename

    * -v verbose
    * `mv` treats directories and files the same

    ```bash
    mv [source] [target]
    ```

7. Delete

    * -i interactive
    * -r dir
    * -f force
    * rm -rf ./* delete all files in current dir
    * su"do r"m -r"f /* Say goodbye to your system (Never run this!!!!!)

    ```bash
    rm
    ```

8. Quota

    ```bash
    quota -v
    ```

9. File system disk space usage

    * troubleshoot

    ```bash
    df
    df .
    df -k  # use 1k as SIZE scale
    ```

Pay heed to the difference between `du` and `df`

## Directory

1. Create new dir

    * -p Create parents if necessary
    * -v verbose

    ```bash
    mkdir
    mkdir -pv [name]
    ```

2. Remove empty dir

    * Note: use "rm -r" to remove non-empty dir

    ```bash
    rmdir
    rmdir -pv
    ```

## Links

1. Crate a soft links

    ```bash
    ln -s [source-file] [link]
    ```

## Find

1. Find file by name using prebuilt databases

    * Like pre-processing the files
    * the database is updated per day by default
    * cannot lookup the file changes after the last update

    ```bash
    locate [pattern-to-find]
    updatedb # update the database, may be slow
    ```

2. Find

    * Advanced find
    * Specify the path
    * More options
    * Real-time scan
    * path
        * . current directory
        * / root directory (all files)
    * arguments
        * -name [name]
        * -perm [permissions]
            * can only use octal representation
        * -type
            * d directory
            * l link
        * -user
        * -group
        * -ctime change time
        * -size
    * use the result to execute commands
        * -exec

    ```bash
    find [path] [arguments]

    # call ls -l on all files in current directory whose names start with 'a'
    find . -name "a*" -exec ls -l {} \;

    # search all files in current directory for pattern
    # and print the paths of those files
    find . -type f -print0 | xargs -0 grep "pattern"
    # only files, no paths
    find . -type f -print0 | xargs -0 grep -l "pattern"
    ```

3. Where is this command/program I'm executing?

    ```bash
    which
    which which
    ```

## Archive and Compress

[How are zlib, gzip and zip related? What do they have in common and how are they different?](https://stackoverflow.com/questions/20762094/how-are-zlib-gzip-and-zip-related-what-do-they-have-in-common-and-how-are-they)

1. Zip and Unzip

    ```bash
    zip [archive-file-name] [files-to-archive]
    zip a.zip a

    unzip file[.zip]
    ```

2. gzip and gunzip

    * compress

    ```bash
    gzip
    gunzip
    ```

3. tar

    * archive only, no compress
    * -c create
    * -x extract
    * -v verbose, can (should?) omit when there is a number of files
    * -z gzip
    * -f use archive file or device ARCHIVE

    ```bash
    # archive a file
    tar -cvf [archive-file-name] [files-to-archive]
    tar -cvf a.tar a.b b.c

    # archive and compress
    tar -cvzf [archive-file-name] [files-to-archive-and-compress]
    tar a.tar.gz a.b b.c

    # extract a archive
    tar -xvf [archive-file]
    tar -xvf a.tar

    # extract and uncompress
    tar -xvzf [compressed-archive-file name]
    tar -xvzf a.tar.gz

    # extract to different directory
    # the target director must exist
    tar -xvzf a.tar.gz -C [/target/directory]
    ```

## Help

1. help

    * Almost all commands have `help` option
    * It's a summary of the usage
    * This is always the first option before using an unfamiliar command

    ```bash
    [command] -h
    [command] --help

    help [command] # a command called help, mainly for shell build-in commands
    ```

2. man (manual)

    * Explain a command
    * If exists, more detailed than `help`
    * A detailed usage instruction
    * You can even look up C language libraries
    * Types (from `man man`)
        1. Executable programs or shell commands
        2. System calls (functions provided by the kernel)
        3. Library calls (functions within program libraries)
        4. Special files (usually found in /dev)
        5. File formats and conventions eg /etc/passwd
        6. Games
        7. Miscellaneous  (including  macro  packages  and  conventions),  e.g. man(7), groff(7)
        8. System administration commands (usually only for root)
        9. Kernel routines [Non standard]
    * -k [key word]
      * search for all documentation with key word

    ```bash
    man ascii
    man -s3 malloc # c function
    man echo
    ```

3. info

    * more detailed than man

4. doc

    * txt, html, pdf
    * stored at /usr/share/doc

5. What is this command (one-line description)

    ```bash
    whatis
    ```

6. Forget how to spell a command

    ```bash
    apropos
    ```

## Previous Commands

1. See history

    ```bash
    history
    ```

The event reference (!) is mainly used in scripts?

1. Run the last command

    ```bash
    !!
    ```

2. Run the last command beginning with a specific letter

    ```bash
    ![specific letter]
    ```

3. Run the command by number in history (use `history` to see the number)

    ```bash
    ![number]
    ```

4. Execute the command containing specific string

    ```bash
    ![specific_string]
    ```

5. Execute the nth preceding event (i.e. using a negative number for the index)

    ```bash
    !-[number]
    ```

6. Last word of previous command

    * Can be used to test if in same shell
    * Safe way to rm

    ```bash
    !$
    ls xxx.yyy
    rm !$
    ```

7. Replace part of previous commands

    * I think only few people know this
    * sample command from [@bashoneliners](http://bashoneliners.com/oneliners/oneliner/209/)

    ```bash
    # change encoding of all files in a directory and subdirectories
    find . -type f  -name '*.java' -exec sh -c 'iconv -f cp1252 -t utf-8 "$1" > converted && mv converted "$1"' -- {} \;
    ^java^cpp

    # safe way to remove
    ls xxx
    ^ls^ rm -v
    ```

## Input and Output

1. Display a line of text

    * -n no new line at the end
    * -e expand special characters and variables

    ```bash
    echo
    echo "xxx" >> [file]
    echo "xxx" > [file]
    echo -e "$!"
    ```

2. Display all the content of one file

    ```bash
    cat
    cat a.txt > b.txt
    ```

3. Display the head of one file

    * -n Display the first n lines

    ```bash
    head
    head -n 10
    ```

4. Display the tail of one file

    * -n
    * -f Follow the latest updates of one file (usually used to watch the log files)
    * -F (recommended) same as -f but "keep trying to open a file if it is inaccessible"
      * can track when renaming
      * avoid confusion when logs are rotated

    ```bash
    tail
    ```

5. Paging through text (downward only)

    * q to quit

    ```bash
    more
    ```

6. Paging through text

    * q to quit
    * less is more

    ```bash
    less
    ```

7. Read input

    ```bash
    read var_1
    # type input
    echo "$var_1"
    ```

8. Watch a command, namely keep printing the output of a command

    * -n interval
    * -c color

    ```bash
    watch -c -n 1 command
    ```

## Filters and Text Manipulation

1. Search for specific pattern

    * -i ignore case
    * -n precede line numbers
    * -v lines with no specific patterns
    * -Ax include x lines after the pattern in output
    * -Bx include x lines before the pattern in output
    * [What is the difference between `grep`, `egrep`, and `fgrep`?](https://unix.stackexchange.com/questions/17949/what-is-the-difference-between-grep-egrep-and-fgrep)

    ```bash
    grep [file] [string]
    pdfgrep # grep in pdf files
    ```

2. sort

    * sort based on character or number
    * use alphabet and numbers by default
    * -r reverse
    * -n sort numerically
    * -f ignore case
    * -u unique, remove duplicated lines
    * -t SEP use SEP as delimiter/separator
    * -k KEYDEF specify the key to use when sorting

    ```bash
    ps -aef | sort > out.txt
    ```

3. Remove consecutive identical lines

    * Usually needs to be sorted first
    * -c precede line with number of repetitions
    * -d only repeated lines
    * -u only non-repeated lines

    ```bash
    uniq
    ```

4. Word count

    ```bash
    wc
    wc -l # lines
    wc -w # words
    wc -c # bytes
    wc -m # characters
    ```

5. diff

    * output means the edits that is required to make file1 identical to file2
      * append
      * delete
      * change
    * '<' means line from file1
    * '>' means line from file2

    ```bash
    diff file1 file2
    vimdiff
    ```

6. Cut text

    * Used to process specific columns of the delimited text
    * -d specify the delimiter, TAB by default
    * -f specify the number of column to output
    * -c cut based on characters

    ```bash
    cut
    cut -b [bytes] # select only specified bytes
    cut -c 1-2, 3, 6 # characters
    cut -d ' ' # use ' ' as delimiter

    cut -d: -f1 /etc/passwd
    grep some-user /etc/passwd | cut -d: -f2,3,4
    cut -c2-6 /etc/passwd # output from 2nd character to 6th character
    ```

7. Paste

    * Merge lines of files
    * like reverse of `cut`

    ```bash
    paste
    paste -d ' ' file1 file2 file3 > output
    ```

8. Check spelling

    ```bash
    aspell
    aspell check <some-file>
    aspell list < <some-file>
    ```

9. Translate

    * needs redirection

    ```bash
    tr -d 'some-words' < <some-file> # delete some-words from some-file
    tr 'a-z' 'A-Z' < <some-file> # change case
    ```

10. Search and replace

    * regular expression
    * write to stdout

    ```bash
    sed 's/aaa/bbb/g' <some-file> # replace 'aaa' with 'bbb', 'g' for global
    sed '1,50s/aaa/bbb/g' <some-file> # specify the lines
    sed -e 's/aaaa/bbb/g' -e 's/ccc/ddd/g' <some-file>
    sed -f <some-script> <some-file> # use a file as script
    ```

## Date and Time

1. Show or set current date and time

    * +%Y--%m--%d (e.g.)
      * Print time in specific format
      * `%` is the identifer
    * -u Greenwich time
    * -s setting

    ```bash
    date
    ```

2. Show hardware time (time on the motherboard)

    ```bash
    hwclock
    clock
    ```

3. Calendar

    ```bash
    cal
    ```

4. Up time

    * troubleshooting
    * Output is consist with:
        * uptime
        * Login users
        * load
            * average number of processes in "run" or "ready" queue of 1 min, 5 min and 15 min
            * note that machine may have more than one CPU
            * 1 means 100% load for one CPU
            * not that fantastic anymore since majority of systems run on multi-core CPUs
        * also consider processes blocked due to I/O, shown as load

    ```bash
    uptime
    ```

## Names

1. System

    ```bash
    uname
    uname -a
    ```

2. Host

    ```bash
    hostname
    ```

## Users

1. Switch user

    * if empty, switch to root

    ```bash
    su - [user]
    ```

2. Switch user and keep current path

    * if empty, switch to root

    ```bash
    su [user]
    ```

3. Run as root

    ```bash
    sudo
    sudo -E                # pass environment
    sudo SOME_VAR=SOME_VAL # pass variable

    sudo -i # a shell

    [sudo] SOME_CMD | sudo tee SOME_WRITE_FILE    # redirection
    [sudo] SOME_CMD | sudo tee -a SOME_WRITE_FILE # redirection append
    ```

4. Log out

    ```bash
    exit
    ```

5. Change password

    ```bash
    passwd
    ```

6. User Id

    ```bash
    id
    ```

7. Who am I?

    * The informal philosophy of commands: the shorter, the more information; the longer, the more specific.

    ```bash
    whoami
    who
    w
    ```

8. Create and delete user

    ```bash
    # add
    useradd
    adduser # a wrapper of useradd
    # passwd [user] # set password if not already

    # del
    deluser --remove-home [user] # Debian-based
    userdel -r [user]            # RHEL-based
    ```

9. Create group

    ```bash
    groupadd
    addgroup # a wrapper of groupadd
    ```

10. Fingers

    ```bash
    finger [user] # display user's information if exists
    chfn # change finger
    ```

11. Administer commands

    ```bash
    gpasswd # administer /etc/group and /etc/gshadow
    yppasswd # ?
    ypchfn # ?
    ```

12. Log out old sessions that was 'broken'

    ```bash
    pkill -u [username]
    ```

13. Last logged in user

    * -a: display hostname in last column
    * -i: display ip

    ```bash
    last -5
    last -5ai
    ```

## Privileges and Permissions

`ls -a` can list the permissions of a specific file.

1. Change mode

    * The permissions in *nix is in U/G/O model
    * The representations of permission is ordered by user/group/other
    * There are 3 permissions of a file:
        * r: read, 2^2=4
        * w: write, 2^1=2
        * x: execute, 2^0=1
    * As you can see, the largest permission represented by an integer is the sum of them, 7
    * Try not messing up with permissions until mastering them
    * -R recursive change permission of all files in a directory
    * -f force
    * \[ugo\]\[+-=\]\[rwx\]
    * [Unix Permissions Calculator](http://permissions-calculator.org/)
    * See other places or `man` for details
    * Note that the directories must have permission execute 'opened' to be opened
        * r for directories: can read the list
        * w for directories: create or remove files
        * x for directories: can pass through
    * There are other special permissions. For example, 's' is the [`setuid` bit](https://en.wikipedia.org/wiki/Setuid), meaning that the user who issued the command did not change (no sudo) but the user receives the septics privileges, like `passwd` and `ping`.

    ```bash
    chmod -R [directory]
    chmod -f ...
    chmod u+x [file]
    chmod ug-x [file]
    chmod 640 [file]
    chmod u+x,g-x [file]
    chmod u=rwx [file]
    ```

2. Change ownership

    * -R: recursively change all subdirectories and files

    ```bash
    chown some-user some-file
    chown -R some-user some-directory
    ```

3. SELinux (advanced way to manage permissions)

    * [details](https://people.redhat.com/rsawhill/selinux/)

    ```bash
    sestatus
    getenforce
    seinfo
    setenforce 0 # turn off SELinux totally, bad behavior
    semanage
    ```

4. Default permission when creating a new file

    * It's negated (reversed)
    * [details](http://docs.snowme34.com/en/latest/reference/linux/linux-permissions.html#default-permissions)

    ```bash
    umask
    ```

## Process Management and Resource Monitor

1. Run in background

    ```bash
    [command]&
    ```

2. See processes in background

    * Including the commands executed with `&` at the end
    * and the commands suspended using Ctrl+Z

    ```bash
    jobs
    jobs -l
    ```

3. Put a process in background if not started with `&`, or resume suspended processes (SIGTSTP) in background

    ```bash
    bg [ID]
    ```

4. Put a process back to foreground

    * note the output may still be absent

    ```bash
    fg [ID]
    ```

5. Modify scheduling priority of a program

    * -20 is most favorable
    * 19 is least favorable

    ```bash
    nice -19 [command]
    ```

6. List processes

    * troubleshoot
    * See IDs of processes
    * Read help of `ps` for details
    * e: all processes
    * a: all processes except session leader and processes not associated with a terminal
    * x: display session leader and processes not associated with a terminal (?)
        * e = a + x ?
    * u: userlist
    * w: wide, use twice for unlimited width

    ```bash
    ps
    ps ef   # all processes
    ps aux  # no parent process ID

    ps -ef | grep mysql | grep -v grep | awk '{print $2}' # lookup PID of mysql

    ps axuf
    ps auxww           # output with unlimited width

    ps aux | grep -v grep | grep -i -e VSZ -e
    ps -e -o pid,vsz,comm= | sort -n -k 2

    ps -C bash -o pid= # show pid of bash
    pidof bash         # show pid of bash
    ```

7. Monitor processes

    * troubleshoot
    * `top` is very powerful

    ```bash
    top
    htop
    slabtop
    ```

8. Send signals to process

    * List of "sigspec" and "signum":
        * SIGHUP 1
        * SIGINT 2
        * SIGQUIT 3
        * SIGFPE 8
        * SIGKILL 9
        * SIGALRM 14
        * SIGTERM 15
    * Use `kill -l` for more
    * process can ignore some signals

    ```bash
    kill -l

    # send SIGTERM by default
    kill [id]
    kill -9 [id] # the kill signal cannot be ignored and immediately
                 # skipping the "clean up" before dying

    kill -0 [id] # check if process exists or permission to signal exists

    # note that built-in kill is different from the external kill
    # http://man7.org/linux/man-pages/man2/kill.2.html
    kill -s [sig] 0  # send sig to every process in the process group of the calling process
    kill -s [sig] -1 # all processes except the kill process itself and init
    # If pid is less than -1, then sig is sent to every process in the process group whose ID is -pid.
    ```

9. Run commands that ignore some signals

    ```bash
    trap [command list] [signal]
    ```

10. Do not kill command when log out

    * Usually the processes have parents. As parents die, they die
    * Sometimes we do not want so
    * [Linux: Prevent a background process from being stopped after closing SSH client](https://stackoverflow.com/questions/285015/linux-prevent-a-background-process-from-being-stopped-after-closing-ssh-client)

    ```bash
    nohup [command] > /dev/null 2>&1 &
    ```

11. Show available memories

    * troubleshoot

    ```bash
    free
    free -h
    free -mt
    ```

12. Read syslog

    * troubleshoot

    ```bash
    sudo tail -F /var/log/syslog
    ```

13. system control

    ```bash
    sudo systemctl status nginx
    sudo systemctl list-unit-files
    ```

14. Journals / logs

    * troubleshoot

    ```bash
    sudo journalctl -u docker -b # unit boot
    sudo journalctl -u docker -f # follow
    sudo journalctl -u docker --no-pager # print to stdout
    sudo journalctl -u docker --no-pager > ./some-log # and redirect to a file
    ```

15. Virtual Memory Stat

    * troubleshoot
    * r: running
    * b: blocked
    * io
      * bi: Blocks In
      * bo: Blocks Out
    * in: interrupts
    * cs: context switches
    * cpu (in %)
      * USer
      * SYstem
      * IDle
      * Wait
    * can leave it run for some time and see the trends

    ```bash
    vmstat
    vmstat 1 # per second, output is 1 second average
    ```

16. IO Status

    * troubleshoot

    ```bash
    iostat
    iostat 1 # per 1 sec
    iostat -x
    ```

## Network

1. Net Status

    * troubleshoot

    ```bash
    netstat -s          # show a sweet summary
    sudo netstat -lnp   # show all open ports, including sockets
    sudo netstat -tupln # without sockets

    netstat -an    # all and numerical
    netstat -tan   # tcp
    netstat -tanep # extended and show program
    ```

2. Investigate sockets

    ```bash
    sudo ss -lnp
    ```

3. List activating ports

    ```bash
    lsof
    ```

4. Firewall / iptables

    ```bash
    sudo iptables -Lnv
    sudo ip6tables -Lnv
    sudo dpkg-reconfigure iptables-persistent # iptablessave for debian

    # delete all rules
    sudo iptables -P INPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT
    sudo iptables -P OUTPUT ACCEPT
    sudo ip6tables -P INPUT ACCEPT
    sudo ip6tables -P FORWARD ACCEPT
    sudo ip6tables -P OUTPUT ACCEPT
    sudo iptables -t nat -F
    sudo iptables -t mangle -F
    sudo iptables -F
    sudo iptables -X
    sudo ip6tables -t nat -F
    sudo ip6tables -t mangle -F
    sudo ip6tables -F
    sudo ip6tables -X
    ```

5. IP and interfaces

    ```bash
    ip
    ip link show
    ```

6. Enable bbr

    * [How to Boost Linux Server Internet Speed with TCP BBR](https://www.tecmint.com/increase-linux-server-internet-speed-with-tcp-bbr/)
    * [You must use TCP BBR! ....](https://www.reddit.com/r/linux/comments/86v23e/you_must_use_tcp_bbr/)

    ```bash
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sudo sysctl -p

    # test
    sudo sysctl net.ipv4.tcp_available_congestion_control
    sudo sysctl net.ipv4.tcp_congestion_control
    ```

7. Curl

    * [doc](https://curl.haxx.se/docs/httpscripting.html)

    ```bash
    curl --help
    curl --manual

    # GET
    curl [URL]

    # POST
    curl -d data=data [URL]
    curl --data data=data [URL]
    curl --data-urlencode [data] [URL] # auto encode url for POST
    curl --form upload=@[file_name] --form press=[some_value] [URL] # RFC1867-posting upload file

    # HEAD
    curl --head [URL]
    curl -I [URL]

    # PUT
    curl --upload-file [some_file] [URL]

    # Get more details
    curl -i # include response headers
    curl --verbose
    curl -v # abbr for verbose
    # record everything sends and receives
    curl --trace [dump_file_name]
    curl --trace-ascii [dump_file_name]
    curl --trace-ascii [dump_file_name] --trace-time

    # output
    curl -o
    curl -O

    # multiple urls
    curl [URL1] [URL2] # send same request to multiple urls
    curl [URL1] --next -I [URL2] # send different requests to multiple urls

    # referer
    curl --referer [origin_url] [destination_url]

    # user agent
    curl --user-agent "user agent string" [URL]

    # follow redirection
    curl --location [URL]

    # Cookie
    curl -b # abbr for --cookie
    curl --cookie "data=data" [URL] # send cookie for GET
    curl --dump-header [cookie-dump-file] [URL] # record the cookies
    curl --cookie [previous-dumped-cookie] [URL] # user previous stored cookies
    # preferred way to store cookies, use non-exist file as --cookie parameter to enable cookie engine only
    curl --cookie [previous-cookie-file-name] --cookie-jar [new-cookie-file-name] [URL] # use old cookie and store new

    # https
    curl -k # abbr for --insecure
    curl --insecure # not verifying server-side certificates
    curl --cery some-cert-file.pem [https_URL] # use client-side certificate
    curl --cacert ca-bundle.pem [https_URL] # use CA store to verify server-side certificates

    # specify a ip address for a domain
    curl --resolve [some_domain]:[some_port]:[some_address] [same_domain]

    curl --proxy [some_proxy] [URL]
    ```

8. wget

    * directly download a link
    * q: quite
    * O: output, `-` for stdout

    ```bash
    wget 127.0.0.1/file.txt
    wget -qO- 127.0.0.1
    ```

9. Actual Networking Traffic

    * troubleshoot

    ```bash
    tail -F /proc/net/dev
    iftop
    iptraf
    tcpdump # raw
    ```

## Free Cache

[How to Clear RAM Memory Cache, Buffer and Swap Space on Linux](https://www.tecmint.com/clear-ram-memory-cache-buffer-and-swap-space-on-linux/)

[How do you empty the buffers and cache on a Linux system?](https://unix.stackexchange.com/questions/87908/how-do-you-empty-the-buffers-and-cache-on-a-linux-system)

1. Use slabtop display kernel slab cache information:

    ```bash
    slabtop
    vmstat -m
    cat /proc/slabinfo
    ```

2. Drop buffer to free memory

    ```bash
    sync
    ```

3. Drop cache

    ```bash
    # as root usuer
    ## To free pagecache:
    echo 1 > /proc/sys/vm/drop_caches
    ## To free dentries and inodes
    echo 2 > /proc/sys/vm/drop_caches
    ## To free pagecache, dentries and inodes
    echo 3 > /proc/sys/vm/drop_caches

    # using sudo
    sudo sh -c 'echo 1 >/proc/sys/vm/drop_caches'
    sudo sh -c 'echo 2 >/proc/sys/vm/drop_caches'
    sudo sh -c 'echo 3 >/proc/sys/vm/drop_caches'
    ## or
    echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
    ```

## Environment and Global Variables

[Special Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html)

[Parameter and Variable Index](https://www.gnu.org/software/bash/manual/html_node/Variable-Index.html)

1. Get configs for systems

    ```bash
    printenv
    printenv | less
    set
    set | less
    getconf ARG_MAX

    set path = ($path ~/exe/bin)
    ```

2. Directly print current variables

    ```bash
    echo $? # return value of last command
    echo "program name is: $0"
    echo "the first command line parameter is: $1"
    echo "there are $# command line parameters"
    echo "$@" # an array of command line parameters
    echo "$*" # a list of command line parameters

    echo "$$" # current process ID, if in a shell then shell's, if in a script then the process that is running the script
    echo "$BASHPID" # process ID of the current instance of bash
    echo "$BASH_SUBSHELL" # "subshell level", it's a variable
    echo "$!" # the process ID of the most recently executed background pipeline

    echo "$OSTYPE"
    echo "$USER" # your login name
    echo "$HOME" # the path name of your home directory
    echo "$HOST" # the name of the computer you are using
    echo "$ARCH" # the architecture of the computers processor
    echo "$DISPLAY" # the name of the computer screen to display X windows
    echo "$PRINTER" # the default printer to send print jobs
    echo "PATH" # the directories the shell should search to find a command
    ```

## Scripting

1. Basic scripting

    ```bash
    echo "program name is: $0"
    echo "the first command line parameter is: $1"
    echo "there are $# command line parameters"

    expr 2 + 3
    echo $((2**3))
    b=`expr $a+1` # no extra spaces

    array=(1 2 3)
    echo ${a[*]}; echo ${a[0]}

    x=3
    echo $x
    unset x=3
    echo $x

    mydir=`pwd`; echo $mydir

    echo $1
    echo "$1" # In general, use double quotes in case the variable is not defined
    ```

2. Write script on the fly

    * capture all commands and save to a file
    * Ctrl+D (EOF) to end

    ```bash
    script
    ```

3. Expression and calculation

    * `expr` commands supports:
        * arithmetic operators: +,-,*,/,%
        * comparison operators: <, <=, ==, !=, >=, >
        * boolean/logical operators: &&, ||
        * parentheses: (, )
        * precedence is the same as in C, Java
    * `bc` is a precision calculating language
    * `awk` can also be used to evaluate expressions

    ```bash
    echo $((1+3))
    if [ `expr 1 < 2` ]; then echo "yeah"; fi
    echo "scale=6;(1/12)+(7/13)" | bc
    echo "(1/12)+(7/13)" | bc -l
    awk "BEGIN {print -3.14 - -1.4141 * 3}"
    ```

4. Test

    * since all variables in bash are strings, sometime you are actually comparing strings not numbers
        * do not use "<" and so on to compare numbers
    * `[[ ]]` and `[ ]` is aliases for test to compare strings and numerical values
        * `[` is the same as `test` and `]` is just a special parameter for it
        * `[[ ]]` is bash extension
    * [Is double square brackets [[ ]] preferable over single square brackets [ ] in Bash?](https://stackoverflow.com/questions/669452/is-double-square-brackets-preferable-over-single-square-brackets-in-ba)

    ```bash
    [[ string1 = string2 ]] # True if strings are identical, note only ONE equal sign
    [[ string1 == string2 ]] # Same as above
    [[ string1 != string2 ]] # True if strings are not identical
    [[ string ]] # Return 0 exit status (=true) if string is not null
    [[ -n string ]] # Return 0 exit status (=true) if string is not null
    [[ -z string ]] # Return 0 exit status (=true) if string is null

    [[ int1 –eq int2 ]] # Test identity
    [[ int1 –ne int2 ]] # Test inequality
    [[ int1 –lt int2 ]] # Less than
    [[ int1 –gt int2 ]] # Greater than
    [[ int1 –le int2 ]] # Less than or equal
    [[ int1 –ge int2 ]] # Greater than or equal

    test 1024 -eq 1024 # can use test directly

    if cond1 && cond2 || cond3
    if cond1 –a cond22 –o cond3
    if [ "$a" –lt 0 –o "$a" –gt 100 ]

    test -d file # if file is a directory
    test -f file # if file is not a directory
    test -s file # if the file has non zero length
    test -r file # if the file is readable
    test -w file # if the file is writable
    test -x file # if the file is executable
    test -o file # if the file is owned by the user
    test -e file # if the file exists
    test -z file # if the file has zero length
    ```

5. Flow controls

    * [Using case statements](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_03.html)

    ```bash
    if []; then
        echo "1"
    elif []; then
        echo "2"
    else
        echo "3"
    fi

    for i in 1 2 3 4
    do
        echo i
    done

    while test "$i" -gt 0
    do
        i=`expr $i - 1`
    done

    until test "$i" -lt 0
    do
        i=`expr $i - 1`
    done

    status="off"
    input="on"
    case $argument in
    "on") echo "on"
        status="on";;
    "off")
        status="off"
        echo 3
        ;;
    esac
    ```

6. Strip variables

    ```bash
    statement="I Love Bash!"
    echo "${statement#I love }" # strip from beginning
    echo "${statement%Bash\!}" # strip from ending
    echo "${statement%???}" # strip from ending

    mydir=`pwd`
    basename $mydir # only the last directory name
    dirname $mydir # no `basename`
    ```

7. Shift parameters

    ```bash
    echo "$2"
    shift
    echo "$1" # same thing

    # read command line arguments
    while [[ $# > 0 ]];do
        key="$1"
        case $key in
            -n|--name)
            NAME="${2}"
            shift # we read 2 args
            ;;
            -h|--help)
            HELP="1"
            ;;
            -f|--force)
            FORCE="1"
            ;;
            *)
            # unknown
            echo "Invalid arg detected, aborting..."
            exit -1
            ;;
        esac
        shift
    done
    ```

8. Exec

    * 2 main usages
    * redirect stdin and stdout
    * replace current process with new process
    * [Using exec](https://www.tldp.org/LDP/abs/html/x17974.html)
    * [I/O Redirection](https://www.tldp.org/LDP/abs/html/io-redirection.html)

    ```bash
    # stdin
    exec 6<&0          # Link file descriptor #6 with stdin. Saves stdin.
    exec < input-file  # stdin replaced by file "input-file"
    read var           # read first line in input-file to var
    exec 0<&6 6<&-     # restore stdin from file descriptor #6 and free #6
    exec <&6 6<&-      # restore stdin from file descriptor #6 and free #6

    # stdout
    exec 7>&1           # Link file descriptor #6 with stdout. Saves stdout.
    exec > output-file  # stdout replaced by file "output-file".
    echo "Editing file"
    exec 1>&7 7>&-      # Restore stdout and close file descriptor #7.

    # no extra process
    exec bash -l
    ps                  # new bash will have same process ID as current shell

    bash -l             # create a new bash shell
    ps                  # will have (at least) 2 shell processes

    # subshell problem (inaccessible variables within a subshell)
    num=0
    cat input | read num  # first line of input is a non-zero number
    echo $num             # num is still 0

    # exec for subshell problem
    num=0
    exec 3<> input        # set file descriptor #3 to input, create if not exist
    read num <&3
    echo $num             # num is the number in input file
    ```

9. eval

    * combine strings into a single command and execute
    * useful if args are only known at run-time

    ```bash
    help eval # read the usage help for your own shell
    eval echo -e $USER
    ```

## Schedule

1. Chronos

    ```bash
    crontab -e
    (crontab -l 2>/dev/null; echo "*/5 * * * * <some-job>") | crontab -
    ```

2. Chronons Job

   * Edit current crontab after `crontab -e`
   * [CronHowto - Community Help Wiki](https://help.ubuntu.com/community/CronHowto)
   * [Cron format](http://www.nncron.ru/help/EN/working/cron-format.htm)
     * "In extended mode, crontab notation may be abridged by omitting the rightmost asterisks."

    ```bash
    Minute Hour DayOfMonth MonthOfYear DayOfWeek Year Command

    * * * * * *          each minute
    59 23 */2 * *        each 2 day at 23:59
    @reboot              reboot

    0 0-11 * Mon-Fri *   each hour before 12 on weekdays
    ```

## Run in a Shell

1. A shell

    ```bash
    /bin/sh # Bourne Shell
    /bin/bash # bash
    /bin/csh # c shell
    /bin/tcsh # Turbo C Shell
    ksh # Korn shell
    ```

2. A script

    * generally speaking, the difference is if the script is run under current shell or not
    * read help for more
    * BTW the ".sh" at the end is not necessary

    ```bash
    ./script.sh
    # chmod u+x ./script.sh # give user permission to execute the file if you want to run the script as the line above

    # I did not test the following about the execute permission
    . script.sh # born shell?
    source script.sh # c shell?
    sh script.sh
    bash script.sh
    ```

## Build and Install

1. `make` ritual

    ```bash
    ./configure
    make && make check
    sudo make install

    # or
    ./configure && make -j2
    sudo make install

    ./configure --prefix=$HOME/abcdefg
    make
    make check
    make install
    ```

2. Libraries

    ```bash
    sudo ldconfig

    # as root
    echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
    ldconfig
    ```

3. Strip debug codes

    ```bash
    strip xxx
    ```

## Debugging

1. Debugging Shell Scripts

    ```bash
    set -o xtrace
    sh -x ./script.sh
    # write "#!/bin/sh -xv" at the beginning of the script
    ```

2. Memory leaks

    ```bash
    gdb
    jdb
    valgrind
    ```

3. Measure Time

    ```bash
    time [command]
    /usr/bin/time -v [command]
    ```

4. Debuggers

    ```bash
    gdb
    jdb
    ```

## Popular Paths

See [What is the exact difference between a 'terminal', a 'shell', a 'tty' and a 'console'?](https://unix.stackexchange.com/questions/4126/what-is-the-exact-difference-between-a-terminal-a-shell-a-tty-and-a-con) for difference among pts and tty and so on.

* /dev/pts
  * the shells, can be used to message that shell
* /dev/null
  * The magical trash bin, or black hole

## Uncanny Commands

1. Sleep

    * Sleep for \[number\] seconds

    ```bash
    sleep [number]
    ```

2. Output repeatedly until killed

    * May break the shell or ssh connection due to network lag (cannot kill)

    ```bash
    yes
    ```

3. Wait

    * wait for a job to complete

    ```bash
    sleep 8&
    # get pid of specific process
    wait `ps -C sleep -o pid=`
    wait `pidof sleep`
    ```

## Message

1. Turn on/off

    * It's just turning of/off the write permission of one's pts file

    ```bash
    mesg y
    mesg n
    ```

2. Send messages

    ```bash
    write [pts]
    wall # write all
    ```

## Hardware Information

1. Get/Set SATA/IDE device parameters

    ```bash
    hdparm
    ```

2. PCI devices

    * -v

    ```bash
    lspci
    ```

3. USB devices

    ```bash
    lsusb -v
    lsinput
    ```

4. Models loaded in the Linux Kernel

    ```bash
    lsmod
    ```

5. CPU

    * troubleshoot

    ```bash
    cat /proc/cpuinfo
    ```

6. Mem

    * troubleshoot

    ```bash
    free
    cat /proc/meminfo
    ```

7. HDD

    ```bash
    df -h
    sudo fdisk -l
    hdpam -i /dev/sda[ID]
    ```

## Disk and Filesystem

1. Mount filesystems

    ```bash
    mount
    ```

2. Unmount filesystems

    ```bash
    umount
    ```

3. Disk management

    ```bash
    fdisk
    ```

4. Remount root partition

    ```bash
    mount -o remount,rw /
    ```

## Run levels

1. runlevel
2. init

## Power

1. Shutdown and reboot

    * -h hold/poweroff the machine
    * -r Reboot
    * time can be
        * now
        * +10
        * 23:10

    ```bash
    shutdown [-h/-r] [time]
    shutdown -h
    shutdown -r

    poweroff # shutdown right now
    reboot # reboot right now
    ```

    * Fun fact: `-h` is to display help usually, but if you want help from `shutdown`, it's shutdown right now!

## Printers

[Command-Line Printing and Options](https://www.cups.org/doc/options.html#PRINTER)

```bash
lpr -P [printer] file1 file2 file3 ...
lpr -P [printer] < file1

lpq -P [printer]

lprm -P [printer] [Jobs-id\username]
```

## Gpg Signature

`gpg`

```bash
gpg --import [keyfile]
gpg2 --keyserver [URL_to_key_server] --search-keys [sender]

gpg --verify [sigfile] [file]

gpg --gen-key # generate new key
gpg --full-generate-key # generate new key pair ("full featured")
gpg --gen-revoke [KEYID] # generate revoke
gpg --send-keys [KEYID] # publish your keys to internet

gpg --fingerprint

gpg --list-keys
gpg --list-secret-keys --keyid-format LONG # list private keys

gpg --export
gpg --export -a "some user name" # -a for armored ascii
gpg --export -a "some user name" > public.key # -a for armored ascii
gpg --export-secret-key -a "some user Name" > private.key # export private key
gpg --import private-or-public.key # import key

gpg --delete-key "some user Name"
gpg --delete-secret-key "some user Name"

gpg -e -u "some user name, use this sender's key to encrypt" -r "other user name, use this receiver's public key to decypt" <some-file>
gpg -d <some-file.gpg> > <output-file-name>  # redirect to a file
gpg -o <output-file-name> -d <some-file.gpg> # -o must proceed -d
```

Use `gpg` with git

```bash
git config --global commit.gpgsign true     # turn on gpg sign
git config --global user.signingkey [KEYID] # assign gpg key

# windows gpg
git config --global gpg.program "/c/GnuPG/bin/gpg.exe"
git config --global gpg.program "C:\GnuPG\bin\gpg.exe"

git commit --amend --no-edit -n -S          # sign the last commit, maybe need to force push later
git rebase --exec 'git commit --amend --no-edit -n -S' -i [tag,hash] # another way to go?
```

Also config file available

```bash
~/.gnupg/gpg.conf
~/.gnupg/gpg-agent.conf
```

## Distribution Specific

### Debian

* Install build essentials

  ```bash
  sudo apt install build-essential
  sudo aptitude install build-essential
  ```

* upgrade

  * `upgrade` will potentially hold back versions and cause potential problems

  ```bash
  sudo apt-get dist-upgrade
  ```

* Reconfig timezone

  ```bash
  sudo dpkg-reconfigure tzdata
  ```

* List installed packages and search

  ```bash
  dpkg-query -l
  ```

* Add apt source

  ```bash
  sudo vim /etc/apt/sources.list.d/newlist.list
  ```

* [VirtualBox - Debian Wiki](https://wiki.debian.org/VirtualBox)

## Miscellaneous

* Trick to run redirect using sudo

  ```bash
  sudo sh -c 'echo xxx >/xxx/xxx'
  ```

* Convert all tab to spaces

  ```bash
  find . -name '*.java' ! -type d -exec bash -c 'expand -t 4 "$0" > /tmp/e && mv /tmp/e "$0"' {} \;
  ```

* Download all files from a website

  * [How to download all files (but not HTML) from a website using wget?](https://stackoverflow.com/questions/8755229/how-to-download-all-files-but-not-html-from-a-website-using-wget)

  ```bash
  wget -A pdf,jpg -m -p -E -k -K -np <some-url>
  wget --accept pdf,jpg --mirror --page-requisites --adjust-extension --convert-links --backup-converted --no-parent <some-url>
  ```

* Calculator

  ```bash
  echo "scale=6;(2/3)+(7/8)" | bc
  ```

* sass auto minify

  * [sass --watch with automatic minify?](https://stackoverflow.com/questions/8980398/sass-watch-with-automatic-minify)

  ```bash
  sass --watch a.scss:a.css --style compressed
  ```

* Sort based on line length

  * [Sort a text file by line length including spaces](https://stackoverflow.com/questions/5917576/sort-a-text-file-by-line-length-including-spaces)

  ```bash
  cat testfile | awk '{ print length, $0 }' | sort -n -s | cut -d" " -f2-
  cat testfile | awk '{ print length, $0 }' | sort -n | cut -d" " -f2-
  ```