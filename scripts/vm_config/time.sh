#!/bin/bash

NTP="ntp.univ-lille.fr"
FILE=/etc/systemd/timesyncd.conf
SERVICE=systemd-timesyncd

sed -i "s/#NTP=/NTP=$NTP/g" "$FILE"
systemctl restart $SERVICE.service

