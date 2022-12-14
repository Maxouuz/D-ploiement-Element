#!/bin/bash

NAME=$1
IP=$2
DIR=/tmp/vm_config

sh $DIR/name.sh $1
sh $DIR/interfaces.sh $2
sh $DIR/proxy.sh
$(sh "$DIR/time.sh")
