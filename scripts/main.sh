#!/bin/bash

if [[ ! $# -eq 2 ]]; then
    echo "Nombre invalide d'arguments : attendu <nom_vm> <id_machine>"
    exit 1
fi


NAME=$1
IP=$2


TMP=/tmp/
CONF_DIR="vm_config/"

printf "Création et configuration de la VM %s (192.168.194.%s)\n" "$NAME" "$IP" >&2

TMP_IP=$(sh ./create_vm.sh $NAME)
sh ./ssh_config_rsa.sh $TMP_IP
sh ./config_vm.sh $NAME $TMP_IP $IP
