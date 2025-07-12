# [twomillion](https://app.hackthebox.com/machines/TwoMillion) | Cyanyde

TwoMillion is an Easy difficulty Linux box that was released to celebrate reaching 2 million users on HackTheBox. The box features an old version of the HackTheBox platform that includes the old hackable invite code. After hacking the invite code an account can be created on the platform. The account can be used to enumerate various API endpoints, one of which can be used to elevate the user to an Administrator. With administrative access the user can perform a command injection in the admin VPN generation endpoint thus gaining a system shell. An .env file is found to contain database credentials and owed to password re-use the attackers can login as user admin on the box. The system kernel is found to be outdated and CVE-2023-0386 can be used to gain a root shell. 

## Recon

### nmap

- Used `sudo nmap -A -vv -sV -p- <target-ip> -T5 -oA ~/Documents/CTF-Writeups/HTB/twomillion/` to start an intrusive but comprehensive scan
    - Sanitized scan results can be found [here](/HTB/twomillion/.nmap)
- Meanwhile, if put into a web browser, the target IP resolves to 2million.htb
    - Once the scan is finished, we can verify that there is an *nginx* web server running on port 80
- Some other important information from our scan:
    - Port 22 open | OpenSSH 8.9p1
    - Port 80 open | nginx
    - OS: Ubunutu