#!/bin/bash

# Need to feed key password
openvpn --config /etc/openvpn/server.conf &

# By some strange reason we need to do echo command to get to the next command
echo " "