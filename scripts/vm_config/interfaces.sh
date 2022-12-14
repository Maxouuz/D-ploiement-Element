#!/bin/bash

FILE=/etc/network/interfaces
NETWORK="192.168.194."
IP=$1
GATEWAY=2
IFACE="iface enp0s3 inet"
NEEDLE="$IFACE dhcp"
NEW="static\n\taddress $NETWORK$IP/24\n\tgateway $NETWORK$GATEWAY"

sed -i "s|dhcp|$NEW|g" "$FILE"
