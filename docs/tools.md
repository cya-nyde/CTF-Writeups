Notes on Tools
===================

Previously included in general notes; syntax and usage for common enumeration, weaponization, and exploitation tools.

## Enumeration

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

#### Timing Presets

* `-T<number 1-5>` to select a timing template
    * The higher the number, the faster and more detectable

<code>nmap -T5 \<target ip></code>

#### Other Helpful Flags

* **-sV** flag enables service version detection
* **-sC** flag enables default script scan
    * **--script=** allows you to select a specific script

#### Scripts

- **smb-os-discovery** - returns hostname for devices using SMB
- **http-enum** - enumerates web server directories and vulnerabilities
- **vulners** - enumerates vulnerabilities
- **dns-zone-transfer** - attempts DNS zone transfer to show backend information

### [ExploitDB](https://www.exploit-db.com/)

<p>
    Can be installed with <code>sudo apt install exploitdb</code>
</p>

#### Syntax

<code>searchsploit \<service name> \<service version></code>

* lookup CVEs from CLI
* search by service name
    > Example: searchsploit Icecast 2.1

## Web App

### [ffuf](https://github.com/ffuf/ffuf)

#### Syntax

<code>ffuf -w \<path to wordlist>:<FUZZ keyword (may specify multiple wordlists mapped to multiple fuzz keywords)> -u \<full url> -H \<Header (optional)></code>

#### **Important Notes:**

- Must add FUZZ keyword(s) into URL or header as the attack position

## Password

### [Hydra](https://github.com/vanhauser-thc/thc-hydra)

Can be installed with `sudo apt install hydra`

#### Syntax

<code>hydra -l \<USER> -p \<PASS> \<target ip> -s \<target port> \<mode> "\<mode options>"</code>

##### **Important Notes:**

- Use `-l` for user if manually specifying and `-L` if using a wordlist
- Use `-p` for pass if manually specifying and `-P` if using a wordlist

#### Supported Services

- ssh
- http(s)-get
- http(s)-post
- http(s)-post-form
- + more in Hydra's man page

#### HTTP-Post-Form Example

- `hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.19.1 -s 8080 http-post-form "/login.php:username=^USER^&password=^PASS^:Invalid"`
    - Put module options in ""
    - Specified module is *http-post-form*
    - /login.php is the login page
    - *username* and *password* are the field arguments in the HTTP request
        - You will need to use a proxy to figure out what the field names are before running this attack
    - *Invalid* filters out responses with the word "Invalid" in the body

### [Hashcat] (https://hashcat.net/hashcat/)

Can be installed with `sudo apt install hashcat`

#### Syntax

<code>hashcat -a \<mode> -m \<hash type> \<hash file></code>

## C2

### [MetaSploit](https://www.metasploit.com/)

#### Syntax

<code>msfconsole</code>

- <code>search</code> to search for modules
- <code>use</code> to load a module

#### Helpful Modules

- **post/multi/recon/local_exploit_suggester** - used after initial access to suggest privilege escalation pathways
- **post/multi/manage/shell_to_meterpreter** - script to upgrade simple shell to meterpreter shell, making it much more stable