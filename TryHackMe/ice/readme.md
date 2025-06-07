Ice Room - TryHackMe | Cya-nyde
===============================

## Recon

Recon is performed using nmap with the **-sV** flag to enumerate service versions and **-vv** flag to increase verbosity.

<code>nmap -sV -vv \<ip address></code>

We can see the following ports are open on this machine:

- 135/tcp   open  msrpc        Microsoft Windows RPC
- 139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
- 445/tcp   open  microsoft-ds Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
- 3389/tcp  open  tcpwrapped
- 5357/tcp  open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
- 8000/tcp  open  http         Icecast streaming media server
- 49152/tcp open  msrpc        Microsoft Windows RPC
- 49153/tcp open  msrpc        Microsoft Windows RPC
- 49154/tcp open  msrpc        Microsoft Windows RPC
- 49158/tcp open  msrpc        Microsoft Windows RPC
- 49159/tcp open  msrpc        Microsoft Windows RPC
- 49160/tcp open  msrpc        Microsoft Windows RPC

We are also given the following service info:

- Host: DARK-PC; OS: Windows; CPE: cpe:/o:microsoft:windows

> ### Once the scan completes, we'll see a number of interesting ports open on this machine. As you might have guessed, the firewall has been disabled (with the service completely shutdown), leaving very little to protect this machine. One of the more interesting ports that is open is Microsoft Remote Desktop (MSRDP). What port is this open on?

- MSRDP's default port is **3389**, which is open.

> ### What service did nmap identify as running on port 8000? (First word of this service)

- Our nmap scan returned <code>8000/tcp  open  http         Icecast streaming media server</code> as one of the results
- **Icecast** is the service running on port 8000

> ### What does Nmap identify as the hostname of the machine? (All caps for the answer)

- <code>Host: DARK-PC; OS: Windows; CPE: cpe:/o:microsoft:windows</code>
- Hostname is **DARK-PC**

## Gain Access

Icecast will be our foothold to gain access in this room, so we will look up icecast vulnerabilities. In this example, I will use exploitdb which is already installed on Kali Linux.

<code>searchsploit icecast</code>

This give us the following listings: 

```
Icecast 1.1.x/1.3.x - Directory Traversal                                                                                                                                                             | multiple/remote/20972.txt
Icecast 1.1.x/1.3.x - Slash File Name Denial of Service                                                                                                                                               | multiple/dos/20973.txt
Icecast 1.3.7/1.3.8 - 'print_client()' Format String                                                                                                                                                  | windows/remote/20582.c
Icecast 1.x - AVLLib Buffer Overflow                                                                                                                                                                  | unix/remote/21363.c
Icecast 2.0.1 (Win32) - Remote Code Execution (1)                                                                                                                                                     | windows/remote/568.c
Icecast 2.0.1 (Win32) - Remote Code Execution (2)                                                                                                                                                     | windows/remote/573.c
Icecast 2.0.1 (Windows x86) - Header Overwrite (Metasploit)                                                                                                                                           | windows_x86/remote/16763.rb
Icecast 2.x - XSL Parser Multiple Vulnerabilities                                                                                                                                                     | multiple/remote/25238.txt
icecast server 1.3.12 - Directory Traversal Information Disclosure                                                                                                                                    | linux/remote/21602.txt
```

