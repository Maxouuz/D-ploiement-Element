#!/bin/bash

NAME=$1
IP=$2
DIR=/tmp/vm_config

printf "-----------------------" >&2
printf "SCRIPT DE CONFIGURATION" >&2
sh $DIR/name.sh $1
sh $DIR/interfaces.sh $2
sh $DIR/proxy.sh
$(sh "$DIR/time.sh")
sh $DIR/update.sh
