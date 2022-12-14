#!/bin/bash

REMOTE=$1
PUB_KEY=$HOME/.ssh/id_rsa.pub
echo REMOTE = $REMOTE

if [ -f "$PUB_KEY" ]; 
	then echo Clef publique RSA existante.
	else 
		echo Pas de clef publique RSA, création;
		ssh_keygen
fi

ssh-copy-id -i $PUB_KEY user@$REMOTE

SSH_ALIAS=blabla
