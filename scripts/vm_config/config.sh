#!/bin/bash

NAME=$1
IP=$2

rename(){
    printf "\tRenommage de la VM en %s" "$NAME :" >&2
    echo $NAME > /etc/hostname
    sed -i "s/debian/$NAME/g" /etc/hosts
    printf "OK\n" >&2
}

interfaces(){    
    printf "\tIP statique et Passerelle:\n" >&2
    local FILE=/etc/network/interfaces
    local NETWORK="192.168.194."
    local GATEWAY=2
    local IFACE="iface enp0s3 inet"
    local NEEDLE="$IFACE dhcp"
    local NEW="static\n\taddress $NETWORK$IP/24\n\tgateway $NETWORK$GATEWAY"
	printf "\t\tIP : %s\n" "$NETWORK$IP" >&2
	printf "\t\tPasserelle : %s\n" "$NETWORK$GATEWAY" >&2
    sed -i "s|dhcp|static\n\taddress $NETWORK$IP/24\n\tgateway $NETWORK$GATEWAY|g" "$FILE"
    printf "\t\tOK\n" >&2
}

proxy(){
    printf "\tConfiguration du proxy:" >&2
    echo "HTTP_PROXY=http://cache.univ-lille.fr:3128
HTTPS_PROXY=http://cache.univ-lille.fr:3128
http_proxy=http://cache.univ-lille.fr:3128
https_proxy=http://cache.univ-lille.fr:3128
NO_PROXY=localhost,192.168.194.0/24,172.18.48.0/22" >> /etc/environment
    printf "OK\n" >&2
}

ntp(){
    printf "\tConfiguration du NTP:" >&2
    local NTP="ntp.univ-lille.fr"
    local FILE=/etc/systemd/timesyncd.conf
    local SERVICE=systemd-timesyncd

    sed -i "s/#NTP=/NTP=$NTP/g" "$FILE"
    systemctl restart $SERVICE.service 
    printf "OK\n" >&2
}


update(){
	printf "\tMise à jour de la VM:" >&2
	apt-get update > /dev/null 2>&1
	apt-get full-upgrade -y > /dev/null 2>&1
}



printf "%s\n" "-----------------------" >&2
printf "SCRIPT DE CONFIGURATION\n" >&2
rename
interfaces
proxy
ntp
#sudo
#update
printf "FIN\n" >&2
printf "%s\n" "-----------------------" >&2
