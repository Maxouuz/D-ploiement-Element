#!/bin/bash

NAME=$1
TMP=$2
ID=$3
IP="192.168.194.$ID"
OUT=/tmp/
SRC=vm_config/

transfer(){
	printf "\tTransfert par SCP:%s%s" "$SRC" "$IP" >&2
	scp -r $SRC user@$TMP:$OUT
	printf "\t\tOK\n" >&2
}

config(){
	printf "\tExécution du script:\n" >&2
	printf "\t\tConnexion à  root (mdp: root) >" >&2
	ssh -t user@$TMP "su - root -c \"sh \"$OUT$SRC\"config.sh $NAME $ID && systemctl reboot\""
	printf "\n\t\tConfiguration terminée\n" >&2
}

update(){
	printf "\tMise à jour de la VM:\n" >&2
	ssh -t user@$TMP "su - root -c \"sh \"$OUT$SRC\"apt_sudo.sh\""
	printf "MàJ terminée !\n" >&2
}

printf "Exécution du script de configuration\n" >&2
transfer
config
update
