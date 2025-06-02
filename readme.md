CTF Writeups / Notes
======================================

Abstracted POC scripts for (retired) HackTheBox and TryHackMe CTF challenges. A collection of notes on tools, concepts, services, etc that were helpful for pwning boxes for network security research and learning can be found below.

Tools
-----

### Nmap

#### Ping all devices on network

* -sn flag disables port scan
* ping scan only
* may want to use ip addr / ifconfig / ipconfig first to find local subnet if using as an IP scanner
* Utilizes CIDR notation
    * Example: 192.168.0.0/24 (all IPs on the 192.168.0 subnet)
> nmap -sn x.x.x.x

Services
--------

