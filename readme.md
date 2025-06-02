CTF Writeups / Notes
======================================

Abstracted POC scripts for (retired) HackTheBox and TryHackMe CTF challenges. A collection of notes on tools, concepts, services, etc that were helpful for pwning boxes for network security research and learning can be found below.

Tools
-----

### [Nmap](https://nmap.org/)

<p>
    Can be installed with <code>sudo apt install nmap</code>
</p>

#### Ping all devices on network

* **-sn** flag disables port scan
* ping scan only
* may want to use **ip addr / ifconfig / ipconfig** first to find local subnet if using as an IP scanner
* Utilizes CIDR notation
    > Example: 192.168.0.0/24 (all IPs on the 192.168.0 subnet)

<code>
    nmap -sn *x.x.x.x*
</code>

#### Extended Ping Scan

* **-p** flag enables port selection
* **-p-** flag scans *all* ports
* Recommended to use **-T5** or **--min-rate** flag to speed up process

### [ExploitDB](https://www.exploit-db.com/)

<p>
    Can be installed with <code>sudo apt install exploitdb</code>
</p>

* lookup CVEs from CLI
* search by service name
    > Example: searchsploit Icecast 2.1

<code>
searchsploit <em>servicename serviceversion</em>
</code>