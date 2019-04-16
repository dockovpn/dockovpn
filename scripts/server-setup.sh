#!/usr/bin/env bash

apt-get update
echo 'Y' | apt-get install openvpn easy-rsa
make-cadir ~/openvpn-ca
cd ~/openvpn-ca

#need to edit vars somehow or copy entire file from somewhere
#nano vars
source vars
./clean-all
echo 'n\n\n\n\n\n\n\n\' | ./build-ca

echo 'n\n\n\n\n\n\n\n\n\n\yn\yn\' | ./build-key-server server
#need not to create challenging password
#need to answer y(yes) when asked to sign and commit certificate

#Build strong Deffi-Haufman key
./build-dh