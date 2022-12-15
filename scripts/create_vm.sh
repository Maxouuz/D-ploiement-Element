#!/bin/bash

VMIUT=/home/public/vm/bin/vmiut

NAME=$1
IP=$2

vm_create(){
    printf "\tCréation : " >&2
	if [ $($VMIUT lister | grep -c "\b$NAME\b") -eq 0 ];
		then 
			$($VMIUT creer $NAME > /dev/null 2>&1) 
			printf "OK\n" >&2
		else  printf "Existe déjà\n" >&2
	fi
	return 0
}

vm_start(){
    printf "\tDémarrage : " >&2
	if [ $($VMIUT info $NAME | grep -c running) -eq 0 ];
		then
			$($VMIUT start $NAME > /dev/null 2>&1)
			printf "OK\n" >&2
		else printf "Déja démarrée\n" >&2
	fi
	return 0
}

dhcp_ok(){
    TMP_IP=$(vm_ip)
	if [ "$TMP_IP" = "" ];
		then 
            sleep 5; 
            printf "." >&2
            dhcp_ok;
		else 
            printf "\n\t\tTerminé : %s\n" "$TMP_IP" >&2
            return 0;
	fi
}

dhcp_setup(){	
    printf "\tEn attente de la configuration DHCP : " >&2
	dhcp_ok
}

vm_ip(){
	echo $($VMIUT info $NAME | grep "ip-possible" | cut -d "=" -f 2)
}


printf "Création et démarrage de la VM $NAME : \n" >&2
vm_create && vm_start && dhcp_setup && echo  $(vm_ip)
