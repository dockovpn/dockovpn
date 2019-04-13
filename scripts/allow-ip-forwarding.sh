#!/usr/bin/env bash

#This probably should be done via sed tool
sudo nano /etc/sysctl.conf
#net.ipv4.ip_forward=1
sudo sysctl -p