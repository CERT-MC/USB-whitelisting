#!/bin/bash

# params
mailadmin=false 
alertdest="root@localhost"
logfile="/var/log/usb.log"

declare -A statuss=( ['0']="forbidden" ['1']="allowed" )
declare -A actions=( ['A']="plugged" ['R']="unplugged" )
 
now=$(date +%d/%m/%y-%H:%M:%S)
serial=$(echo $2 | sed -r 's/[^a-z0-9\-]//gI')
devname=$(echo $3 | sed -r 's/[^a-z0-9\/]//gI')
user=$(last | grep -E "pts/.*no logout" | cut -d" " -f1 | tr "\n" " ")
allowdeny=${statuss[$4]}
hostname=$(hostname)
ips=$(ip -4 a | grep inet | grep -v "127.0.0" | tr -s " " | cut -d" " -f3 | tr "\n" " ")

if [ ! -f ${logfile} ];
then
        touch ${logfile}
        chmod 600 ${logfile}
fi
 
if [ ! ${user} ]; then
	user="unknown"
fi
 
# logging
if [ "${1}" == "A" ]; then
        echo "${now} - USB device ${actions[$1]} : ${devname} (${serial}) - user ${user} - connection ${allowdeny}" >> ${logfile}
elif [ "${1}" == "R" ]; then
        echo "${now} - USB device ${actions[$1]} : ${devname} (${serial}) - user ${user}" >> ${logfile}
fi

# alerting
if [[ ${allowdeny} = "forbidden" && ${mailadmin} = true ]]; then
	echo -e "\
USB SECURITY POLICY VIOLATION\n\n\
date and time : ${now}\n\
hostname : ${hostname}\n\
ip addresses : ${ips}\n\
logged users : ${user}\n\
unauthorized device : ${serial}" | mail -s "USB security policy violation" ${alertdest} >> ${logfile}
fi