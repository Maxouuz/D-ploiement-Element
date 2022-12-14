#!/bin/bash

NAME=$1
IP=$2

TMP=/tmp/
CONF_DIR="vm_config/"

TMP_IP=$(sh ./create_vm.sh $NAME)
sh ./ssh_config_rsa.sh $TMP_IP
scp -r $CONF_DIR user@$TMP_IP:$TMP
ssh user@$TMP_IP "su -c root -c \"sh $TMP$CONF_DIR/main.sh $NAME $IP && systemctl reboot\""
