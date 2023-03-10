#!/bin/bash

REMOTE=$1
PUB_KEY=$HOME/.ssh/id_rsa.pub

copy_id(){
	printf "\tPartage de la clef publique avec la machine virtuelle:\n"
	printf "\t\tConnexion à user (mdp: user):" >&2
	ssh-copy-id -i $PUB_KEY user@$REMOTE > /dev/null 2>&1
	printf "\t\tOK\n" >&2
}

ssh_agent(){
	printf "\tMise en place de l'agent SSH:\n" >&2
	if [ -z "$SSH_AUTH_SOCK" ] ; 
	then
      		eval `ssh-agent -s` > /dev/null
      		ssh-add $PUB_KEY > /dev/null 2>&1
		printf "\t\tConfiguré\n" >&2
	else
		printf "\t\tTourne déjà\n" >&2
	fi
	return 0
}

rsa_key(){
	printf "\tPrésence de la clef RSA publique : " >&2
	if [ -f "$PUB_KEY" ]; 
		then
			printf "OK\n" >&2
		else
			printf "\tGénération"
			ssh-keygen > /dev/null 2>&1
	fi
}

printf "Configuration et partage de la clef RSA-SSH:\n"
rsa_key
ssh_agent
copy_id
exit 0
