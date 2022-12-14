#!/bin/bash

NAME=$1

echo $NAME > /etc/hostname
sed -i "s/debian/$NAME/g" /etc/hosts
