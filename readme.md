CTF Writeups / Notes
======================================

Abstracted POC scripts for (retired) HackTheBox and TryHackMe CTF challenges. A collection of notes on tools, concepts, services, etc that were helpful for pwning boxes for network security research and learning can be found below.

Tools
-----

### [Nmap](https://nmap.org/)

<p>Can be installed with <code>sudo apt install nmap</code></p>

#### Syntax

<code>nmap \<flags> \<ip> </code>

#### Ping all devices on network

* **-sn** flag disables port scan
* ping scan only
* may want to use **ip addr / ifconfig / ipconfig** first to find local subnet if using as an IP scanner
* Utilizes CIDR notation
    > Example: 192.168.0.0/24 (all IPs on the 192.168.0 subnet)

<code>nmap -sn <em>x.x.x.x</em></code>

#### Extended Ping Scan

* **-p** flag enables port selection
* **-p-** flag scans *all* ports
* Recommended to use **-T** or **--min-rate** flag to speed up process
    * **-T** 1-5 selects timing template - 5 is the fastest
    * **--min-rate** sends packets no slower than the number it is set equal to

<code>nmap <em>x.x.x.x</em> -p- -T5</code>

### [ExploitDB](https://www.exploit-db.com/)

<p>Can be installed with <code>sudo apt install exploitdb</code></p>

#### Syntax

<code>searchsploit \<service name> \<service version></code>

* lookup CVEs from CLI
* search by service name
    > Example: searchsploit Icecast 2.1

<code>searchsploit <em>servicename serviceversion</em></code>

Services
--------

### SSH

#### Syntax

<code>ssh \<username>@\<target ip></code>

* With no additional flags, password will be prompted after pressing enter
* Can be installed and enabled in Linux with <code>sudo apt install openssh</code> and <code>sudo systemctl enable openssh</code> (may require firewall configuration to work)
* Must be installed as an optional feature in modern versions of Windows
