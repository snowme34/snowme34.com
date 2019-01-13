# Introduction to Logs and rsyslog

## Log

Text files used to record information.

Used for analysis, monitoring, optimization, debugging or recording history.

Almost every application will use logs.

Different applications has different ways for logging.

Specialized software might be needed to analyze special logs.

## Logs in Software Development

In developing software, developers can give the user an option to enable logs or
options to use different levels of logging.

Usually it is achieved by conditional statements or compile flags.

For c/c++ specifically, developers can use preprocessor and macros to exclude
some lines from the executable and so forth.

```c++
#define NDEBUG
  assert(false); // does nothing if NDEBUG is defined
                 // gives error if NDEBUG is not defined
#ifdef NDEBUG
  // some codes
  //...
#else
  // only included in executable if NDEBUG is not defied
  // will give error
  assert((-1 == std::complex<double>{0, 0}));
#endif
std::cout << "\n";
```

## `rsyslog`

`rsyslog` is a logging service. Installed and started (as daemon) by default.

``` bash
man rsyslogd
systemctl status rsyslog
```

Config file:

```bash
man rsyslog.conf
/etc/rsyslog.conf
```

Logs path:

* message:   normal messages
* auth:      authorization
* bootstrap: boot
* kern:      kernel

```bash
/var/log
```

Logs are usually very long.

Common way to read logs:

```bash
sudo less /var/log/auth.log
sudo tail -n 10 /var/log/auth.log
sudo tail -f /var/log/syslog
```

Almost all monitoring is achieved via logs.

## Facility

`rsyslog` categorizes logs using "facility"

Facilities (from the man page above):

* auth
* authpriv
* cron
* daemon
* kern
* lpr
* mail
* mark
* news
* security (same as auth)
* syslog
* user
* uucp
* local0  through local7.

> The keyword security should not be used anymore and mark is only for internal use and therefore should not be used in applications.

## Priority/Severity Level

How severe the information is.

> The priority defines the severity of the message.

* debug
* info
* notice
* warning
* warn (same as warning)
* err
* error (same as err)
* crit
* alert
* emerg
* panic (same as emerg)

> The keywords error, warn and panic are deprecated and should not be used anymore.

## Config `rsyslog`

```bash
man rsyslog.conf # always read the man page
sudo vim /etc/rsyslog.conf
```

### Rules

Each line represents a line.

```bash
facility.priority    log_location
facility.priority    -log_location # disable syncing

# examples (3 tabs):
mail.*                                        -/var/log/mailog
*.info;mail.none;authpriv.none;cone.none      /var/message
```

From the man page:

> By default, files are not synced after each write.
> To enable syncing of log files globally, use either the "$ActionFileEnableSync" directive
> or the "sync" parameter to omfile. Enabling this option degrades performance and
> it is advised not to enable syncing unless you know what you are doing.
> To selectively disable syncing for certain files, you may prefix the file path with a minus sign ("-").

To send all logs to another server (a dedicated logging server for instance):

```bash
*.*                @192.168.1.1  (udp)
*.*                @@192.168.1.1 (tcp)
```

UDP might be **a little bit** faster but not as reliable as TCP.