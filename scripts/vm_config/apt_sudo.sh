#!/bin/bash

update(){
	apt-get update
	apt-get -y full-upgrade
}

sudo(){
	apt-get install sudo
	usermod user -G sudo
}

update
sudo
