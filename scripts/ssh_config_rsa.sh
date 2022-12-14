#!/bin/bash

REMOTE=$1
PUB_KEY=$HOME/.ssh/id_rsa.pub
echo REMOTE = $REMOTE

pub_key(){
	ssh-keygen
}

copy_id(){
	ssh-copy-id -i $PUB_KEY user@$REMOTE
}

[ -f "$PUB_KEY" ] || pub_key
copy_id

