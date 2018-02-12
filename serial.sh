#!/bin/bash
devices=$(mktemp devices.XXX)
while [ "${key}" != "q" ]; 
do
        serial=$(udevadm info --query=all --name=/dev/sdb | grep ID_SERIAL_SHORT | cut -d"=" -f2)
        echo ${serial} >> ${devices}
        echo ${serial} 
        read -s -n 1  key
done
for device in $(cat ${devices} | sort | uniq)
do
        echo "ACTION==\"add\", ENV{ID_FS_USAGE}==\"filesystem\", ENV{ID_SERIAL_SHORT}==\"${device}\", ENV{OK}=\"1\""
done
rm $devices