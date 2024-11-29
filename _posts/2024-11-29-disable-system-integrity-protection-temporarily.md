---
layout: post
title: Disable System Integrity Protection Temporarily
date: 2024-11-29 07:55 +0800
---



System Integrity Protection (SIP) is a kernel protection mechanism designed to prevent malicious tampering with the system kernel programs. 

Even the root user is restricted from modifying certain directories, such as:

```
/System
/bin
/sbin
/usr (except for /usr/local)
```
For some software, installing numerous modules may occasionally infringe upon these protected areas. 

Therefore, it is possible to manually disable this feature; 

*However, this action introduces vulnerabilities to the system, necessitating caution during use.*

## Disable SIP

To disable SIP, do the following:

- Restart your computer in Recovery mode.

- Launch Terminal from the Utilities menu.

- Run the command `csrutil disable`.

- Restart your computer.

## Enable SIP

[Disabling and Enabling System Integrity Protection](https://developer.apple.com/documentation/security/disabling-and-enabling-system-integrity-protection)