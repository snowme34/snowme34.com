---
title: Backup Evernote Database File using Cloud Application and rsync of WSL (Windows Subsystem for Linux) with Minimum I/O Write
mathjax: false
sidebar: toc
copyright: true
comments: true
date: 2018-09-25 17:36:10
categories:
- Notes
tags: ["Trick", "Tutorial"]
---

It was the second time for me to [lose a note in Evernote](https://news.ycombinator.com/item?id=9090135).
The first one was due to a sync error. It was nothing serious but unnerving.
But I lost the second one merely after I locked my phone while
being prompted to type the password for some encrypted text in that note.
And the problem is, I have almost no direct way to know if a note is missing
considering the size of my Evernote database.

So, after searching around, I decided that, since Evernote is
still the best app for my note taking (it has unlimited cloud storage,
support for most platforms, bots for different apps etc.) and
there is no 100% secure data storage in this world, I need to
backup the database file on my own.

# Why Backup

To prevent data loss, the ultimate solution is backup, not switching application.

# Why Backup .exb File When Evernote Syncs it automatically

A note can be lost during and after synchronization. And if the damaged note or database
were synchronized, data loss is unavoidable.

# Why rsync and WSL

It is tedious to manually copy and paste the database files to other
locations (and track the version history). Storing the db directly inside
the local cloud storage sync folder is also not feasible for me since those applications
need to scan my 3.14 GB .exb file each time when I make any tiny changes to my notes.

I need a scheduled job with minimum disk usage (reading and writing).
The reading part is hard to get rid of. So the focus is I/O write usage.
I need a **binary** incremental backup. `rsync` is the best candidate
I know so far but it does not have native support
for Windows.

# My Solution

Since I need my cloud storage application to run in the background all the time, it
is not viable for me to schedule that application to sync. The workaround is to
use scheduled `rsync` to copy the .exb file to the local sync folder.

`rsync` is able to do binary incremental copy, keeping the write usage at minimum.
And the sync application only reads the local file as scheduled
(my specific application, Dropbox, can binary incremental sync, too). Unless there is
a way to directly binary incremental copy to the cloud as scheduled while the
other parts are not affected, this solution only needs 2 full scans and very
little write + upload to work.

(I know `rclone` but it [does not support binary incremental upload](https://rclone.org/faq/#why-doesn-t-rclone-support-partial-transfers-binary-diffs-like-rsync))

# Procedure

## Preparation

If not installed yet, install cloud storage sync clients, WSL for Windows,
`cron` and `rsync` based on the Linux distro installed.

## Decide the `rsync` Command

To learn more about cron, use `man cron` and `man crontab` or search online.

Please at least read the `rsync --help` and decide which options are preferred.
The following command is the one I use.

```bash
rsync -u -t -av -n /mnt/c/Evernote/Databases/myName.exb /mnt/c/Dropbox/EvernoteDB/myName.exb
```

The `-n` flag enables **dry-run**. **Remove it** after everything is confirmed to be correct by running this command
directly (and see the result).

## Create crontab Job

Log in as the user you want to run the job (note the privileges) and edit their crontab:

```bash
crontab -e
```

Using the editor chosen, add this line:

```conf
22 22 */2 * * rsync -u -t -av /mnt/c/Evernote/Databases/myName.exb /mnt/c/Dropbox/EvernoteDB/myName.exb > /dev/null
```

This is my config. It will run the command every 2 days at 22:22 (10:22 pm) and thus backup my Evernote database every 2 days.

If you want to learn more about crontab job, feel free to search on your own.

If you want, you can use the snapshot feature of rsync. But since Dropbox has pretty good version history, I did not include that.

(Since a note might be found missing after a long time, I highly recommend
manually adding backups for longer period, Like a full backup for each half year)

## Make the Daemon start at Windows Boot

The last step is to make sure the cron daemon runs in background when Windows boots.
It can be achieved by making bash.exe/wsl.exe a service and so on.

The solution I chose was to create a shortcut containing a start command in the `shell:startup` folder.
Feel free to have your own choices and search around.

First, make sure the start command can be run without root privilege, unless you want to
type in your sudo password every time you boot Windows.

Open sudo config file:

```bash
sudo visudo
```

Add the following line:

```conf
%sudo ALL=NOPASSWD: /etc/init.d/cron start
```

Save and quit and fix any problem if prompted.

Next, type `shell:startup` in the Run and explorer will open the startup folder.

Create a shortcut to wsl.exe and edit the properties as following:

```
C:\Windows\System32\wsl.exe sudo /etc/init.d/cron start
```

<blockquote class="imgur-embed-pub" lang="en" data-id="a/9TmBweC"><a href="//imgur.com/9TmBweC"></a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>

And it should work unless the developers change how wsl works in the future.

## Check If cron Service Started Properly

If you are worrying about cron service, here is a way to test it.

Create a test job in crontab. For example:

```crontab
35 * * * * echo "test" >> /home/MY_USER/test
```

It will append "test" to a file in that path for every hour at 35.

First wait for the job to run first time and check the file to see result.

Now manually terminate the cron service and reboot Windows to see if it works.

```cmd
wsl sudo /etc/init.d/cron stop
```

After reboot, check task manager to see if there is a process called `cron` running.

Wait for the to run second time and check the result.

The command above is only an example. You can change it however you like.

# Conclusion

Until now, it should be clear that what I did is only a little trick.
But it shows how Unix commands can make Windows easier to use with WSL.

# Reference

* [wsl-autostart](https://github.com/troytse/wsl-autostart)
* [How to run Ubuntu service on Windows (at startup)?](https://superuser.com/questions/1112007/how-to-run-ubuntu-service-on-windows-at-startup)
* [How To Add Jobs To cron Under Linux or UNIX](https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/)
* [rsync server using Windows Subsystem for Linux](https://serverfault.com/questions/878887/rsync-server-using-windows-subsystem-for-linux)
* [Linux Start Restart and Stop The Cron or Crond Service](https://www.cyberciti.biz/faq/howto-linux-unix-start-restart-cron/)
* [How to auto start service](https://github.com/Microsoft/WSL/issues/511)
* man page of each command