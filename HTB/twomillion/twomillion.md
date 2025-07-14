# [twomillion](https://app.hackthebox.com/machines/TwoMillion) | Cyanyde

TwoMillion is an Easy difficulty Linux box that was released to celebrate reaching 2 million users on HackTheBox. The box features an old version of the HackTheBox platform that includes the old hackable invite code. After hacking the invite code an account can be created on the platform. The account can be used to enumerate various API endpoints, one of which can be used to elevate the user to an Administrator. With administrative access the user can perform a command injection in the admin VPN generation endpoint thus gaining a system shell. An .env file is found to contain database credentials and owed to password re-use the attackers can login as user admin on the box. The system kernel is found to be outdated and CVE-2023-0386 can be used to gain a root shell. 

## Recon

### nmap

- Used `sudo nmap -A -vv -sV -p- <target-ip> -T5 -oA ~/Documents/CTF-Writeups/HTB/twomillion/` to start an intrusive but comprehensive scan
    - Sanitized scan results can be found [here](/HTB/twomillion/.nmap)
- Meanwhile, if put into a web browser, the target IP resolves to 2million.htb
    - Once the scan is finished, we can verify that there is an *nginx* web server running on port 80
- Some other important information from our scan:
    - Port 22 open | OpenSSH 8.9p1
    - Port 80 open | nginx
    - OS: Ubunutu

### Web Enumeration

- If we add `<target ip> 2million.htb` to our /etc/hosts file, we can now visit the page
- Running Feroxbuster in the background to find potential subdomains
    - `feroxbuster --url http://2million.htb`
- While Feroxbuster finishes, we take a look at some interesting pages including http://2million.htb/invite
- The site seems to require an invite code to register an account
    - We tested the behavior of requests using ZAP (BurpSuite will also work)
    - First, we can do some manual testing and watch the packet trace in our browser's built in developer panel
        - When trying to enter an invite code into the box at the **/invite** page, it sends a POST request to http://2million.htb/api/v1/invite/verify
        - The request is sent body contains only: `code: <invitecode>`
        - Upon verifying the code, it returns a 400 error if incorrect with the following in the response body: `error: {message: "Invite code is invalid!"}`
- The site also includes a login page at **/login**
    - The password reset link does not work
    - After throwing a few test attempt credentials at the login page, we can inspect the network requests
    - The request body looks standard, but when given an incorrect login, it returns http://2million.htb/login?error=User+not+found
        - When replacing "User+not+found" with different text, it reflects on the webpage as it is displayed - if not sanitized, could potentially be a way to leak information
        ![lol](/HTB/twomillion/250714_16h48m23s_screenshot.png)
- The /js/inviteapi.min.js directory includes the source code to generate an invite code
```
eval(function(p,a,c,k,e,d){e=function(c){return c.toString(36)};if(!''.replace(/^/,String)){while(c--){d[c.toString(a)]=k[c]||c.toString(a)}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('1 i(4){h 8={"4":4};$.9({a:"7",5:"6",g:8,b:\'/d/e/n\',c:1(0){3.2(0)},f:1(0){3.2(0)}})}1 j(){$.9({a:"7",5:"6",b:\'/d/e/k/l/m\',c:1(0){3.2(0)},f:1(0){3.2(0)}})}',24,24,'response|function|log|console|code|dataType|json|POST|formData|ajax|type|url|success|api/v1|invite|error|data|var|verifyInviteCode|makeInviteCode|how|to|generate|verify'.split('|'),0,{}))
```

#### Feroxbuster Results

We can see the following entries from our basic Feroxbuster scan return a 200 response:

```
200      GET       27l      201w    15384c http://2million.htb/images/favicon.png
200      GET        1l        8w      637c http://2million.htb/js/inviteapi.min.js
200      GET       80l      232w     3704c http://2million.htb/login
200      GET       96l      285w     3859c http://2million.htb/invite
200      GET      245l      317w    28522c http://2million.htb/images/logofull-tr-web.png
200      GET      260l      328w    29158c http://2million.htb/images/logo-transparent.png
200      GET        5l     1881w   145660c http://2million.htb/js/htb-frontend.min.js
200      GET       13l     2458w   224695c http://2million.htb/css/htb-frontend.css
200      GET       94l      293w     4527c http://2million.htb/register
200      GET       13l     2209w   199494c http://2million.htb/css/htb-frontpage.css
200      GET        8l     3162w   254388c http://2million.htb/js/htb-frontpage.min.js
200      GET     1242l     3326w    64952c http://2million.htb/
200      GET       46l      152w     1674c http://2million.htb/404
```
