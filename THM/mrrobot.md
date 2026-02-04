# [Mr Robot - TryHackMe](https://tryhackme.com/room/mrrobot) | 0x00FFFF

Based on the Mr. Robot show, can you root this box?

## Credits

- Created by [tryhackme](https://tryhackme.com/p/tryhackme) and [ben](https://tryhackme.com/p/ben)
- Room Type: Free

## Recon

- *nmap* scan IP to determine open ports
    - `nmap -A -v <target ip>`
- Check for *robots.txt* to find disallowed directories
    - http://<target ip>/robots.txt shows the following entries
        - `User-agent: *
            fsocity.dic
            key-1-of-3.txt`

## Discovery

- Navigate to http://<target ip>/key-1-of-3.txt for **first key**
    - **073403c8a58a1f80d943455fb30724b9**

## Recon
    - Find hidden subdirectories
        - `ffuf -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt:FUZZ -u http://<target ip>/FUZZ`
    