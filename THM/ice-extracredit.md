[ice (extra credit) - TryHackMe](https://tryhackme.com/room/ice) | Cya-nyde
===========================================================================

Manual exploitation of the machine in TryHackMe Ice room using the exploit found here: [CVE-2004-1561](https://github.com/ivanitlearning/CVE-2004-1561)

## Credits

- Room created by [DarkStar7471](https://tryhackme.com/p/DarkStar7471)
- Room type: Free
- Original exploit - [icecast_header.rb](https://github.com/rapid7/metasploit-framework/blob/master//modules/exploits/windows/http/icecast_header.rb) written by spoonm, Luigi Auriemma
- Adaptation used - [568-edit.c](https://github.com/ivanitlearning/CVE-2004-1561/blob/master/568-edit.c) by [ivanitlearning](https://github.com/ivanitlearning)
    - shellcode addon by [Delikon](www.delikon.de)

## Recon

<code>nmap -sV -vv 10.10.104.240</code>

