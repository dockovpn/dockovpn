#!/bin/sh

# This probably should be done via sed tool
# nano /etc/sysctl.conf
# net.ipv4.ip_forward=1

cp $APP_INSTALL_PATH/config/sysctl.conf /etc/sysctl.conf

#sysctl -p /etc/sysctl.conf