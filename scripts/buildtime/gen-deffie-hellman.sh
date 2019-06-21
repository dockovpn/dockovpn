#!/bin/sh

cd /usr/share/easy-rsa

./easyrsa init-pki

./easyrsa gen-dh
# DH parameters of size 2048 created at /usr/share/easy-rsa/pki/dh.pem

#Copy DH file
cd /usr/share/easy-rsa/pki
cp dh.pem /etc/openvpn