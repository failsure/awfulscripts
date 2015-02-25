#!/bin/bash

TDUSER=`head -n 1 /root/transauth`
TDPASS=`tail -n 1 /root/transauth`

getport() {
	PIAIP=`ip addr | grep tun0$ | cut -d ' ' -f 6`
	PIAUSER=`head -n 1 /etc/openvpn/cred`
	PIAPASS=`tail -n 1 /etc/openvpn/cred`
	PIAID=`cat /etc/openvpn/client_id`

	PIAPORT=`curl -d "user=$PIAUSER&pass=$PIAPASS&client_id=$PIAID&local_ip=$PIAIP" https://www.privateinternetaccess.com/vpninfo/port_forward_assignment -s | grep -o '[0-9]\+'`
}

setport() {
	echo "Port reset to: $PIAPORT"
	transmission-remote -n $TDUSER:$TDPASS -p $PIAPORT
}

if [ `transmission-remote -n $TDUSER:$TDPASS -pt | cut -d ' ' -f 4` = "No" ]
then
	getport
	setport
fi
