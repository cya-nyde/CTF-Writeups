#!/bin/bash

# | ice - TryHackMe
# | Link: https://tryhackme.com/r/room/ice
# | by Cya-nyde

help(){
    echo "Use -t to specify target and -p to specify port"
    echo "Use the -h flag to display this help menu"
}

#retrieve ip and port flags
while getopts ht:p: flag
do
    case "$flag" in
        *)
            help
            exit 0
            ;;
        h)
            help
            exit 0
            ;;
        t)
            ip=$OPTARG
            ;;
        p)
            port=$OPTARG
            ;;
        \?)
            help
            exit 1
            ;;
    esac
done

 if [ -z "$ip" || -z "$port" ]
 then
  help
  exit 1
 fi

echo "$ip"
echo "$port"