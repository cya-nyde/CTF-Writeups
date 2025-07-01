[Solar, exploiting log4j - TryHackMe](https://tryhackme.com/room/solar) | Cya-nyde
============================================================

Explore CVE-2021-44228, a vulnerability in log4j affecting almost all software under the sun.

## Credits

- Room created by [JohnHammond](https://tryhackme.com/p/JohnHammond) and [tryhackme](https://tryhackme.com/p/tryhackme)
- Room type: Free

## Recon

- `nmap -p- <target ip> --min-rate 10000` to find all open ports on machine at a rate of 10000 packets per minute

```
22/tcp   open  ssh     syn-ack
111/tcp  open  rpcbind syn-ack
8983/tcp open  unknown syn-ack
```

- `nmap -sV -p <target ip>` to find the service versions of open ports

```
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
111/tcp  open  rpcbind 2-4
8983/tcp open  http    Apache Solr
```

### What service is running on port 8983? (Just the name of the software)

> 8983/tcp open  http    **Apache Solr**

## Discovery

