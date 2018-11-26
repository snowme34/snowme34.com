# bash 指令

## 前言

UNIX 系统作为生产环境中最常见的系统，其命令行命令的熟练度自然成为衡量一个相关从业人员对相关技术的
熟练度的重要标准。即使不是专业运营人员，不是专业服务器管理员，如果仅仅只会用命令行 compile 甚至不
会使用（强烈依赖于IDE），其开发经历的局限性可想而知。

以下常见命令收录表并非按照使用频率排序，也并不是作为入门教程而创作，仅为查找对应收录使用。

## 基本指令

1. 终止 (SIGINT)

    ``` bash
    ^c
    ```

2. 暂停 (signal 17, SIGTSTP)

    ``` bash
    ^z
    ```

3. 至行首

    ``` bash
    ^a
    ```

4. 至行尾

    ``` bash
    ^e
    ```

5. 删除光标之后所有

    ``` bash
    ^k
    ```

6. 清屏

    ``` bash
    ^l
    ```

7. 登出当前会话

    ``` bash
    ^d
    ```

8. 搜索历史记录

    ``` bash
    ^r
    ```

9. 命令补全 Tab (两下查看所有可能的对象)

    ``` bash
    [Tab]
    ```

10. 上一条命令

    ``` bash
    [Up Arrow]
    ```

11. 上一个命令的参数

    ``` bash
    [Esc]+.
    ```

### 重复执行 (多用于脚本)


1. 重复前一命令

    ``` bash
    !!
    ```

2. 重复前一个以特定字符开头的命令

    ``` bash
    !+[specific letter]
    ```

3. 数字：序号

    ``` bash
    !+[number]
    ```

4. ？字符串：包含指定字符串的命令

    ``` bash
    !+[specific string]
    ```

5. 执行n前的命令 

    ``` bash
    ! -n
    ```

## 命令

1. 后台运行

    ``` bash
    [example-command]&
    ```

2. 查看后台进程(查看序号)

    ``` bash
    jobs
    ```

3. 恢复后台暂停（SIGTSTP）的进程 (?)

    ``` bash
    bg [ID]
    ```

4. 拉回前台

    ``` bash
    fg [ID]
    ```

5. 查看历史

    ``` bash
    history
    ```

6. 休眠[number]秒

    ``` bash
    sleep [number]
    ```

7. 用图形界面打开指定目录(可能会根据系统的文件管理器而改变)

    ``` bash
    nautilus
    nautilus .
    ```

### 帮助

1. help

    * 几乎所有命令都有 help 选项
    * 为此命令简要使用说明或者帮助文档
    * 无论任何问题，疑惑，此为首选项

    ``` bash
    [some command] -h
    [some command] --help
    ```

2. man：手册(manual)

    * 解释每个命令
    * 如果存在，比 help 详尽
    * 如同详细说明书
    * C 语言的文档甚至也能查询
    * 类型
      1. 用户命令
      2. 内核系统调用
      3. 库函数
      4. 特殊文件和设备
      5. 文件格式和规范
      6. 游戏
      7. 规范，标准，其他
      8. 系统管理命令
      9. Linux 内核 API
    * -k [key word]
      * search for all documentation with key work

    ``` bash
    man ascii
    man -s3 malloc
    man echo
    ```

3. info

    * 比 man 更详细

4. doc

    * txt, html, pdf 等保存在 /usr/share/doc 的文件

### 名称/Namers

1. 系统/System

    ``` bash
    uname
    ```

2. 主机/Host

    ``` bash
    hostname
    ```

3. 

### 关于用户/Users

1. 切换用户(留空则root)/Switch user (no user->root)

    ``` bash
    su - [user]
    ```

2. 切换用户并保留当前路径和终端(留空则root)/Switch user and keep current path and terminal (no user->root)

    ``` bash
    su [user]
    ```

3. 以root权限运行/Run as root

    ``` bash
    sudo
    ```

4. 注销/Log out

    ``` bash
    exit
    ```

5. 更改密码/Change password

    ``` bash
    passwd
    ```

6. 用户信息/ID

    ``` bash
    id
    ```

### 导航/Navigation

1. 查看目录/See current directory

   * -a 显示所有文件/show all files (hidden files)
   * -l 列表显示详情/show in detail
   * -R 递归显示子目录/show subdirectory recursively
   * -ld 显示目录信息或link信息/show dir info and link info

    ``` bash
    ls
    ls -a -l -R -D -C -h -F --color=auto
    ls -CF
    ls -lhAf
    ls -lhaF
    ls -l
    ls --color=auto
    ```

2. 显示当前目录路径/Print current path

    ``` bash
    pwd
    ```

3. 切换目录/Change path

   * .. 上一级目录/up to
   * . 当前目录/current path
   * ~ 家/home
   * \- 返回之前目录/back to last dir

    ``` bash
    cd
    ```

### 文件/Files

1. 创造空文件或者更新时间/Create blank file or chage last-change time

    ``` bash
    touch
    ```

2. 查看文件类型/See file type

    ``` bash
    file
    ```

3. 查看文件大小/See file disk usage

   * -h 改善可读性/human-reading friendly
   * -s 输出总大小/sum

    ``` bash
    du
    du -sh
    ```

4. 复制/Copy

   * -r 文件夹/dir
   * -v 详细信息/verbose

    ``` bash
    cp [source] [target]/[target path]
    ```

5. 移动及重命名/Move and remane

   * -r
   * -v

    ``` bash
    mv [source] [target]/[target path]
    ```

6. 删除/delete

   * -i 交互式/interactive
   * -r 文件夹/dir
   * -f 强制/force
   * sudo rm -rf ./* 删除当前目录下所有文件/delete all files in current dir
   * su"do r"m -r"f /* 和你的系统说再见(千万不要执行)/Say goodbye to your system (Never run this)

    ``` bash
    rm
    ```

### 目录/Dir

1. 创建新目录/Create new dir

   * -p 创建所需的父目录/Create paretn dir
   * -v verbose

    ``` bash
    mkdir
    ```

2. 移除空目录/Remove empty dir

   * Note: use "rm -r" to remove non-empty dir

    ``` bash
    rmdir
    ```

### 权限

### 日期时间/Date and Time

1. 查看or设置当前日期时间/Show or set current date and time

   * +%Y--%m--%d (e.g.)
      * 指定输出时间格式(-是自定义的，%是标识符)
      * Print time in specific format
   * -u 格林尼治时间/Greenwich time
   * -s 设置/setting

    ``` bash
    date
    ```

2. 显示硬件时钟时间(主板上保存的时间)/Show hardware time

    ``` bash
    hwclock
    clock
    ```

3. 日历/Calendar

    ``` bash
    cal
    ```

4. 系统运行时间/Up time

   * 运行时间/uptime
   * 登陆用户/Login users
   * 负载/load

    ``` bash
    uptime
    ```

### 输入输出/Output and Input

1. 显示输入内容/Display a line of text

    ``` bash
    echo
    echo "xxx" >> [file]
    echo "xxx" > [file]
    ```

2. 查看文件所有内容/Display all the content of one file

    ``` bash
    cat
    ```

3. 显示文件前几行/Display the first part of one file

   * -n 指定前几行/Display the first specific lines

    ``` bash
    head
    head -n 10
    ```

4. 显示末几行/Display the last part of one file

   * -n
   * -f 追踪显示文件更新（一般看日志,不停输出更新的部分）/Follow the latest updates of one file (usually used to follow the log files)

    ``` bash
    tail
    ```

5. 翻页形式显示（只能向下）/Paging through text (downward only)

   * q to quit 退出

    ``` bash
    more
    ```

6. 翻页形式显示/Paging through text

   * q to quit 退出

    ``` bash
    less
    ```

### 硬件信息/Hardware Information

1. 获取磁盘信息/Get/Set SATA/IDE device parameters

    ``` bash
    hdparm
    ```

2. PCI设备/For PCI

   * -v

    ``` bash
    lspci
    ```

3. USB设备/For USB

   * -v

    ``` bash
    lsusb
    ```

4. 加载的模块/驱动/For models in the Linux Kernel

    ``` bash
    lsmod
    ```

5. CPU

    ``` bash
    cat /proc/cpuinfo
    ```

6. Mem

    ``` bash
    free
    cat /proc/meminfo
    ```

7. HDD

    ``` bash
    df -h
    sudo fdisk -l
    hdpam -i /dev/sda[ID]
    ```

### 挂载

### 监视/Monitor

1. 

    ``` bash
    top
    htop
    slabtop
    ```

### 运行级别

1. runlevel
2. init

### 关机重启/Shutdown etc.

1. 关机重启/shutdown and reboot

   * -h 关机hold/Poweroff the machine
   * -r 重启/Reboot
   * 

    ``` bash
    shutdown [-h/-r] [time]
    shutdown -h
    shutdown -r
    ```

      * ========================================
      * 关机重启
      * 
        * shutdown：关机重启
        * 
          * -h 关机hold
          * -r 重启reboot
          * shutdown [-h/-r] [time]
          * 
            * 定时
            * time：
            * 
              * now
              * +10
              * 23：30
        * poweroff：立即关机
        * reboot：立即重启
      * ==========================================
      * 归档压缩
      * 
        * zip
        * 
          * 压缩
          * zip + [压缩后得到的文件名] + 要压缩的文件
          * e.g.zip xxx.zip xxx
        * unzip
        * 
          * 解压缩
        * gzip
        * 
          * 压缩
        * tar
        * 
          * 归档（不是压缩）
          * tar -cvf  [归档后的名称] [要被归档的文件]
          * 
            * create a file
            * e.g. tar -cvf xxx.tar xxx.yyy

          * tar -xvf [要释放的tar文件]
          * 
            * e.g.tar -xvf xxx.tar

          * tar -cvzf xxx.tar.gz xxx.yyy
          * 
            * -z 归档后用gzip压缩
            * 最常用
      * =========================================
      * 查找
      * 
        * locate
        * 
          * 快速查找文件，文件夹
          * locate 关键字
          * 预先建立数据库，默认每天更新一次
          * 
            * updatedb（单独命令）命令手工建立、更新数据库（慢）
            * 没更新的话查不到
        * find
        * 
          * 高级查找
          * 制定位置
          * 高级选项
          * 实时扫描
          * find 查找位置 查找参数
          * 
            * 位置
            * 
              * . 当前
              * / 所有
            * 参数
            * 
              * -name+xxx
              * -perm (权限) 
              * 
                * 仅限数字表示权限
                * 如777
              * -type
              * 
                * d 目录
                * l 链接
              * -user 
              * -group
              * -ctime 修改时间
              * -size
              * ...
          * 使用结果执行命令
          * 
            * -exec
            * e.g.
            * 
              * find . -name "a*" -exec ls -l {} \;
              * 以上制定命令是 ls -l
              * 把找到的文件传递给制定文件
              * 余下都是固定格式
        * which
        * 
          * 定位命令的路径
        * find . -type f -print0 | xargs -0 grep "some string"
        * 
          * 搜索当前目录内所有文件是否包含关键字并输出路径
          * find . -type f -print0 | xargs -0 grep -l "some string"
          * 
            * 只输出符合文件，无路径
          * LIFE SAVER！！！！！！！！
      * ====================================================
      * free cache
      * http://www.tecmint.com/clear-ram-memory-cache-buffer-and-swap-space-on-linux/
      * http://unix.stackexchange.com/questions/87908/how-do-you-empty-the-buffers-and-cache-on-a-linux-system
      * 
        * Use slabtop display kernel slab cache information:
        * 
          * slabtop
        * see "vmstat -m":
        * 
          * vmstat  -m
        * look /proc/slabinfo:
        * 
          * cat /proc/slabinfo
        * Drop buffer to free memory
        * 
          * sync
        * drop cache
        * 
          * To free pagecache:
          * # echo 1 > /proc/sys/vm/drop_caches
          * To free dentries and inodes:
          * # echo 2 > /proc/sys/vm/drop_caches
          * To free pagecache, dentries and inodes:
          * # echo 3 > /proc/sys/vm/drop_caches
          * The above are meant to be run as root. If you're trying to do them using sudo then you'll need to change the syntax slightly to something like these:
          * $ sudo sh -c 'echo 1 >/proc/sys/vm/drop_caches'
          * $ sudo sh -c 'echo 2 >/proc/sys/vm/drop_caches'
          * $ sudo sh -c 'echo 3 >/proc/sys/vm/drop_caches'
          * NOTE: There's a more esoteric version of the above command if you're into that:
          * $ echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
          * Why the change in syntax? The /bin/echo program is running as root, because of sudo, but the shell that's redirecting echo's output to the root-only file is still running as you. Your current shell does the redirection before sudo starts.
      * ====================================================
      * other useful
      * 
        * ps -e -o pid,vsz,comm= | sort -n -k 2
        * sudo tail -f /var/log/syslog
        * top

以下只说明各指令的基本用法, 若需详细说明, 请用 man 去读详细的 manual.
1. ls
这是最基本的档案指令。 ls 的意义为 "list"，也就是将某一个目录或是某一个档案的内容显示出来。如果你在下 ls 指令後头没有跟著任何的档名，它将会显示出目前目录中所有档案。也可以在 ls 後面加上所要察看的目录名称或档案的名称，如
% ls /etc
ls 有一些特别的参数，可以给予使用者更多有关的资讯，如下:
-a : 在 UNIX 中若一个目录或档案名字的第一个字元为 "." , 则使用 ls
将不会显示出这个档案的名字，我们称此类档案为隐藏档。如 tcsh的初设档 .tcshrc；如果我们要察看这类档案，则必须加上参数 -a 。
-l : 这个参数代表使用 ls 的长( long )格式，可以显示更多的资讯，如档案存取权，档案拥有者( owner )，档案大小，档案最後更新日期，甚而 symbolic link 的档案是 link 那一个档等等。如下
% ls -l 
2. cp
cp 这个指令的意义是复制("COPY") , 也就是将一个或多个档案复制成另一个档案或者是将其复制到另一个目录去。
-i : 此参数是当已有档名为 f2 的档案时，若迳自使用 cp 将会将原来 f2
的内容掩盖过去，因此在要盖过之前必须先询问使用者一下。如使用者
的回答是y(yes)才执行复制的动作。
-r : 此参数是用来做递回复制用，可将一整颗子树都复制到另一个
目录中。 
3. mv
mv 的意义为 move , 主要是将一档案改名或换至另一个目录。如同 cp ，它也有三种格式:
mv 的参数有两个，-f 和 -i , 其中 -i 的意义与 cp 中的相同，均是 interactive
询问之意。而 -f 为强迫( force ) , 就是不管有没有同名的档案，反正我就是要
搬过去，所有其他的参数遇到 -f 均会失效
4. rm
rm 的意义是 remove ，也就是用来杀掉一个档案的指令。在 UNIX 中一
个被杀掉的档案除非是系统恰好有做备份，否则是无法像 DOS 里面一样还能够救回
来的。所以在做 rm 动作的时候使用者应该要特别小心。
-f : 将会使得系统在删除时，不提出任何警告讯息。
-i : 在除去档案之前均会询问是否真要除去。
-r : 递回式的删除。
5. mkdir
mkdir 是一个让使用者建立一个目录的指令。你可以在一个目录底下使用 
midir 建立一个子目录，使用的方法就不用多说了吧！
6. chdir ( cd )
这是让使用者用来转移工作目录用的。
chdir dirname 
如此你就可以将目前的目录转移到 dirname 这一个目录去。或使用 "chdir .." 来转移到上一层目录。
7. rmdir
相对於 mkdir ，rmdir 是用来将一个"空的"目录杀掉的。如果一个目录下面没有任何档案，你就可以用 rmdir 指令将其除去。rmdir 的使用法如下: 
rmdir dirname1 [ dirname2 .... ] 
如果一个目录底下有其他的档案， rmdir 将无法将这个目录杀掉，除非使用 rm 指令的 -r 选项。
8. pwd
pwd 会将目前目录的路径( path )显示出来，例如:
9. cat/more/less
以上三个指令均为察看档案内容的指令。cat 的意义是猫....不不不，是 concatenate ，在字典上的意思是"连结,将…串成锁状"( 语出资工电子词典 cdict )，其实就是把档案的内容显示出来的意思。 cat 有许多奇怪的参数，较常为人所使用的是 -n 参数，也就是把显示出来的内容加上行号。 cat 的用法如下:
cat [-n] :自标准输入读进内容，你可以用 pipe 将别的程式的输出转向
给 cat .
cat [-n] filename : 将 filename 的内容读进来，显示在标准输出上。问题在於 cat 它是不会停下来的，因此并不好用( 试想如果一个萤幕二十四行，而一个档案四百行，cat 一出来将会劈哩啪啦不断的卷上去，使用者很难据此得到他们所需的资讯。) 所以才有人又写了 more 出来。
more ,可以将所观察的档案跟据终端机的形态一页页的显示出来，再根据使用者的要求换页或卷行。如果使用者要在某一个档案中搜寻一个特定的字串，则按 / 然後跟著打所要搜寻的单字即可进行搜寻。more 也可以找得到。more 的使用法如下:
more filename
如果你在使用中觉得已经看到了所要看的部份，可以按'q'离开 more 的使用。在使用中按'v' 亦可以使用编辑器来编辑所观看的档案。less 的用法与 more 极类似，原先它就是为了弥补 more 只能往前方卷页的缺点而设计。 less 的用法如下:
less filename 
其与 more 不同的是它可以按 y 来往上卷一行，并且可以用"?"来往回搜寻你所要找的单字。
10. chmod
chmod 为变更档案模式用( change mode ) . 这个指令是用来更改档案的存取模式( access mode )。在 UNIX 一个档案上有可读(r)可写(w)可执行(x)三种模式,分别针对该档案的拥有者( onwer )、同群者( group member )( 你可以 ls -lg来观看某一档案的所属的 group )，以及其他人( other )。一个档案如果改成可执行模式则系统就将其视为一个可执行档，而一个目录的可执行模式代表使用者有进入该目录之权利。chmod 就是用来变更一些档案的模式，其使用方式如下:
chmod [ -fR ] mode filename ...
其参数的意义如下:
-f Force. chmod 不会理会失败的动作。 
-R Recurive. 会将所有子树下的所有子目录及档案改为你所要改成的模式。
mode 可以为一个三位或四位的八进位数字，来表示对某些对象的存取权。详情可参阅 chmod(1) 的 manual page 中有关 Absolute Modes 的说明。或是用一个字串来表示，请参考 chmod(1) 的说明。

二. 关於 Process 处理的指令:
1. ps
ps 是用来显示目前你的 process 或系统 processes 的状况。
以下列出比较常用的参数:
其选项说明如下:
-a 列出包括其他 users 的 process 状况。
-u 显示 user - oriented 的 process 状况 。
-x 显示包括没有 terminal 控制的 process 状况 。
-w 使用较宽的显示模式来显示 process 状况 。
我们可以经由 ps 取得目前 processes 的状况，如 pid , running state 等。
2. kill
kill 指令的用途是送一个 signal 给某一个 process 。因为大部份送的都是
用来杀掉 process 的 SIGKILL 或 SIGHUP ，因此称为 kill 。kill 的用法
为:
kill [ -SIGNAL ] pid ...
kill -l
SIGNAL 为一个 singal 的数字，从 0 到 31 ，其中 9 是 SIGKILL ，也就是一
般用来杀掉一些无法正常 terminate 的讯号。其馀讯号的用途可参考 sigvec(2)
中对 signal 的说明。
你也可以用 kill -l 来察看可代替 signal 号码的数目字。kill 的详细情形
请参阅 man kill。
三. 关於字串处理的指令:
1. echo
echo 是用来显示一字串在终端机上。□ echo -n 则是当显示完之後不会有跳行的动作。
2. grep/fgrep
grep 为一过滤器，它可自一个或多个档案中过滤出具有某个字串的行，或是
自标准输入过滤出具有某个字串的行。
fgrep 可将欲过滤的一群字串放在某一个档案中，然後使用 fgrep 将包含有
属於这一群字串的行过滤出来。
grep 与 fgrep 的用法如下:
grep [-nv] match_pattern file1 file2 ....
fgrep [-nv] -f pattern_file file1 file2 ....
-n 把所找到的行在行前加上行号列出
-v 把不包含 match_pattern 的行列出
match_pattern 所要搜寻的字串
-f 以 pattern_file 存放所要搜寻的字串
四. 网路上查询状况的指令:
1. man
man 是手册 ( manual ) 的意思。 UNIX 提供线上辅助( on-line help )的功能， 
man 就是用来让使用者在使用时查询指令、系统呼叫、标准程式库函式、各种表
格等的使用所用的。man 的用法如下:
man [-M path] [[section] title ] .....
man [-M path] -k keyword ...
-M path man 所需要的 manual database 的路径。
我们也可以用设定环境变数 MANPATH 的方式来取代 -M 选项。
title 这是所要查询的目的物。 
section 为一个数字表示 manual 的分类，通常 1 代表可执行指令，
2 代表系统呼叫( system call ) ，3 代表标准函数，等等。
我们如要参考 eqnchar(7) 的资料，则我们就输入 man 7 eqnchar ，
便能取得我们所要的辅助讯息。
-k keyword 
用来将含有这项 keyword 的 title 列出来。
man 在 UNIX 上是一项非常重要的指令，我们在本讲义中所述之用法均仅只是一个大家比较常用的用法以及简单的说明，真正详细的用法与说明还是要请你使用 man 来得到。
2. who
who 指令是用来查询目前有那些人在线上。
3. w
w 指令是用来查询目前有那些人在线上，同时显示出那些人目前的工作。
4. ku
ku 可以用来搜寻整个网路上的 user ，不像 w 跟 who 只是针对 local host 的查询. 而且 ku 提供让使用者建立搜寻特定使用者名单的功能。你可以建立一个档案 information-file 以条列的方式存放你的朋友的资料，再建立一个档案 hosts-file 来指定搜寻的机器名称。 ku 的指令格式可由 ku -h 得到。

五. 网路指令:
UNIX 提供网路的连接，使得你可以在各个不同的机器上做一些特殊的事情，如你可以在系上的 iris 图形工作站上做图形的处理，在系上的 Sun 上读 News ，甚至到学校的计中去找别系的同学 talk 。这些工作可以利用 UNIX 的网路指令，在你的位子上连到各个不同的机器上工作。如此一来，即使你在寝室，也能轻易的连至系上或计中来工作，不用像以前的人必须泡在冷冰冰的机房面。 
这些网路的指令如下所述:
1. rlogin 与 rsh 
rlogin 的意义是 remote login , 也就是经由网路到另外一部机器 login 。 
rlogin 的格式是:
rlogin host [ -l username ]
选项 -l username 是当你在远方的机器上的 username 和 local host 不同的时後，必须输入的选项，否则 rlogin 将会假设你在那边的 username 与 localhost 相同，然後在第一次 login 时必然会发生错误。
rsh 是在远方的机器上执行某些指令，而把结果传回 local host 。rsh 的格式
如下:
rsh host [ -l username ] [ command ]
如同 rlogin 的参数 -l username , rsh 的 -l username 也是指定 remote host的 username 。而 command 则是要在 remote host 上执行的指令。如果没有 指定 command ，则 rsh 会去执行 rlogin ，如同直接执行 rlogin 。
不过 rsh 在执行的时候并不会像一般的 login 程序一样还会问你 password , 而是如果你没有设定 trust table , 则 remote host 将不会接受你的 request 。
rsh 须要在每个可能会做为 remote host 的机器上设定一个档案，称为 .rhosts。这个档案每一行分为两个部份，第一个是允许 login 的 hostname , 第二个部份则是允许 login 的username 。例如，在 ccsun7.csie.nctu.edu.tw 上头你的 username 为 QiangGe , 而你的 home 下面的 .rhost 有以下的一行:
ccsun6.cc.nctu.edu.tw u8217529
则在 ccsun6.cc.nctu.edu.tw 机器上的 user u8217529 就可以用以下的方法来执行 rsh 程式:
% rsh ccsun7.csie.nctu.edu.tw -l ysjuang cat mbox 
将 ysjuang 在 ccsun7.csie.nctu.edu.tw 上的 mbox 档案内容显示在 local host ccsun6.cc.nctu.edu.tw 上。
而如果 .rhost 有这样的一行，则 ccsun6.cc.nctu.edu.tw 上的 user u8217529
将可以不用输入 password 而直接经由 rsh 或 rlogin login 到 
ccsun7.csie.nctu.edu.tw 来。
注意:
.rhost 是一个设定可以信任的人 login 的表格，因此如果设定不当将会让不法之徒有可以乘机侵入系统的机会。 如果你阅读 man 5 rhosts ，将会发现你可以在第一栏用 + 来取代任何 hostname ，第二栏用 + 来取代任何username 。
如一般 user 喜欢偷懒利用 " + username " 来代替列一长串 hostname ，但是这样将会使得即使有一台 PC 上跑 UNIX 的 user 有与你相同的 username , 也可以得到你的 trust 而侵入你的系统。这样容易造成系统安全上的危险。因此本系禁止使用这样子的方式写你的 .rhost 档，如果
发现将予以停机直到你找中心的工作人员将其改正为止。 同理，如果你的第二个栏位为 + ，如" hostname + " ,则你是允许在某一部机器上的"所有"user 可以不用经由输入 password 来进入你的帐号，是壹种更危险的行为。所以请自行小心。
2. telnet
telnet 是一个提供 user 经由网路连到 remote host。
telnet 的 格式如下:
telnet [ hostname | ip-address ] [ port ]
hostname 为一个像 ccsun1 或是 ccsun1.cc.nctu.edu.tw 的 name address，ip-address 则为一个由四个小於 255 的数字组成的 ip address ，如 ccsun1的 ip-address 为140.113.17.173 ，ccsun1.cc.nctu.edu.tw 的 ip-address为 140.113.4.11 。你可以利用 telnet ccsun1 或telnet 140.113.17.173 来连到 ccsun1。
port 为一些特殊的程式所提供给外界的沟通点，如资工系的 MUD 其 server 便提供一些 port 让 user 由这些 port 进入 MUD 程式。详情请参阅 telnet(1)的说明。
3. ftp
ftp 的意义是 File Transfer Program ，是一个很常应用在网路档案传输的
程式。ftp 的格式如下:
ftp [ hostname | ip-address ]
其中 hostname | ip-address 的意义跟 telnet 中的相同。
在进入 ftp 之後，如果与 remote host 连接上了，它将会询问你 username 与密码，如果输入对了就可以开始进行档案传输。
在 ftp 中有许多的命令，详细的使用方式请参考 ftp(1) ，这里仅列出较常用的 cd , lcd , mkdir , put , mput , get , mget , binary , ascii , prompt , help 与 quit 的使用方式。
ascii 将传输模式设为 ascii 模式。通常用於传送文字档。
binary 将传输模式设为 binary 模式，通常用於传送执行档，压缩档与影像档等。
cd remote-directory 将 remote host 上的工作目录改变。
lcd [ directory ] 更改 local host 的工作目录。
ls [ remote-directory ] [ local-file ] 列出 remote host 上的档案。
get remote-file [ local-file ] 取得远方的档案。
mget remote-files 可使用通用字元一次取得多个档案。
put local-file [ remote-file] 将 local host 的档案送到 remote host。
mput local-files 可使用通用字元一次将多个档案放到 remote host 上。
help [ command ] 线上辅助指令。
mkdir directory-name 在 remote host 造一个目录。
prompt 更改交谈模式，若为 on 则在 mput 与 mget 时每作一个档案之传输时均会询问。
quit/bye 离开ftp .
利用 ftp ，我们便可以在不同的机器上将所需要的资料做转移，某些特别的机器更存放大量的资料以供各地的使用者抓取，本校较著名的 ftp server 有 NCTUCCCA 与系上的ftp.csie.nctu.edu.tw 。这些 ftp server 均有提供一个 user 称为 anonymous ，一般的"外来客"可以利用这个 username 取得该 server 的公共资料。不过 anonymous 在询问 password 时是要求使用anonymous 的使用者输入其 email address，以往有许多台湾的使用者在使用国外的 ftp server 时并没有按照人家的要求输入其 email address，而仅是随便打一些字串，引起许多 internet user 和管理者的不满，对台湾的使用者的风评变得很差，因此遵循各 ftp server 的使用规则也是一件相当重要的事。
六. 关於通讯用的指令:
1. write
这个指令是提供使用者传送讯息给另一个使用者，使用方式:
write username [tty]
2. talk/ytalk/cytalk/ctalk
UNIX 专用的交谈程式。会将萤幕分隔开为你的区域和交谈对象的区域，同时也可和不同机器的使用者交谈。使用方式:
talk username[@host] [tty]
3. mesg
选择是否接受他人的 messege , 若为 messege no 则他人的 messege 将无法传送给你，同时他也无法干扰你的工作。使用方法:
mesg [-n|-y]
4. mail/elm
在网路上的 email 程式，可经由此程式将信件 mail 给他人。 使用方式:
mail [username]
mail -f mailboxfile
如有信件，则直接键入 mail 可以读取你的 mail .
elm 提供较 mail 更为方便的介面，而且可做线上的 alias . 你可以进入 elm
使用上下左右键来选读取的信件，并可按 h 取得线上的 help 文件。
使用方式:
elm [usernmae]
elm -f mailboxfile
七. 编译器( Compiler ):
Compiler 的用处在於将你所撰写的程式翻译成一个可执行档案。在资工系常用的程式语言是 C , pascal , FORTRAN 等。你可以先写好一个 C 或 Pascal 或 FORTRAN 的原始程式档，再用这些 compiler 将其翻成可执行档。你可以用这个方法来制造你自己的特殊指令。
1. cc/gcc (C Compiler)
/usr/bin/cc
/usr/local/bin/gcc
语法: cc [ -o execfile ] source 
gcc [ -o execfile ] source 
execfile 是你所希望的执行档的名称，如果没有加上 -o 选项编译出来的可执行档会以 a.out 做为档名。 source 为一个以 .c 做为结尾的 C 程式档。请参阅 cc(1) 的说明。
2. pc (Pascal Compiler)
/usr/local/bin/pc
语法: pc [ -o execfile ] source 
execfile 是你所希望的执行档的名称，如果没有加上 -o 选项编译出来的可执行档会以 a.out 做为档名。 source 为一个以 .p 做为结尾的 Pascal 程式档。 请参阅 /net/home5/lang/man 中 pc(1) 的说明。
3. f77 (Fortran Compiler)
/net/home5/lang/f77
语法: f77 [ -o execfile ] source 
execfile 是你所希望的执行档的名称，如果没有加上 -o 选项编译出来的可执行档会以 a.out 做为档名。 source 为一个以 .p 做为结尾的 FORTRAN 程式档。

八. 有关列印的指令:
以下为印表所会用到的指令，在本系的印表机有 lp1 , lp2 ( 点矩阵印表机 )，
lw , sp , ps , compaq ( 雷射印表机 )，供使用者使用。 
1. lpr 
lpr 为用来将一个档案印至列表机的指令。
用法:
lpr -P[ printer ] file1 file2 file3 ....
或
lpr -P[ printer ] < file1
例子:
lpr -Plp1 hello.c hello.lst hello.map 
lpr -Plp1 < hello.c
前者以参数输入所要印出的档案内容，後者列印标准输入档案(standard input)的内容，因已将 hello.c 转向到标准输入，故会印出 hello.c 的档案内容。
2. lpq
lpq 是用来观察 printer queue 上的 Jobs 。
用法:
lpq -P[ printer ] 
3. lprm 
lprm 是用来取消列印要求的指令。 通常我们有时会印错，或是误送非文字档资料至 printer , 此时就必须利用 lprm 取消列印 request ，以免造成资源的浪费。
用法:
lprm -P[ printer ] [ Jobs id | username ] 
lprm 用来清除 printer queue 中的 Jobs , 如果你使用 Job Id 作为参数，则它将此 Job 自printer queue 清除，如果你用 username作为参数，则它将此 queue中所有 Owner 为此username 的 Jobs 清除。
九. 更改个人使用资料:
1. passwd
passwd 是用来更改你的使用密码，用法为:
passwd [ username ]
在使用 passwd 的时候，它会先问你的旧密码，然後询问两次要更改的密码，确定无误後才将你的密码改掉。
2. chsh
chsh 是提供使用者更换 login shell 的指令，你可经由此更换自己使用的 shell 。

http://askubuntu.com/questions/166420/how-to-detect-an-usb-device