#!/bin/sh

iptables -t nat -A POSTROUTING -s 10.89.0.0/24 -o eth0 -j MASQUERADE