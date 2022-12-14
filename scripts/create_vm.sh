#!/bin/bash

VMIUT=/home/public/vm/bin/vmiut

NAME=$1
IP=$2

vm_create(){
	if [ $($VMIUT creer $NAME > /dev/null 2>&1) ];
		then 
			# echo "VM créée!"
			return 0
		else return 1
	fi
}

vm_start(){
	if [ $($VMIUT start $NAME > /dev/null 2>&1) ]; 
		then 
			# echo "VM démarrée! "
			return 0
		else return 1
	fi
}

dhcp_ok(){
	CURR_IP=$(vm_ip)
	if [ "$CURR_IP" = "" ];
		then sleep 5;  dhcp_ok
		else return 0;
	fi
}

dhcp_setup(){
	# echo "En attente de la configuration DHCP"
	dhcp_ok
	# echo "Terminé"
}

vm_ip(){
	echo $($VMIUT info $NAME | grep "ip-possible" | cut -d "=" -f 2)
}

vm_exists(){
	if [ $($VMIUT info $NAME > /dev/null 2>&1) ];
		then return 0
		else return 1
	fi
}

vm_runs(){
	if [ $($VMIUT info $NAME | grep -c "running") -eq 1 ];
		then return 0
		else return 1
	fi
}

vm_exists || vm_create 
vm_runs || vm_start
dhcp_setup
echo  $(vm_ip)
