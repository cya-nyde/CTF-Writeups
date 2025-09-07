Cya-nyde's Notes
================

A collection of information regarding tools, exploits, services, tactics, etc. that I personally found helpful and/or important. 

\***Not intended as a full cheatsheet**\*

Tools
-----

### [Hashcat] (https://hashcat.net/hashcat/)

Can be installed with `sudo apt install hashcat`

#### Syntax

<code>hashcat -a \<mode> -m \<hash type> \<hash file></code>

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

### [MetaSploit](https://www.metasploit.com/)

#### Syntax

<code>msfconsole</code>

- <code>search</code> to search for modules
- <code>use</code> to load a module

#### Helpful Modules

- **post/multi/recon/local_exploit_suggester** - used after initial access to suggest privilege escalation pathways
- **post/multi/manage/shell_to_meterpreter** - script to upgrade simple shell to meterpreter shell, making it much more stable

### [Vim](https://www.vim.org/)

#### Command Mode Keys

- Movement
    - **h** - Cursor left
    - **i** - Cursor right
    - **j** - Cursor down
    - **k** - Cursor Up
    - **$** - End of line
    - **0** - Beginning of line
    - **w** - Forward one word
    - **b** - Backwards one word
    - **G** - End of file
    - **gg** - Beginning of file
    - **\`.** - Last edit
- Editing
    - **x** - delete character
    - **u** - undo
    - **Ctrl r** - redo
    - **d** - delete mode
        - **dw** - delete word from cursor onward
        - **d0** - delete to beginning of a line (backwards)
        - **d$** - delete to end of a line (forwards)
        - **dgg** - delete to the beginning of the file (backwards)
        - **dG** - delete to the end of the file (forwards)

- Copy and Pasting
    - **yy** - copy line
    - **y$** - copy to the end of the line
    - **yiw** - copy current word without space
    - **p** - paste after
    - **P** - paste before
    - **gp** - paste after and move cursor after pasted text

#### Insert Mode Keys

- Type as normal and add/delete line breaks
- Use ctrl + c to or esc to return to *Command Mode*

#### Slash and Dot (recommended)

- **/** to enter search mode
    - type search text, then enter
    - type **cgn** and the the replacement text
    - esc to return to standard mode
    - **n** to find the next instance of the original text

#### Substitute Command - **:s**

`:s/<original text>/<replacement text>/<optional modifiers>`

- Options
    - **g** replaces all occurences of the <original text> on that line
    - **i** ignores case for search
    - **c** confirms each replacement before a change is made

Services
--------

### SSH

Can be installed and enabled with <code>sudo apt install openssh</code> and <code>sudo systemctl enable openssh</code> (may require firewall configuration on client side to work)

#### Syntax

`ssh <username>@x.x.x.x`

- Unless specified in line (bad practice), will prompt for password upon connection
- Often enabled when **port 22** is open
