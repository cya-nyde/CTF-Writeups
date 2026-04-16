# [MD2PDF - TryHackMe](https://tryhackme.com/room/md2pdf) | 0x00FFFF

## Credits

- Room type: Free
- Created by: [cmnatic](https://tryhackme.com/p/cmnatic), [malpha](https://tryhackme.com/p/malpha), [timetaylor](https://tryhackme.com/p/timtaylor), [congon4tor](https://tryhackme.com/p/congon4tor)

## Recon

- Scan for open ports with *nmap*
    - `nmap -A <target ip>` for all default scans
    - TCP ports 22, 80, and 5000 are open
    - Ports 80 and 5000 serve web portals
- Check for robots.txt
    - /robots.txt errors out on both port 80 and 5000
- Check for other interesting directories
    - `gobuster -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt -u http://<target ip>/FUZZ`
        - /admin
    - `gobuster -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt -u http://<target ip>:5000/FUZZ`
        - /admin
- Admin portal is accessible only by localhost

## Resource Development

- Craft a payload that attempts to access the page as localhost?
    - Use Burpsuite/Caido to intercept and send custom packets
    