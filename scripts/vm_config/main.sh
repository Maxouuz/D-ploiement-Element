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
    printf "\tConfiguration de l'IP statique et de la passerelle:" >&2
    local FILE=/etc/network/interfaces
    local NETWORK="192.168.194."
    local GATEWAY=2
    local IFACE="iface enp0s3 inet"
    local NEEDLE="$IFACE dhcp"
    local NEW="static\n\taddress $NETWORK$IP/24\n\tgateway $NETWORK$GATEWAY"

    sed -i "s|dhcp|static|g" "$FILE"
    echo "\taddress $NETWORK$IP/24\n\tgateway $NETWORK$GATEWAY" >> $FILE
    printf "OK\n" >&2
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



printf "-----------------------" >&2
printf "SCRIPT DE CONFIGURATION" >&2
rename
interfaces
proxy
ntp
