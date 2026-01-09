# [TakeOver - TryHackMe](https://tryhackme.com/room/takeover) | 0x00FFFF

This challenge revolves around subdomain enumeration.

## Credits

- Room created by:
    - [JohnHammond](https://tryhackme.com/p/JohnHammond)
    - [cmnatic](https://tryhackme.com/p/cmnatic)
    - [fumenoid](https://tryhackme.com/p/fumenoid)
    - [timtaylor](https://tryhackme.com/p/timtaylor)
- Room type: Free
- Difficulty: Easy

## Recon

- Add the provided FQDN to `/etc/hosts`
    - <target ip>   futurevera.thm
- Scan for subdomains/VHOSTS
    - `ffuf -w /usr/share/wordlists/SecLists/Discovery/Web-Content/raft-medium-directories.txt:FUZZ -u http://FUZZ.futurevera.thm/`
    - `ffuf -w /usr/share/wordlists/SecLists/Discovery/Web-Content/raft-medium-directories.txt:FUZZ -u http://futurevera.thm/ -H "Host: FUZZ.futurevera.thm"`
- VHOSTS discovered:
    - portal, Portal
    - payroll, Payroll
