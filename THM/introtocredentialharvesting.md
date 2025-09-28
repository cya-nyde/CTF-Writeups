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

## What is svc-app's password?

