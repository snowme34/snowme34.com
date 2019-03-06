# Linux Email Service

The email services.

Born in 1960s.

Consists of many components. Not achieved by single service.

For formal communications.

## Basics

Below is one possible email infrastructure.

[schema](https://i.imgur.com/PVyVugV.png)

### MxA

MSA (Mail Submission Agent) will be ignored for simplicity.

MUA

* Mail User Agent
* The client software, such as Thunderbird.
* And the web email applications, such as Gmail web app.

MTA

* Mail Transfer Agent
* Server-side program.
*Implements SMTP, transfers the email.

MDA

* Mail Deliver Agent
* When MTA receives new email, MDA will store the email to the server.

MRA

* Mail Receive Agent
* Implements IMAP or POP3.
* Communicates with clients, sends email to clients using IMAP or POP3.

### Main Protocols

SMTP

* Simple Mail Transfer Protocol
* All emails are sent using SMTP

IMAP

* Internet Message Access Protocol
* Email clients use IMAP to fetch emails from server
  
POP3

* Post Office Protocol
* Email clients use IMAP to fetch emails from server

## MUA

Email Client.

The only component that users can interact directly with.

Common ones:

* outlook
* mac mail
* thunderbird
* mutt

Web-based MUA is more common: gmail

## IMAP POP3

The standard protocols used for communications between email clients and servers.

MUA uses IMAP and POP3 to **retrieve** emails.

Users can decide if they want to keep the emails in the server
after retrieval. Decades ago it was crucial since the storage
is limited, but today people don't care anymore.

### Difference between IMAP and POP3

IMAP will "sync" all the operations, including read/unread, star and so on.

POP3 downloads all the emails. All the operations are local and they do
not affect the ones in the server.

Again, this is a question of old days. Due to stability and bandwidth limit,
people in old days prefer POP3 since it was more stable. But today IMAP is
recommended.

## MTA SMTP

The actual email server software component.

Uses SMTP (simple email transfer protocol) to **send** emails.

MUA uses SMTP to communicate with MTA.

MTA is responsible for communication between different mail servers.

Common MTA:

* sendmail
* postfix

MTA is only responsible for *transferring* emails.

## MDA

Stores the emails received by MTA to the server.

Usually MTA and MDA are closely related, but still separated.
They can be treated as a whole.

Path ([How can I find my local mail spool?](https://unix.stackexchange.com/questions/82910/how-can-i-find-my-local-mail-spool)):

```bash
/var/spool/mail/$USER
```

Why Separated from MTA

* MDA can also filter the spam emails and scan the virus.
* Please look this up on your own :)

Common MDA

* procmail
* maildrop

The default MDA of sendmail and postfix is procmail.

## MRA

Implements IMAP, POP3.

Communicates with MUA. Will return the emails via IMAP or POP3 after
MUA requests them.

The only part that MUA interact with when retrieving emails.

The reason why we need to provide 2 addresses for the MUA config

* SMTP -> MTA
* IMAP/POP3 -> MRA

Common MRA

* Dovercot

Usually will encrypt the communication. So people today
have 2 more protocols:

* IMAPS
* POP3S

## Email Address

There are 2 types of email addresses.

```bash
user@mail.web.net
username@hostname-of-email-server

user@web.net
username@domain
```

The second one is more common.

But it does not specify the email server (the actual server
that processes emails).

And MX record is used in such situation.

Use DNS to lookup the MX record to get the actual address
of the mail server.

```bash
dig -t mx gmail.com
```

## Read More

* [Running a Mail Server - Linode](https://www.linode.com/docs/email/running-a-mail-server/)
* [Extended SMTP - Wikipedia](https://en.wikipedia.org/wiki/Extended_SMTP)
* [8.5. Setting Up Your System To Use E-Mail](https://www.debian.org/releases/stable/i386/ch08s05.html.en)