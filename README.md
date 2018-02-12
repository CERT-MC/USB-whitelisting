
# USB-whitelisting

## Purpose

This set of scripts is aimed at allowing only specific USB devices (whitelist) to be mounted on a linux host

## Requirements

The scripts have been tested successfully on a XUBUNTU 16.04 LTS distribution.

There are no particular requirements or dependencies. If you intend to use email alerting, you only need to install a mailer daemon such as Postfix and the mailutils package.

## Installation

You need to copy [99-udisks2.rules](https://github.com/CERT-MC/USB-whitelisting/blob/master/scripts/99-udisks2.rules) in the /etc/udev/rules.d/ directory of your system and to reload new udev rules

    sudo wget -o /etc/udev/rules.d/99-udisks2.rules https://github.com/CERT-MC/USB-whitelisting/blob/master/scripts/99-udisks2.rules
    sudo udevadm control --reload

As you can see in this file, a list of authorized devices has been provided as an example. Obviously you'll have to delete those lines and add your personal devices instead.

    # LIST OF AUTHORIZED USB DEVICES
    ACTION=="add", ENV{ID_FS_USAGE}=="filesystem", ENV{ID_SERIAL_SHORT}=="160400005", ENV{OK}="1"
    ACTION=="add", ENV{ID_FS_USAGE}=="filesystem", ENV{ID_SERIAL_SHORT}=="182E9D", ENV{OK}="1"
    ACTION=="add", ENV{ID_FS_USAGE}=="filesystem", ENV{ID_SERIAL_SHORT}=="60A44C413812", ENV{OK}="1"

Download the script [usb.sh](https://github.com/CERT-MC/USB-whitelisting/blob/master/scripts/usb.sh) and copy it into your /usr/local/sbin directory

    sudo wget -o /usr/local/sbin/usb.sh https://github.com/CERT-MC/USB-whitelisting/blob/master/scripts/usb.sh
    sudo chmod 700 /usr/local/sbin/usb.sh

From now on, the restrictions are in place and only specifically allowed USB devices will be mounted on your system and will be displayed on your desktop.

A logfile (/var/log/usb.log by default) is appended each time a USB device is inserted of the system, for security purpose.

    09/02/18-15:07:15 - USB device plugged : /dev/sdc1 (60A44C3FAE22) - user alice  - connection forbidden
    09/02/18-15:07:51 - USB device unplugged :  (60A44C3FAE22) - user alice
    09/02/18-15:07:55 - USB device plugged : /dev/sdc1 (60A44C3FAE22) - user alice  - connection forbidden
    09/02/18-15:09:03 - USB device unplugged :  (60A44C3FAE22) - user alice
    09/02/18-15:09:04 - USB device unplugged :  (1828CE9D) - user alice 
    09/02/18-15:09:16 - USB device plugged : /dev/sdb1 (1604000000033) - user bob  - connection allowed
    09/02/18-15:10:04 - USB device unplugged :  (1604000000033) - user bob

If you wish to warn the sysadmin, each time a unknow USB device is plugged to the system, you can configure the USB.SH script as below.

    mailadmin=true
	alertdest="root@localhost"

## Generation of USB devices list

A script [serial.sh](https://github.com/CERT-MC/USB-whitelisting/blob/master/scripts/serial.sh) is provided to help you generate the list of allowed USB devices.

All you need to do is execute the script, insert a device, hit the ENTER key and unplug the device. The serial should be displayed. Repeat the steps for each of your devices.

root@bruno-virtual-machine:~# ./serial.sh 
    60A44C3FAE22B0[enter]
    60A44C4138D1BF[enter]
    16040000000330[enter]
    [q]
    
    ACTION=="add", ENV{ID_FS_USAGE}=="filesystem", ENV{ID_SERIAL_SHORT}=="1604000000033005", ENV{OK}="1"
    ACTION=="add", ENV{ID_FS_USAGE}=="filesystem", ENV{ID_SERIAL_SHORT}=="60A44C3FAE22B01139790017", ENV{OK}="1"
    ACTION=="add", ENV{ID_FS_USAGE}=="filesystem", ENV{ID_SERIAL_SHORT}=="60A44C4138D1BFB17808B1D5", ENV{OK}="1"

When you're done, just type the "q" key and the set of lines will be displayed. You have to copy those lines into your 99-udisks2.rules file, in the "# LIST OF AUTHORIZED USB DEVICES" section.

