Cya-nyde's Notes
================

A collection of information regarding tools, exploits, services, tactics, etc. that I personally found helpful and/or important. 

\***Not intended as a full cheatsheet**\*

Tools
-----

### [Nmap](https://nmap.org/)

<p>
    Can be installed with <code>sudo apt install nmap</code>
</p>

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

<p>
    Can be installed with <code>sudo apt install exploitdb</code>
</p>

#### Syntax

<code>searchsploit \<service name> \<service version></code>

* lookup CVEs from CLI
* search by service name
    > Example: searchsploit Icecast 2.1

### [MetaSploit](https://www.metasploit.com/)

#### Syntax

<code>msfconsole</code>

- <code>search</code> to search for modules
- <code>use</code> to load a module

#### Helpful Modules

- **post/multi/recon/local_exploit_suggester** - can run locally to search for exploits based on service versions found
- **multi/manage/shell_to_meterpreter** - upgrades standard shell to meterpreter shell
    - Can also be done using `sessions -u <session number>` or `sessions -u -l` to upgrade the most recently opened session

Services
--------

### SSH

Can be installed and enabled with <code>sudo apt install openssh</code> and <code>sudo systemctl enable openssh</code> (may require firewall configuration to work)

#### Syntax

<code>ssh \<username>@x.x.x.x</code>

- Best practice not to specify password in plaintext within the command
- SSH will prompt you for password to connect after confirming connection with the server