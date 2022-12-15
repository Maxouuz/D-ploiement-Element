#!/bin/bash

VMIUT=/home/public/vm/bin/vmiut

NAME=$1
IP=$2

vm_create(){
    printf "Création : " >&2
    [ $(vm_exists) ] && printf "Existe déjà\n" >&2
	if [ $($VMIUT creer $NAME > /dev/null 2>&1) ];
		then 			
            printf "OK\n" >&2
			return 0
		else 
            printf "NOK\n" >&2
            return 1
	fi
}

vm_start(){
    printf "Démarrage : " >&2
    [ $(vm_runs) ] && printf "Déjà démarrée\n" >&2 && return 0
	if [ $($VMIUT start $NAME > /dev/null 2>&1) ]; 
		then		
            printf "OK\n" >&2
			return 0
		else 
            printf "NOK\n" >&2
            return 1
	fi
}

dhcp_ok(){
    TMP_IP=$(vm_ip)
	if [ "$TMP_IP" = "" ];
		then 
            sleep 5; 
            printf "." >&2
            dhcp_ok;
		else 
            printf "\n\tTerminé : %s\n" "$TMP_IP" >&2
            return 0;
	fi
}

dhcp_setup(){	
    printf "En attente de la configuration DHCP : " >&2
	dhcp_ok
}

vm_ip(){
	echo $($VMIUT info $NAME | grep "ip-possible" | cut -d "=" -f 2)
}

vm_exists(){
	return [ $($VMIUT info $NAME > /dev/null 2>&1) ]
}

vm_runs(){
	return [ $($VMIUT info $NAME | grep -c "running") -eq 1 ]
}

vm_create && vm_start && dhcp_setup && echo  $(vm_ip)
