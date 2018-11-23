# Unix and Linux Commands

*Last Update: 11/22/2018.*

## Prologue

As the most common operating systems in production environments, *nix systems are known for their command line interface (cli).

For people working with computers, even they are not professional DevOps, the familiarity with *nix cli still corresponds with their level of experiences in development.

It's not necessary to master *nix cli, but it's necessary to know it well to be a qualified and experienced developer.

The commands below are listed mostly for my personal reference. They are not ranked by any specific order or designed to be a tutorial for beginners.

(Instead of seeking for note-management apps in my phone each time, e.g. on a public computer, I can just easily type in this URL :D)

## Philosophies and Notes

* Everything is a file, including the shell, the devices, the directories.
* Shell is very very very serious with spaces. Pay extra heed when writing scripts.

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
    echo "write this line into file a.txt" > a.txt # a.txt will be cleared and only consist of this line
    echo "append this line into file a.txt" >> a.txt # the original content of a.txt would not be affected
    ./a.out < test_input # feed a small c program that reads input from STDIN with test_input
    ls -lha / | tail -n 10 # list all files in root directory and output only the last 10 lines
    ./a.out 2>> err_log 1> /dev/null # store the errors and discard the standard output
    ./a.out > afile 2>&1 # two streams go to the same destination (2 is tied with 1)
    > count.txt 2> log.txt wc < shakespeare.txt # order does not matter
    man cat | grep file # only output lines containing "file"

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

    ```bash
    du
    du -sh
    du -s *
    du -hs .[^.]*
    ```

4. Copy

    * -r dir
    * -v verbose
    * -p reserve time

    ```bash
    cp [source] [target]
    scp [source] [target] # secure copy, copy across ssh and so on
    ```

5. Move and rename

    * -v verbose
    * `mv` treats directories and files the same

    ```bash
    mv [source] [target]
    ```

6. Delete

    * -i interactive
    * -r dir
    * -f force
    * rm -rf ./* delete all files in current dir
    * su"do r"m -r"f /* Say goodbye to your system (Never run this!!!!!)

    ```bash
    rm
    ```

7. Quota

    ```bash
    quota -v
    ```

8. File system disk space usage

    ```bash
    df
    df .
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
    ln -s [source file] [link]
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
    # and print the pathes of those files
    find . -type f -print0 | xargs -0 grep "pattern"
    # only files, no pathes
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

    ```bash
    watch -n 1 command
    ```

## Filters and Text Manipulation

1. Search for specific pattern

    * -i ignore case
    * -n precede line numbers
    * -v lines with no specific patterns
    * [What is the difference between `grep`, `egrep`, and `fgrep`?](https://unix.stackexchange.com/questions/17949/what-is-the-difference-between-grep-egrep-and-fgrep)

    ```bash
    grep [file] [string]
    pdfgrep # grep in pdf files
    ```

2. sort

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
    wc -l
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

    ```bash
    cut
    cut -b [bytes] # select only specified bytes
    cut -c 1-2, 3, 6 # characters
    cut -d ' ' # use ' ' as delimiter
    ```

7. Paste

    * Merge lines of files
    * like reverse of `cut`

    ```bash
    paste
    paste -d ' ' file1 file2 file3 > output
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

    * Output is consist with:
        * uptime
        * Login users
        * load

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

8. Create user

    ```bash
    useradd
    adduser # a wrapper of useradd
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

2. SELinux (advanced way to manage permissions)

    * [details](https://people.redhat.com/rsawhill/selinux/)

    ```bash
    sestatus
    getenforce
    seinfo
    setenforce 0 # turn off SELinux totally, bad behavior
    semanage
    ```

3. Default permission when creating a new file

    * It's negated (reversed)

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

    * See IDs of processes
    * Read help of `ps` for details
    * -e all processes
    * -a all processes except session leader and processes not associated with a terminal
    * -x display session leader and processes not associated with a terminal (?)
        * e = a + x ?
    * -u userlist
    * -w wide, use twice for unlimited width

    ```bash
    ps
    ps axuf
    ps aux | grep -v grep | grep -i -e VSZ -e
    ps -e -o pid,vsz,comm= | sort -n -k 2
    ```

7. Monitor processes

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

    ```bash
    free
    free -h
    free -mt
    ```

12. Read syslog

    ```bash
    sudo tail -f /var/log/syslog
    ```

## Network

1. List listening ports

    ```bash
    sudo netstat -lnp
    ```

2. Investigate sockets

    ```bash
    sudo ss -lnp
    ```

3. List activating ports

    ```bash
    lsof
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

## Git

[Git Cheat Sheet](https://services.github.com/on-demand/downloads/github-git-cheat-sheet.pdf)

```bash
git help [command]

git config --global

git init
git clone url [dir]

git status

git add .
git commit -m ""
git commit --amend
git diff
git diff --staged
git reset [file]

git branch
git branch [new-branch-name]
git checkout [branch]
git checkout -b [new-branch-name]
git merge [branch]
git branch -d [branch-to-delete]

git remote add origin

git fetch [bookmark]
git merge [bookmark]/[branch]
git push [alias] [branch]
git pull # git fetch + git merge

git log
git log --follow [file]
git diff [branch_a]...[branch_b]
git show [commit]
git tag

git rm [file] # both delete from working directory and stage this deletion
git rm --cashed [file] # delete from version control
git mv [file-original] [file-new]

vim .gitignore # edit excluded files
git ls-files --other --ignored --exclude-standard # list excluded files

# temporarily store changes
git stash
git stash pop
git stash list
git stash drop

git reset [commit] # undo, locally
git reset --hard [commit] # discard all and jump back
```

Apply .gitignore 

* [Apply gitignore on an existing repository already tracking large number of files](https://stackoverflow.com/questions/19663093/apply-gitignore-on-an-existing-repository-already-tracking-large-number-of-files)

```bash
## commit *ALL* changes first
git rm -r --cached .
git add .
git commit -m ".gitignore is now working"
# git push origin
```

[Set CRLF of git to LF on Windows](https://stackoverflow.com/questions/2517190/how-do-i-force-git-to-use-lf-instead-of-crlf-under-windows)

Other git commands

```bash
git config --global user.name "na"
git config --global user.email "a@b.co"

# line ending preference
git config --global core.autocrlf input
git config --global core.safecrlf true

# log
git log --pretty=oneline
git log --pretty=oneline --all
git log --pretty=oneline --max-count=2 --since='1024 minutes ago' --until='256 minutes ago' --author=<Mike>
git log --all --pretty=format:'%h %cd %s (%an)' --since='1 days ago'
git log --pretty=format:'%h %ad - %s%d [%an]' --graph --date=short
# in .gitconfig, under [alias], add "history = log --pretty=format:'%h %ad - %s%d [%an]' --graph --date=short"
git log --graph --date=short master --all

# look at an old state without affecting current working directory
git checkout [hash-of-previous-commits]
git checkout master # go back to master

# tag
git tag # list tags
git tag v0 # tag current version as v0
# checkout to the first ancestor of a tag
git checkout v0^
git checkout v0~1

# discard unstaged changes
## make changes to a.b
## start to undo
git checkout a.b

# undo uncommitted changes
## make changes to a.b
git add a.b
## start to undo
git reset HEAD a.b # reset the staging area to be the version in HEAD
# reset does not change working directory
git checkout a.b # checkout the file

# undo committed changes with writing to history
## make changes to a.b
git add a.b
git commit -m "Bad Commit!"
## start to undo
git revert HEAD # or the hash of other previous commits
## git revert HEAD --no-edit

# undo committed changes without writing to history
## git reset [reference-of-commit] # Rewrite the current branch to point to that commit
# ... (making mistakes and committing mistakes)
git tag to-remove
git reset --hard to-remove^ # can use other reference
## -hard: working directory should be updated to be consistent with the new branch head
## the bad commits are still in history
## https://stackoverflow.com/questions/9529078/how-do-i-use-git-reset-hard-head-to-revert-to-a-previous-commit
git tag -d to-remove # delete the tag

# ...
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

    ```bash
    cat /proc/cpuinfo
    ```

6. Mem

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

## Distrubution Specific

### Debian

* Install build essentials

  ```bash
  sudo apt install build-essential
  sudo aptitude install build-essential
  ```

* Reconfig timezone

  ```bash
  sudo dpkg-reconfigure tzdata
  ```

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
  wget -A pdf,jpg -m -p -E -k -K -np http://site/path/
  wget --accept pdf,jpg --mirror --page-requisites --adjust-extension --convert-links --backup-converted --no-parent http://site/path/
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