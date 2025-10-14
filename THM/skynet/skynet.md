# [Skynet - TryHackMe](https://tryhackme.com/room/skynet)

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

### Exploring web server

- Navigating to the server on port 80 in a web browser displays one page with a search bar
- No links
- Search and buttons do not seem functional

#### Fuzzing/Discovery

- ffuf to find hidden directories
    - `ffuf -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://<target ip>/FUZZ`
    - 301 responses: 

```
css                     [Status: 301, Size: 312, Words: 20, Lines: 10, Duration: 0ms]
js                      [Status: 301, Size: 311, Words: 20, Lines: 10, Duration: 0ms]
admin                   [Status: 301, Size: 314, Words: 20, Lines: 10, Duration: 191ms]
ai                      [Status: 301, Size: 311, Words: 20, Lines: 10, Duration: 0ms]
config                  [Status: 301, Size: 315, Words: 20, Lines: 10, Duration: 1ms]
```
    - 