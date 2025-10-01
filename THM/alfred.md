# [Alfred - TryHackMe](https://tryhackme.com/room/alfred) | Cyanyde

Exploit Jenkins to gain an initial shell, then escalate your privileges by exploiting Windows authentication tokens.

## Credits

- Created by [try hack me](https://tryhackme.com/p/tryhackme)
- Room type: premium

## Initial Access

### How many ports are open?

- Scan ports and versions with Nmap
    - `nmap -sV -sC -T5 <target ip> -oN jenkinsNmap`
        - **-sV** flag to scan service version
        - **-sC** flag to enable default script scan
        - **-T5** to set timing template to fastest (no rate limit in this room)
        - **-oN <filename>** to put normal output into file

> There are **3** TCP ports open


