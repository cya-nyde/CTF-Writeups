# [Brute It - TryHackMe](https://tryhackme.com/room/bruteit)

Learn how to brute, hash cracking and escalate privileges in this box!

## Credits

- Room type: Free
- Created by: [ReddyyZ](https://tryhackme.com/p/ReddyyZ)

## Recon

- Perform a fairly aggressive scan on the target using `nmap -p- -sV -sC -T5 <target ip>`
    - *-p-* scans all ports, even those outside standard range
    - *-sC* enables default script scans
    - *-sV* enables service version detection
    - *-T5* sets the timing template to the fastest - useful when detection is not an issue

### How many ports are open?

> The nmap scan shows that **2** ports are open

### What version of SSH is running?

> The version reported for SSH from the nmap scan is **OpenSSH 7.6p1**

### What version of Apache is running?

> The version reported for the Apache server from the nmap scan is Apache httpd **2.4.29**

### Which Linux distribution is running?

> nmap script scan results show **Ubuntu** in the http-title

### Search for hidden directories on web server. What is the hidden directory?

- Use `ffuf -u http://<target ip>/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt:FUZZ` to fuzz for hidden directories
    - Most other directory wordlists should work
    - Can also be done with other fuzzing/directory brute forcing tools like *Gobuster* and *Feroxbuster*

> The most interesting hidden directory returned is **/admin**

## Getting a shell

### What is the user:password of the admin panel?

- Brute force admin panel using *Hydra*
    - Using `curl http://<target ip>/admin/` shows the page in raw HTML
        - There is a comment near the bottom that says `<!-- Hey john, if you do not remember, the username is admin -->`
    - Before using Hydra, use *Burpsuite*, *Zaproxy*, built in console network tab in browser, or other preferred proxy application to examine the structure of login request payload
        - When testing a random login on the portal, the payload is passed in this format: `user=admin&pass=admin`
    - `hydra -l admin -P /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar "http-post-form://<target ip>/admin/:user=^USER^&pass=^PASS^:invalid"`
        - *-l* instead of *-L* indicates use of plain text rather than a wordlist for username
        - *-P* instead of *-p* indicates use of wordlist rather than plaintext for password
            - More than one password wordlist may work in place of rockyou
        - `http-post-form` indicates the protocol to brute force over
        - `/admin/` is the directory where the login form is located and **:** separates the options
        - Referring back to the request payload, `user=^USER^` replaces `^USER^` with the *-l* argument and `pass=^PASS^` replaces `^PASS^` with the *-P* argument
        - Finally, separated by one last **:**, set "invalid" as the response that indicates a failure
            - This keyword will be different in each situation/web interface

> The user:password returned from Hydra is **admin:xavier**

### Crack the RSA key you found. What is John's RSA Private Key passphrase?

- Logging into the admin portal using the credentials from Hydra displays an RSA private key
- Download using `curl -O http://<target ip>/admin/panel/id_rsa`
- Convert private key to crackable hash using `ssh2john id_rsa > hash`
- `john hash --wordlist=/usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar`

> The cracked RSA private key passphrase is **rockinroll**

### user.txt

- SSH into the machine as John
    - `chmod 600 id_rsa` to set necessary permissions on private key file
    - `ssh -i id_rsa john@<target ip>` and enter the cracked passphrase when prompted
- `cat user.txt` to show user flag

> <details><summary>The user flag is </summary>THM{a_password_is_not_a_barrier}</details>