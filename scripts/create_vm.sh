#!/bin/bash

VMIUT=/home/public/vm/bin/vmiut

NAME=$1
IP=$2

vm_create(){
	$VMIUT creer $NAME > /dev/null 2>&1
}

vm_start(){
	$VMIUT start $NAME > /dev/null 2>&1
}

dhcp_ok(){
	CURR_IP=$(vm_ip)
	if [ "$CURR_IP" = "" ];
		then sleep 5;  dhcp_ok
		else return 0;
	fi
}

vm_ip(){
	echo $($VMIUT info $NAME | grep "ip-possible" | cut -d "=" -f 2)
}

vm_create
vm_start
dhcp_ok
echo Machine virtuelle $NAME créée et démarrée!

