#!/usr/bin/env bash

#Should be edited with sed
ip route | grep default

# enp0s3

sudo nano /etc/ufw/before.rules

# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
# Allow traffic from OpenVPN client to enp0s3 (change to the interface you discovered!)
-A POSTROUTING -s 10.8.0.0/8 -o enp0s3 -j MASQUERADE
COMMIT
# END OPENVPN RULES

sudo nano /etc/default/ufw

#EDIT: DEFAULT_FORWARD_POLICY="ACCEPT"

sudo ufw allow 1194/udp
sudo ufw allow OpenSSH

sudo ufw disable
sudo ufw enable