CTF Writeups / Notes
======================================

Abstracted POC scripts for (retired) HackTheBox and TryHackMe CTF challenges. A collection of notes on tools, concepts, services, etc that were helpful for pwning boxes for network security research and learning can be found below.

Tools
-----

### [Nmap](https://nmap.org/)



#### Ping all devices on network

* <strong>-sn</strong> flag disables port scan
* ping scan only
* may want to use <strong>ip addr / ifconfig / ipconfig</strong> first to find local subnet if using as an IP scanner
* Utilizes CIDR notation
    > Example: 192.168.0.0/24 (all IPs on the 192.168.0 subnet)
* <code>nmap -sn x.x.x.x</code>
