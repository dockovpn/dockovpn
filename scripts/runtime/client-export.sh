#!/bin/sh

cd /usr/share/easy-rsa/pki
cp private/client.key issued/client.crt ca.crt /opt/teleport/client