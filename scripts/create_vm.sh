#!/bin/bash

VMIUT=/home/public/vm/bin/vmiut

NAME=$0
IP=$1

$VMIUT creer $NAME
$VMIUT start $NAME
$VMIUT info $NAME