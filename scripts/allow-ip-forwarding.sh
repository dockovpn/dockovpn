#!/usr/bin/env bash

# This probably should be done via sed tool
# nano /etc/sysctl.conf
# net.ipv4.ip_forward=1

cp /opt/teleport/config/sysctl.conf /etc/openvpn/sysctl.conf

sysctl -p