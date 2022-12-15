#!/bin/bash

NAME=$1
IP=$2

OUT=/tmp/
SRC=vm_config/

transfer(){
	printf "\tTransfert par SCP:" >&2
	scp -r $SRC user@$IP:$OUT
	printf "\t\tOK\n" >&2
}

config(){
	printf "\tExécution du script:\n" >&2
	printf "\t\tConnexion à  root (mdp: root) :" >&2
	ssh -t user@$IP "su - root -c \"sh \"$OUT$SRC\"main.sh $NAME $IP && systemctl reboot\""
	printf "Configuration terminée" >&2
}

update(){
	ssh -t user@$IP "su - root -c \"apt-get update && apt-get full-upgrade"
}

printf "Transfert et exécution du script de configuration\n" >&2
transfer
# config
update
