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

