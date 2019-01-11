#!/bin/bash

#you will need msmtp configured
#crontab */5 * * * * /foo/bar/check_ip.sh

ip_file=~/.ip
if [ ! -f "$ip_file" ]; then touch $ip_file; fi

last=$(cat "$ip_file")
current=$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short) || exit
if [ "$last" == "$current" ]; then exit; fi

mail -s "[IP]" email@email.com <<< "$current"
if [ "$?" -eq 0 ]; then echo "$current" > "$ip_file"; fi
