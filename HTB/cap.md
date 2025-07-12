# [Cap](https://app.hackthebox.com/machines/Cap) | Cyanyde

Cap is an easy difficulty Linux machine running an HTTP server that performs administrative functions including performing network captures. Improper controls result in Insecure Direct Object Reference (IDOR) giving access to another user's capture. The capture contains plaintext credentials and can be used to gain foothold. A Linux capability is then leveraged to escalate to root.

### How many TCP ports are open?

<code>nmap \<target ip></code> returns:

```
PORT   STATE SERVICE
21/tcp open  ftp
22/tcp open  ssh
80/tcp open  http
```

> There are **3** TCP ports open on the target machine

### After running a "Security Snapshot", the browser is redirected to a path of the format `/[something]/[id]`, where `[id]` represents the id number of the scan. What is the `[something]`?

We are fed this url after selecting "Security Snapshot" on the webpage: `http://x.x.x.x/data/x`

> The [something] in question is /**data**/

### Are you able to get to other users' scans?

- There seems to be an index in the url following `/data/` that allows you to select other scans
- Since indexes start from 0, we can try accessing the first scan by changing the index number to 0

> **Yes**, we can get other users' scans

### What is the ID of the PCAP file that contains sensative data?

> The pcap file with an ID of **0** contains sensitive data

### Which application layer protocol in the pcap file can the sensetive data be found in?

> As you scroll through the pcap file, you will notice a plaintext password sent as a request over **FTP**

- #### For the purposes of this writeup, the password is intentionally not listed

### We've managed to collect nathan's FTP password. On what other service does this password work?

- Looking back at our *nmap* scan results we can see FTP, SSH, and HTTP are the services running on it
- We already know the password works on FTP and HTTP is running the web page we got the pcap from initially

> By trying the password against **SSH**, we can login to the system

### Submit the flag located in the nathan user's home directory.

- When we authenticate to SSH using Nathan's credentials, we are in his home directory by default
- Using `ls`, we can find the name of the file containing the user flag (user.txt)

>  <details><summary><code>cat user.txt</code> to get the flag: </summary>3fdaedf7b90fc1afaf506f4a759d9609</details>

### What is the full path to the binary on this machine has special capabilities that can be abused to obtain root privileges?

### Submit the flag located in root's home directory.
